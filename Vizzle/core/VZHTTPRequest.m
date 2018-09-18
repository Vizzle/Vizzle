//
//  VZHTTPRequest.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPRequest.h"
#import "VZHTTPNetworkConfig.h"
#import "VZHTTPResponseDataCache.h"
#import <AFNetworking/AFNetworking.h>
#import "VZAssert.h"

@interface VZHTTPRequest()
@property(nonatomic,strong) AFHTTPSessionManager* sessionManager;
@end

@implementation VZHTTPRequest

@synthesize requestURL      = _requestURL;
@synthesize requestConfig   = _requestConfig;
@synthesize responseConfig  = _responseConfig;
@synthesize delegate        = _delegate;
@synthesize responseString  = _responseString;
@synthesize responseObject  = _responseObject;
@synthesize responseError   = _responseError;
@synthesize queries         = _queries;
@synthesize headerParams    = _headerParams;
@synthesize cachedKey       = _cachedKey;
@synthesize ignoreCachePolicy = _ignoreCachePolicy;

- (void)initWithBaseURL:(NSString*)url RequestConfig:(VZHTTPRequestConfig)requestConfig ResponseConfig:(VZHTTPResponseConfig)responseConfig;
{
    NSParameterAssert(url);
    _responseConfig   = responseConfig;
    _requestConfig    = requestConfig;
    _requestURL       = url;
    

    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = requestConfig.requestTimeoutSeconds;
}

- (void)addHeaderParams:(NSDictionary *)params
{
    if (!params) {
        return;
    }
    NSMutableDictionary* originalHeaders = [_headerParams mutableCopy];
    [originalHeaders addEntriesFromDictionary:params];
    _headerParams = [originalHeaders copy];
}

- (void)addQueries:(NSDictionary *)queries
{
    if (!queries) {
        return;
    }
    NSMutableDictionary* originalQueries = [_queries mutableCopy];
    [originalQueries addEntriesFromDictionary:queries];
    _queries = [originalQueries copy];
    
}

- (void)load
{
    [self requestDidStart];
    
    if (self.ignoreCachePolicy) {
        [self loadHTTP];
    }
    else
        [self checkCache];
}

- (void)loadHTTP
{
    __weak typeof(self) weakSelf = self;
    [self.sessionManager GET:_requestURL
                  parameters:_queries
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         __strong typeof(weakSelf) strongSelf = weakSelf;
                         if (strongSelf){
                             strongSelf -> _responseObject = responseObject;
                         }
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [weakSelf requestDidFinish:responseObject FromCache:NO];
                             [weakSelf saveCache:responseObject];
                         });
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [weakSelf requestDidFailWithError:error];
                         });
                     }];

}

- (void)cancel{
    for(NSURLSessionTask* task in self.sessionManager.tasks){
        [task cancel];
    }
}

- (void)checkCache
{
    VZHTTPRequestConfig config = [self requestConfig];
    if (config.cachePolicy == VZHTTPNetworkURLCachePolicyOnlyReading ||
        config.cachePolicy == VZHTTPNetworkURLCachePolicyDefault)
    {
        
        id<VZHTTPResponseDataCacheInterface> cache = [self globalCache];
        NSString* key = [[self class] cacheKey:self.cachedKey?:[cache cachedKeyForVZHTTPRequest:self]];
        if ([cache hasCache:key]) {
            [cache cachedResponseForKey:key completion:^(id object) {
                if (object) {
                    VZLog(@"✅ Fetch Cached Response Succeed!");
                    [self requestDidFinish:object FromCache:YES];
                }
                else{
                     VZLog(@"❗️Fetch Cached Response Failed!");
                    [self loadHTTP];
                }
            }];
        }else{
            [self loadHTTP];
        }
    }else{
        [self loadHTTP];
    }
    
}

- (void)saveCache:(id)object
{
    //save cache
    VZHTTPRequestConfig config = [self requestConfig];
    if (config.cachePolicy == VZHTTPNetworkURLCachePolicyOnlyWriting ||
        config.cachePolicy == VZHTTPNetworkURLCachePolicyDefault) {
    
        NSTimeInterval t = config.cacheTime;
        id<VZHTTPResponseDataCacheInterface> cache = [self globalCache];
        NSString* cachedKey = [[self class] cacheKey:self.cachedKey?:[cache cachedKeyForVZHTTPRequest:self]];
        [cache saveResponse:object ForKey:cachedKey ExpireTime:t Completion:^(BOOL b) {
            if (b) {
                VZLog(@"✅ Cache Response Succeed!");
            }else{
                VZLog(@"❗️Cache Response Failed!");
            }
            
        }];
    }
}

- (id<VZHTTPResponseDataCacheInterface>)globalCache
{
    return [VZHTTPResponseDataCache sharedInstance];
}


- (void)dealloc
{
    [self cancel];
    _delegate = nil;
    _sessionManager = nil;
}

- (void)requestDidStart
{
    if ([self.delegate respondsToSelector:@selector(requestDidStart:)]) {
        [self.delegate requestDidStart:self];
    }
}

- (void)requestDidFinish:(id)responseObject FromCache:(BOOL)fromCache
{
    if ([self.delegate respondsToSelector:@selector(request:DidFinish:FromCache:)]) {
        [self.delegate request:self DidFinish:responseObject FromCache:fromCache];
    }
}

- (void)requestDidFailWithError:(NSError* )error
{
    if ([self.delegate respondsToSelector:@selector(request:DidFailWithError:)]) {
        [self.delegate request:self DidFailWithError:error];
    }
}

#pragma mark - helper methods

+ (NSString *)appVersion
{
    static NSString *version = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    });
    return version;
}
+ (NSString* )cacheKey:(NSString* )key{
    return [NSString stringWithFormat:@"%@_%@",[self appVersion],key];
}


@end
