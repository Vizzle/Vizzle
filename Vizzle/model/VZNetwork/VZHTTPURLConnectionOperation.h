//
//  VZHTTPURLConnectionOperation.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZHTTPRunloopOperation.h"


typedef void(^VZHTTPURLHandleAuthenticationChallengeBlock) (NSURLConnection* ,NSURLAuthenticationChallenge*);
typedef void(^VZHTTPURLConnectionOperationProgressBlock)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);
typedef NSURLRequest * (^VZHTTPURLConnectionOperationRedirectResponseBlock)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse);
typedef NSCachedURLResponse * (^VZHTTPURLConnectionOperationCacheResponseBlock)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse);

@interface VZHTTPURLConnectionOperation : VZHTTPRunloopOperation<NSURLConnectionDelegate,NSURLConnectionDataDelegate>


/**
 *  current request
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;
/**
 *  current response
 */
@property (readonly, nonatomic, strong) NSURLResponse *response;
/**
 *  request's error
 */
@property (readonly,nonatomic, strong) NSError *error;
/**
 *  response data
 */
@property (readonly, nonatomic, strong) NSData *responseData;
/**
 *  response string
 */
@property (readonly, nonatomic, copy) NSString *responseString;
/**
 *  read data to be sent
 */
@property (nonatomic, strong) NSInputStream *inputStream;
/**
 *  write data received until the request is finished
 */
@property (nonatomic, strong) NSOutputStream *outputStream;
/**
 *  support authentication
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;
/**
 *  credential for auth
 */
@property (nonatomic, strong) NSURLCredential *credential;
/**
 *  callback blocks
 */
@property (readwrite, nonatomic,copy) VZHTTPURLConnectionOperationProgressBlock downloadProgressBlock;
@property (readwrite, nonatomic,copy) VZHTTPURLConnectionOperationProgressBlock uploadProgressBlock;
@property (readwrite, nonatomic,copy) VZHTTPURLHandleAuthenticationChallengeBlock authenticationChallengeBlock;
@property (readwrite, nonatomic,copy) VZHTTPURLConnectionOperationRedirectResponseBlock redirectResponseBlock;
@property (readwrite, nonatomic,copy) VZHTTPURLConnectionOperationCacheResponseBlock cacheResponseBlock;


- (id)initWithRequest:(NSURLRequest *)urlRequest;



@end
