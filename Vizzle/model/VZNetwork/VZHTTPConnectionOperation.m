//
//  VZHTTPConnectionOperation.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import "VZHTTPConnectionOperation.h"
#import "VZHTTPResponseParser.h"





@interface VZHTTPURLConnectionOperation()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSError *error;

@end

@interface VZHTTPConnectionOperation()
{
    
}


@end

@implementation VZHTTPConnectionOperation


- (id)init
{
    self =[super init];
    
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    //dispatch_release(vz_dispatch_serialQueue());
    //dispatch_release(vz_dispatch_concurrentQueue());
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods


-(void) setCompletionHandler:(void(^)(VZHTTPConnectionOperation* op, NSString* responseString, id responseObj, NSError* error))aCallback;
{
    
    void(^lambda)(NSString* responseString, id responseObj, NSError* err) = ^(NSString* responseString, id responseObj, NSError* err){
    
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (aCallback) { aCallback(self,responseString,responseObj,err);}
        });
    
    };
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    [self setCompletionBlock:^{

        if (self.error)
        {
            lambda(self.responseString,nil,self.error);
        }
        else
        {
            NSError* parseErr;
            id response = [self.responseParser parseResponse:(NSHTTPURLResponse*)self.response data:self.responseData error:&parseErr];
            _responseObj = response;
            
            if (parseErr) {
                self.error = parseErr;
            }
            lambda(self.responseString,self.responseObj,self.error);
        }
    }];
#pragma clang diagnostic pop
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override methods


- (void)pause {
    int64_t offset = 0;
    if ([self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey]) {
        offset = [(NSNumber *)[self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] longLongValue];
    } else {
        offset = [(NSData *)[self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey] length];
    }
    
    NSMutableURLRequest *mutableURLRequest = [self.request mutableCopy];
    
    if ([self.response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary* dict = [(NSHTTPURLResponse*)self.response allHeaderFields];
        id eTag = dict[@"ETag"];
        
        [mutableURLRequest setValue:eTag forKey:@"If-Range"];
    }

    [mutableURLRequest setValue:[NSString stringWithFormat:@"bytes=%llu-", offset] forHTTPHeaderField:@"Range"];
    self.request = mutableURLRequest;
    
    [super pause];
}








@end
