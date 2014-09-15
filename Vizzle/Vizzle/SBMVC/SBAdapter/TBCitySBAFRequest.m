//
//  TBCitySBAFRequest.m
//  sbkit
//
//  Created by moxin.xt on 14-5-8.
//  Copyright (c) 2014年 taobao.com. All rights reserved.
//


#import "TBCitySBAFRequest.h"
#import "AFNetworking.h"

@interface TBCitySBAFRequest()
{
    NSString* _url;
    NSMutableDictionary* _dict;
    
    AFHTTPClient* _afClicent;
}

@end

@implementation TBCitySBAFRequest

@synthesize useCache = _useCache;
@synthesize useAuth = _useAuth;
@synthesize usePost = _usePost;
@synthesize showLogin = _showLogin;
@synthesize apiCacheTimeOutSeconds = _apiCacheTimeOutSeconds;
@synthesize delegate = _delegate;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;

- (void)dealloc {
    [self cancel];
}


- (void)addParams:(NSDictionary* )aParams forKey:(NSString*)key
{
    [_dict addEntriesFromDictionary:aParams];
    
}

- (void)addBodyData:(NSDictionary *)aData forKey:(NSString *)key
{
}
- (void)initRequestWithBaseURL:(NSString *)url
{
    _url = url;
    _dict = [NSMutableDictionary new];
    
    _afClicent = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    [_afClicent registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [_afClicent setDefaultHeader:@"Accept" value:@"applicaion/json"];
    
}
- (void)load
{
    
    if ([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
        [self.delegate requestDidStartLoad:self];
    }
    
    NSMutableURLRequest* request = [_afClicent requestWithMethod:@"GET" path:_url parameters:_dict];
    request.timeoutInterval = 5.0f;
    AFHTTPRequestOperation* op = [_afClicent HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseJSON = nil;
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            NSError* error = nil;
            responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
            
            if (error) {
                
                [self sendFailureCallback:error];
            }
            else
            {
                [self sendSucceedCallback:responseJSON];
            }
        }
        else
        {
            //todo//
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self sendFailureCallback:error];
        
    }];
    [_afClicent enqueueHTTPRequestOperation:op];
}
- (void)cancel
{

    [_afClicent cancelAllHTTPOperationsWithMethod:@"GET" path:_url];
    self.delegate = nil;
}

- (void)sendSucceedCallback:(NSDictionary* )dict
{
    NSLog(@"AFRequestSUcceed:%@",dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [self.delegate requestDidFinish:dict];
        }
        
    });
}

- (void)sendFailureCallback:(NSError* )error
{
    NSLog(@"AFRequestError:%@",error);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
            [self.delegate requestDidFailWithError:error];
        }
    });
}

@end
