//
//  VZHTTPNetworkAgent.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import "VZHTTPNetworkAgent.h"
#import "VZHTTPConnectionOperation.h"
#import "VZHTTPRequestGenerator.h"
#import "VZHTTPResponseParser.h"
#import "VZHTTPURLResponseCache.h"

//////////////////////////////////////////////////////////////////////////////////////////
// global constants
NSString* const kVZHTTPNetworkAgentThreadRunLoopName = @"VZHTTPNetworkAgentRunloopThread";
NSString* const kVZHTTPNetworkAgentOperationQueueName= @"VZHTTPNetworkAgentOperationQueue";
float const kVZHTTPNetworkAgentThreadRunLoopPriority = 0.3;

@interface VZHTTPNetworkAgent()
{
    
}
@end


@implementation VZHTTPNetworkAgent


+ (instancetype) sharedInstance
{
    static VZHTTPNetworkAgent* urlCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        urlCache = [VZHTTPNetworkAgent new];
    });
    return urlCache;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //create a runloop thread for each operation
        _runloopThread = [[NSThread alloc]initWithTarget:self selector:@selector(networkRunloopThreadEntry) object:nil];
        assert(_runloopThread);
        _runloopThread.name = kVZHTTPNetworkAgentThreadRunLoopName;
        _runloopThread.threadPriority = kVZHTTPNetworkAgentThreadRunLoopPriority;
        [_runloopThread start];
        
        _operationQueue = [NSOperationQueue new];
        _operationQueue.name = kVZHTTPNetworkAgentOperationQueueName;
        
        [VZHTTPURLResponseCache sharedCache];
    
    }
    return  self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (VZHTTPConnectionOperation* )operationForTagString:(NSString *)tagString
{
    for (VZHTTPConnectionOperation* op in self.operationQueue.operations)
    {
        if ([op.tagString isEqualToString:tagString])
        {
            return op;
        }
    }
    
    return nil;
}


- (void)cancelByTagString:(NSString *)tagString
{
    VZHTTPConnectionOperation* op = [self operationForTagString:tagString];
    [op cancel];
}

- (void)cancelAll
{
    [self.operationQueue cancelAllOperations];
}

//GET
- (VZHTTPConnectionOperation* )HTTP:(NSString*)aURlString
                  completionHandler:(void(^)(VZHTTPConnectionOperation* connection,  NSString* responseString,id responseObj, NSError* error))aCallback
{
    return [self HTTP:aURlString
               params:nil
    completionHandler:aCallback];
}


//GET
- (VZHTTPConnectionOperation* )HTTP:(NSString*)aURlString
                             params:(NSDictionary*)aParams
                  completionHandler:(void(^)(VZHTTPConnectionOperation* connection,  NSString* responseString,id responseObj, NSError* error))aCallback
{
    return [self           HTTP:aURlString
                  requestConfig:vz_defaultHTTPRequestConfig()
                 responseConfig:vz_defaultHTTPResponseConfig()
                         params:aParams
              completionHandler:aCallback];

}

// GET
- (VZHTTPConnectionOperation* )HTTP:(NSString*)aURlString
                      requestConfig:(VZHTTPRequestConfig) requestConfig
                     responseConfig:(VZHTTPResponseConfig) responseConfig
                             params:(NSDictionary*)aParams
                  completionHandler:(void(^)(VZHTTPConnectionOperation* connection, NSString* responseString,id responseObj, NSError* error))aCallback
{
    
    //1,check params
    if (!aURlString || aURlString.length == 0) {
        return nil;
    }
    else
    {
        //2, create request
        NSURLRequest* request = [[VZHTTPRequestGenerator new] generateRequestWithConfig:requestConfig URLString:aURlString Params:aParams];
        VZHTTPConnectionOperation* op = [[VZHTTPConnectionOperation alloc]initWithRequest:request];
        op.responseParser = [VZHTTPResponseParser parserWithConfig:responseConfig];
        [op setCompletionHandler:^(VZHTTPConnectionOperation *op, NSString* responseString,id responseObj, NSError *error) {
            
            if (aCallback) {
                aCallback(op,responseString,responseObj,error);
            }
            
        }];
        [self.operationQueue addOperation:op];
        
        return op;
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private methods
    
- (void)networkRunloopThreadEntry
{
    @autoreleasepool {
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
        
    }
}


@end

