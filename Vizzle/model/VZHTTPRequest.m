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

@interface VZHTTPRequest()

@property(nonatomic,strong) VZHTTPNetworkAgent* networkAgent;
@property(nonatomic,strong) VZHTTPRequestGenerator* requestGenerator;
@property(nonatomic,strong) VZHTTPResponseParser* responseParser;
@property(nonatomic,strong) NSMutableURLRequest* request;
@property(nonatomic,strong) VZHTTPConnectionOperation* operation;

@end

@implementation VZHTTPRequest

@synthesize requestConfig          = _requestConfig;
@synthesize responseConfig         = _responseConfig;
@synthesize delegate        = _delegate;
@synthesize requestURL      = _requestURL;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;
@synthesize responseError  = _responseError;

- (void)initWithBaseURL:(NSString*)url RequestConfig:(VZHTTPRequestConfig)requestConfig ResponseConfig:(VZHTTPResponseConfig)responseConfig;
{
    NSParameterAssert(url);

    if (url.length == 0) {
        [self requestDidFailWithError:[NSError errorWithDomain:VZErrorDomain code:kMethodNameError userInfo:@{NSLocalizedDescriptionKey : @"kMethodNameError"}]];
        return;
    }
    
    _responseConfig   = responseConfig;
    _requestConfig    = requestConfig;
    _requestURL       = url;
    _requestGenerator = [VZHTTPRequestGenerator generator];
    _responseParser   = [VZHTTPResponseParser parserWithConfig:responseConfig];
    _request          = [[_requestGenerator generateRequestWithConfig:requestConfig URLString:url Params:nil] mutableCopy];
    _operation        = [[VZHTTPConnectionOperation alloc]initWithRequest:_request];
    _operation.responseParser = _responseParser;
  
}

- (void)addHeaderParams:(NSDictionary *)params
{
    if (!params) {
        return;
    }
    [self.requestGenerator addHeaderParams:params ToRequest:self.request];
}

- (void)addQueries:(NSDictionary *)queries
{
    if (!queries) {
        return;
    }
    [self.requestGenerator addQueryParams:queries EncodingType:self.requestConfig.stringEncoding ToRequest:self.request];
}


- (void)load
{
    [self requestDidStart];
    
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
