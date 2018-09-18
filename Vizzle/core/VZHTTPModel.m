//
//  VZHTTPModel.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPModel.h"
#import "VZHTTPRequest.h"
#import "VZHTTPNetworkConfig.h"
#import <libkern/OSAtomic.h>

@interface VZHTTPModel()<VZHTTPRequestDelegate>

@property(nonatomic,assign) BOOL ignoreCache;
@property(nonatomic,strong) id<VZHTTPRequestInterface> request;

@end

@implementation VZHTTPModel
{
    int32_t _sentinel;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods


- (void)load
{
    [super load];
    [self loadInternal];
}

- (void)reload
{
    if ([self ignoreCachePolicyWhenModelReload]) {
        self.ignoreCache = true;
    }
    else
        self.ignoreCache=  false;

    [super load];
    [self loadInternal];
}

- (void)cancel
{
    if (self.request){
        [self.request cancel];
        self.request = nil;
    }
    [super cancel];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods



////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private methods

- (void)loadInternal {
    
    //1, prepareRequest
     self.request = [self createRequest];
    
    
    //2, set delegate
    self.request.delegate = self;
    
    //3, init request
    [self.request initWithBaseURL:[self methodName]
                    RequestConfig:[self requestConfig]
                   ResponseConfig:[self responseConfig]];
    
    
    //4, add request data
    [self.request addHeaderParams:[self headerParams]];
    [self.request addQueries:[self dataParams]];
    
    //5, cache
    self.request.cachedKey = [self cacheKey];
    self.request.ignoreCachePolicy = [self ignoreCache];
    
    //6, load data
    OSAtomicIncrement32(&_sentinel);
    [self.request load];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclassing methods

- (NSDictionary *)dataParams {
    return nil;
}

- (NSDictionary* )headerParams{
    return nil;
}

- (NSString *)methodName {
    return nil;
}

- (BOOL)parseResponse:(id)responseObject{
    
    return YES;
}

- (VZHTTPRequestConfig)requestConfig
{
    return vz_defaultHTTPRequestConfig();
}

- (VZHTTPResponseConfig)responseConfig
{
    return vz_defaultHTTPResponseConfig();
}

- (NSString* )customRequestClassName
{
    return @"VZAFRequest";
}

- (NSString* )cacheKey
{
    NSString* method = [self methodName];
    NSMutableArray* list = [NSMutableArray new];
    [self.dataParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        NSString* str = [NSString stringWithFormat:@"%@:%@",key,obj];
        [list addObject:str];
    }];
    
    NSString* cachedKey  = method;
    for (NSString* key in list) {
        [cachedKey stringByAppendingString:key];
    }
    return cachedKey;
}

- (BOOL)ignoreCachePolicyWhenModelReload
{
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclassing hooks

- (id<VZHTTPRequestInterface>)createRequest
{
    return [VZHTTPRequest new];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - request callback


- (void)requestDidStart:(id<VZHTTPRequestInterface>)request{
    [self didStartLoading];
}


- (void)request:(id<VZHTTPRequestInterface>) request DidFinish:(id)responseObject FromCache:(BOOL)fromCache
{
    _responseString = request.responseString;
    _responseObject = request.responseObject;
    _isResponseObjectFromCache = fromCache;

    
    //setup a closure here
    __block int32_t old_sentinel = _sentinel;
    dispatch_async([self sharedQueue], ^{
        BOOL ret = [self parseResponse:responseObject];
        //check closure object
        if(old_sentinel != self->_sentinel){
            return;
        }
        
        if (ret) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didFinishLoading];
            });
        }
        else{
            NSError* err = [NSError errorWithDomain:VZHTTPErrorDomain code:kVZHTTPParseResponseError userInfo:@{NSLocalizedDescriptionKey:@"Parse Response Error"}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didFailWithError:err];

            });
        }
    });
}
- (void)request:(id<VZHTTPRequestInterface>) request DidFailWithError:(NSError *)error
{
    _responseString = request.responseString;
    _responseObject = request.responseObject;

    [self didFailWithError:error];
}


static dispatch_queue_t gResponseProcessinglQueue = NULL;
- (dispatch_queue_t)sharedQueue{
    if (gResponseProcessinglQueue == NULL) {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            gResponseProcessinglQueue = dispatch_queue_create("com.vizzle.httpmodel", DISPATCH_QUEUE_SERIAL);
        });
    }
    return gResponseProcessinglQueue;
}




@end
