//
//  VZHTTPRequest.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPRequest.h"
#import "VZHTTPNetwork.h"
#import "VZHTTPNetworkConfig.h"
#import "VZHTTPResponseDataCache.h"

@interface VZHTTPRequest()
{

}
@property(nonatomic,strong) VZHTTPNetworkAgent* networkAgent;
@property(nonatomic,strong) VZHTTPRequestGenerator* requestGenerator;
@property(nonatomic,strong) VZHTTPResponseParser* responseParser;
@property(nonatomic,strong) NSMutableURLRequest* request;
@property(nonatomic,strong) VZHTTPConnectionOperation* operation;

@end

@implementation VZHTTPRequest

@synthesize requestConfig          = _requestConfig;
@synthesize responseConfig         = _responseConfig;
@synthesize queries         = _queries;
@synthesize headerParams    = _headerParams;
@synthesize delegate        = _delegate;
@synthesize requestURL      = _requestURL;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;
@synthesize responseError  = _responseError;
@synthesize isCachedResponse = _isCachedResponse;

- (void)initWithBaseURL:(NSString*)url RequestConfig:(VZHTTPRequestConfig)requestConfig ResponseConfig:(VZHTTPResponseConfig)responseConfig;
{
    NSParameterAssert(url);

    _responseConfig   = responseConfig;
    _requestConfig    = requestConfig;
    _requestURL       = url;
    
    if(responseConfig.responseType == VZHTTPNetworkResponseTypeJSON)
        _responseParser = [VZHTTPJSONResponseParser new];
    else if (responseConfig.responseType == VZHTTPNetworkResponseTypeXML)
        _responseParser = [VZHTTPXMLResponseParser new];
    else
        _responseParser = [VZHTTPResponseParser new];
    
    _requestGenerator = [VZHTTPRequestGenerator new];
    _requestGenerator.stringEncoding = requestConfig.stringEncoding;
    _request = [[_requestGenerator generateRequestWithURLString:url
                                                        Params:nil
                                                    HTTPMethod:vz_httpMethod(requestConfig.requestMethod) TimeoutInterval:requestConfig.requestTimeoutSeconds] mutableCopy];
    _operation        = [[VZHTTPConnectionOperation alloc]initWithRequest:_request];
    _operation.responseParser = _responseParser;
  
}

- (void)addHeaderParams:(NSDictionary *)params
{
    if (!params) {
        return;
    }
    _headerParams = [params copy];
    [self.requestGenerator addHeaderParams:params ToRequest:self.request];
}

- (void)addQueries:(NSDictionary *)queries
{
    if (!queries) {
        return;
    }
    _queries = [queries copy];
    [self.requestGenerator addQueryParams:queries EncodingType:self.requestConfig.stringEncoding ToRequest:self.request];
}


- (void)load
{
    [self requestDidStart];
    [self checkCache];
}

- (void)loadHTTP
{
    _isCachedResponse = NO;
    __weak typeof(self) weakSelf = self;
    [_operation setCompletionHandler:^(VZHTTPConnectionOperation *op, NSString *responseString, id responseObj, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            strongSelf -> _responseString = [responseString copy];
            strongSelf -> _responseObject = responseObj;
            strongSelf -> _responseError = error;
            
        }
        
        if (!error) {
            [weakSelf requestDidFinish:responseObj];
            [weakSelf saveCache:responseObj];
        }
        else
            [weakSelf requestDidFailWithError:error];
    }];
    
    [[VZHTTPNetworkAgent sharedInstance].operationQueue addOperation:_operation];
}

- (void)cancel
{
    [self.operation cancel];
}

- (void)checkCache
{
    VZHTTPRequestConfig config = [self requestConfig];
    if (config.cachePolicy == VZHTTPNetworkURLCachePolicyOnlyReading ||
        config.cachePolicy == VZHTTPNetworkURLCachePolicyDefault)
    {
        
        id<VZHTTPResponseDataCacheInterface> cache = [self globalCache];
        
        NSString* key = [cache cachedKeyForVZHTTPRequest:self];
        
        if ([cache hasCache:key]) {
            
            [cache cachedResponseForUrlString:key completion:^(id object) {
                
                if (object) {
                    
                    _isCachedResponse = YES;
                    [self requestDidFinish:object];
                    
                    if (config.cachePolicy == VZHTTPNetworkURLCachePolicyDefault) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self loadHTTP];
                        });
                    
                    }
                }
                else
                {
                    [self loadHTTP];
                }
                
            }];
        }
        else
        {
            [self loadHTTP];
        }
        
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
        NSString* cachedKey = [cache cachedKeyForVZHTTPRequest:self];
        [cache saveResponse:object WithUrlString:cachedKey ExpireTime:t];
    
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
    _request = nil;
    _operation = nil;
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
    if ([self.delegate respondsToSelector:@selector(request:DidFailWithError:)]) {
        [self.delegate request:self DidFailWithError:error];
    }
}


@end
