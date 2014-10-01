//
//  VZAFRequest.m
//  VizzleListExample
//
//  Created by moxin.xt on 14-9-29.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZAFRequest.h"
#import "AFNetworking.h"

@interface VZAFClient : AFHTTPSessionManager

+ (instancetype) sharedClient;

@end

@implementation VZAFClient

+ (instancetype) sharedClient
{
    static VZAFClient* client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[VZAFClient alloc]initWithBaseURL:nil];
    });
    return client;
}


@end


@interface VZAFRequest()

@property(nonatomic,strong) VZAFClient* afClient;
@property(nonatomic,strong) NSString* url;
@property(nonatomic,copy) NSDictionary* queries;

@property(nonatomic,strong) NSURLSessionTask* currentTask;

@end

@implementation VZAFRequest

@synthesize isPost = _isPost;
@synthesize delegate = _delegate;
@synthesize stringEncoding = _stringEncoding;
@synthesize timeoutSeconds = _timeoutSeconds;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;


- (void)initRequestWithBaseURL:(NSString*)url
{
    NSParameterAssert(url);
    
    if (url.length == 0) {
        [self requestDidFailWithError:[NSError errorWithDomain:VZErrorDomain code:kMethodNameError userInfo:@{NSLocalizedDescriptionKey : @"kMethodNameError"}]];
        return;
    }
    
    self.timeoutSeconds = 10.0f;
    self.stringEncoding = NSUTF8StringEncoding;
    self.url = url;

    self.afClient = [VZAFClient sharedClient];
    self.afClient.session.configuration.timeoutIntervalForRequest = self.timeoutSeconds;
    
}

- (void)addHeaderParams:(NSDictionary *)params
{
    self.afClient.session.configuration.HTTPAdditionalHeaders = params;
}

- (void)addQueries:(NSDictionary *)queries
{
    self.queries = queries;

}
- (void)addBodyData:(NSDictionary *)aData forKey:(NSString *)key
{
    
}
- (void)load
{
    [self requestDidStart];
    
    __weak typeof(self) weakSelf = self;
    self.currentTask = [self.afClient GET:self.url parameters:self.queries success:^(NSURLSessionDataTask *task, id responseObject) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            strongSelf -> _responseObject = responseObject;
        }
        
        [weakSelf requestDidFinish:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakSelf requestDidFailWithError:error];
        
    }];
    
}
- (void)cancel
{
    [self.currentTask cancel];
}


- (void)requestDidStart
{
    
    if ([self.delegate respondsToSelector:@selector(requestDidStart:)]) {
        [self.delegate requestDidStart:self];
    }

}

- (void)requestDidFinish:(id)JSON
{
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:JSON];
    }
}

- (void)requestDidFailWithError:(NSError* )error
{
    if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
        [self.delegate requestDidFailWithError:error];
    }

}



@end
