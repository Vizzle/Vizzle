//
//  VZAFRequest.m
//  VizzleListExample
//
//  Created by moxin.xt on 14-9-29.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZAFRequest.h"
#import "Vizzle.h"

#ifdef _AFNETWORKING_
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
        client = [[VZAFClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return client;
}


@end
#endif


@interface VZAFRequest()

#ifdef _AFNETWORKING_
@property(nonatomic,strong) VZAFClient* afClient;
#endif

@property(nonatomic,strong) NSString* url;
#ifdef _AFNETWORKING_
@property(nonatomic,strong) NSURLSessionTask* currentTask;
#endif

@end

@implementation VZAFRequest

@synthesize requestConfig  = _requestConfig;
@synthesize responseConfig = _responseConfig;
@synthesize delegate       = _delegate;
@synthesize requestURL     = _requestURL;
@synthesize queries        = _queries;
@synthesize cachedKey      = _cachedKey;
@synthesize ignoreCachePolicy = _ignoreCachePolicy;
@synthesize headerParams   = _headerParams;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;
@synthesize responseError  = _responseError;
@synthesize isCachedResponse = _isCachedResponse;

- (void)initWithBaseURL:(NSString *)url RequestConfig:(VZHTTPRequestConfig)requestConfig ResponseConfig:(VZHTTPResponseConfig)responseConfig
{
#ifdef _AFNETWORKING_
    
    NSParameterAssert(url);
    

    self.url = url;
    self.requestConfig = requestConfig;
    self.responseConfig = responseConfig;
    self.afClient = [VZAFClient sharedClient];
    self.afClient.session.configuration.timeoutIntervalForRequest = requestConfig.requestTimeoutSeconds;

#else
    
    NSAssert(true, @"No AFNetworking Class can be found");
    
#endif
    
}

- (void)dealloc
{
    [self cancel];
#ifdef _AFNETWORKING_
    self.currentTask = nil;
#endif
}

- (void)addHeaderParams:(NSDictionary *)params
{
#ifdef _AFNETWORKING_
    self.afClient.session.configuration.HTTPAdditionalHeaders = params;
#endif
}

- (void)addQueries:(NSDictionary *)queries
{
#ifdef _AFNETWORKING_
    self.queries = [queries copy];
#endif

}
- (void)load
{
    
#ifdef _AFNETWORKING_
    NSString* type = vz_httpMethod(self.requestConfig.requestMethod);
    
    NSMutableURLRequest *request = [self.afClient.requestSerializer requestWithMethod:type URLString:self.url parameters:self.queries error:nil];
    self.requestURL = request.URL.absoluteString;

    [self requestDidStart];
    
    
    __weak typeof(self) weakSelf = self;
    if ([type isEqualToString:@"POST"])
    {
        self.currentTask = [self.afClient POST:self.url parameters:self.queries success:^(NSURLSessionDataTask *task, id responseObject) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (strongSelf) {
                //AF没有获取responseString的方法
                strongSelf -> _responseString = [NSString stringWithFormat:@"%@",responseObject];
                strongSelf -> _responseObject = responseObject;
            }
            
            [weakSelf requestDidFinish:responseObject];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (strongSelf) {
                strongSelf -> _responseString = [NSString stringWithFormat:@"%@",task.response];
                strongSelf -> _responseError = error;
            }
            [weakSelf requestDidFailWithError:error];
            
        }];
    }
    else
    {
        self.currentTask = [self.afClient GET:self.url parameters:self.queries success:^(NSURLSessionDataTask *task, id responseObject) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (strongSelf) {
                //AF没有获取responseString的方法
                strongSelf -> _responseString = [NSString stringWithFormat:@"%@",responseObject];
                strongSelf -> _responseObject = responseObject;
            }
            
            [weakSelf requestDidFinish:responseObject];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (strongSelf) {
                //AF没有获取responseString的方法
                strongSelf -> _responseString = [NSString stringWithFormat:@"%@",task.response];
                strongSelf -> _responseError = error;
            }
            [weakSelf requestDidFailWithError:error];
            
        }];
    }
    

    
    
#endif
    
}
- (void)cancel
{
#ifdef _AFNETWORKING_
    [self.currentTask cancel];
#endif
}

- (id<VZHTTPResponseDataCacheInterface>)globalCache
{
    return nil;
}

- (void)requestDidStart
{
    
    if ([self.delegate respondsToSelector:@selector(requestDidStart:)]) {
        [self.delegate requestDidStart:self];
    }

}

- (void)requestDidFinish:(id)JSON
{
    if ([self.delegate respondsToSelector:@selector(request:DidFinish:)]) {
        [self.delegate request:self DidFinish:JSON];
    }
}

- (void)requestDidFailWithError:(NSError* )error
{
    if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
        [self.delegate request:self DidFailWithError:error];
    }

}



@end
