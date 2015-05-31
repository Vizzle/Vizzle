//
//  VZHTTPRequestInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/5/29.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZHTTPNetworkConfig.h"


@protocol VZHTTPRequestInterface;

@protocol VZHTTPRequestDelegate <NSObject>

@required

- (void)requestDidStart:(id<VZHTTPRequestInterface>)request;
- (void)requestDidFinish:(id)JSON;
- (void)requestDidFailWithError:(NSError *)error;

@end

@protocol VZHTTPRequestInterface <NSObject>

@property (nonatomic,strong) NSString* requestURL;
@property (nonatomic,assign) VZHTTPRequestConfig config;
@property (nonatomic,weak) id<VZHTTPRequestDelegate> delegate;

/**
 *
 *  增加返回的response string/obj
 *
 *  v = VZMV* : 1.2
 */
@property (nonatomic,strong,readonly) NSString* responseString;
@property (nonatomic,strong,readonly) id responseObject;
@property (nonatomic,strong,readonly) NSError* responseError;

/**
 *  创建请求的request
 *
 *  @param url
 */
- (void)initRequestWithBaseURL:(NSString*)url Config:(VZHTTPRequestConfig)config;
/**
 *  增加HTTP GET请求参数
 *
 *  @param query 参数
 *  @param key     不同参数类型对应的key
 */
- (void)addQueries:(NSDictionary* )queries;

/**
 *  增加HTTP Header参数
 *
 *  @param param 参数
 *  @param key     不同参数类型对应的key
 */
- (void)addHeaderParams:(NSDictionary* )params;

/**
 *  发起请求
 */
- (void)load;
/**
 *  取消请求
 */
- (void)cancel;

@end

