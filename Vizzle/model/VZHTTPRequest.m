//
//  VZHTTPRequest.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPRequest.h"
#import "VZHTTPNetwork.h"
#import "VZHTTPNetworkAssert.h"

@interface VZHTTPRequest()

@property(nonatomic,strong) VZHTTPNetworkAgent* networkAgent;

@end

@implementation VZHTTPRequest

@synthesize delegate        = _delegate;
@synthesize isPost          = _isPost;
@synthesize requestURL      = _requestURL;
@synthesize stringEncoding = _stringEncoding;
@synthesize timeoutSeconds = _timeoutSeconds;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;
@synthesize responseError  = _responseError;


- (void)initRequestWithBaseURL:(NSString*)url
{
    NSParameterAssert(url);

    if (url.length == 0) {
        [self requestDidFailWithError:[NSError errorWithDomain:VZErrorDomain code:kMethodNameError userInfo:@{NSLocalizedDescriptionKey : @"kMethodNameError"}]];
        return;
    }
    _requestURL = url;
    
    self.networkAgent = [VZHTTPNetworkAgent sharedInstance];
}

- (void)addHeaderParams:(NSDictionary *)params
{
   // self.configuration.HTTPAdditionalHeaders = [params copy];
}

- (void)addQueries:(NSDictionary *)queries
{
    
}
- (void)load
{
    VZHTTPRequestConfig reqConfig = vz_defaultHTTPRequestConfig();
    VZHTTPResponseConfig respConfig = vz_defaultHTTPResponseConfig();
    
    [[VZHTTPNetworkAgent sharedInstance] HTTP:self.requestURL requestConfig:reqConfig responseConfig:respConfig params:nil completionHandler:^(VZHTTPConnectionOperation *connection, NSString *responseString, id responseObj, NSError *error) {
        
    }];

}

- (void)cancel
{

}


- (void)dealloc
{
    [self cancel];
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
