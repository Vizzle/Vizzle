//
//  VZHTTPModel.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPModel.h"
#import "VZHTTPRequest.h"
#import "VZHTTPNetworkConfig.h"

@interface VZHTTPModel()<VZHTTPRequestDelegate>

@property(nonatomic,assign) BOOL ignoreCache;
@property(nonatomic,strong) id<VZHTTPRequestInterface> request;

@end

@implementation VZHTTPModel

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle




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
    if (self.request)
    {
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
    
    if (self.requestType == VZModelCustom)
    {
        NSString* clzName = [self customRequestClassName];
        
        if (clzName.length > 0) {
            self.request = [[NSClassFromString(clzName) alloc]init];
        }
        else
        {
            self.request = [self createRequest];
        }
    }
    else
    {
        self.request = [self createRequest];
    }
    
    
    //1, prepareRequest
    [self prepareRequest];
    
    
    //2, set delegate
    self.request.delegate    = self;
    
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
    return @"VZHTTPRequest";
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


- (void)prepareRequest
{
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - request callback


- (void)requestDidStart:(id<VZHTTPRequestInterface>)request
{
    //NSLog(@"[%@]-->REQUEST_START:%@",self.class,request.requestURL);
    
    [self didStartLoading];
}


- (void)request:(id<VZHTTPRequestInterface>) request DidFinish:(id)responseObject FromCache:(BOOL)fromCache
{
    _responseString = request.responseString;
    _responseObject = request.responseObject;
    _isResponseObjectFromCache = fromCache;

    //NSLog(@"[%@]-->REQUEST_FINISH:%@",self.class,responseObject);

    
    dispatch_async([self sharedQueue], ^{
       
        if ([self parseResponse:responseObject]) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self didFinishLoading];
                
            });
        
        }
        else
        {
            NSError* err = [NSError errorWithDomain:VZHTTPErrorDomain code:kVZHTTPParseResponseError userInfo:@{NSLocalizedDescriptionKey:@"Parse Response Error"}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didFailWithError:err];

            });
        }
    });
}
- (void)request:(id<VZHTTPRequestInterface>) request DidFailWithError:(NSError *)error
{
    //NSLog(@"[%@]-->REQUEST_FAILED:%@",self.class,error);
    
    
    _responseString = request.responseString;
    _responseObject = request.responseObject;

    [self didFailWithError:error];
}


- (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t gResponseProcessinglQueue = NULL;
    if (gResponseProcessinglQueue == NULL) {
        
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            
            gResponseProcessinglQueue = dispatch_queue_create("com.vizlab.vizzle.httpmodel", DISPATCH_QUEUE_SERIAL);
            
        });
    }

    return gResponseProcessinglQueue;
}




@end
