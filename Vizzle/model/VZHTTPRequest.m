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
@property(nonatomic,strong) NSMutableURLRequest* request;
@property(nonatomic,strong) NSMutableDictionary* bodyQueries;
@property(nonatomic,strong) NSMutableDictionary* headerQueries;
@property(nonatomic,strong) VZHTTPConnectionOperation* operation;

@end

@implementation VZHTTPRequest

@synthesize config          = _config;
@synthesize delegate        = _delegate;
@synthesize requestURL      = _requestURL;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;
@synthesize responseError  = _responseError;

- (void)initRequestWithBaseURL:(NSString*)url Config:(VZHTTPRequestConfig)config
{
    NSParameterAssert(url);

    if (url.length == 0) {
        [self requestDidFailWithError:[NSError errorWithDomain:VZErrorDomain code:kMethodNameError userInfo:@{NSLocalizedDescriptionKey : @"kMethodNameError"}]];
        return;
    }
    
    _config           = config;
    _requestURL       = url;
    _headerQueries    = [NSMutableDictionary new];
    _bodyQueries      = [NSMutableDictionary new];
    
    _requestGenerator = [VZHTTPRequestGenerator generator];
  
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
    [self.requestGenerator addQueryParams:queries EncodingType:self.config.stringEncoding ToRequest:self.request];
}


- (void)load
{
    
    NSURLRequest* request = [self.requestGenerator generateRequestWithConfig:self.config URLString:self.requestURL Params:nil];
    self.request = [request mutableCopy];

    _operation = [[VZHTTPConnectionOperation alloc]initWithRequest:_request];
    
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
