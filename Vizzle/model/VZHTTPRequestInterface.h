//
//  VZHTTPRequestInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/5/29.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZHTTPNetworkConfig.h"
#import "VZHTTPResponseDataCacheInterface.h"

@protocol VZHTTPRequestInterface;

@protocol VZHTTPRequestDelegate <NSObject>

@required

- (void)requestDidStart:(id<VZHTTPRequestInterface>)request;
- (void)request:(id<VZHTTPRequestInterface>)request DidFinish:(id)JSON;
- (void)request:(id<VZHTTPRequestInterface>)request DidFailWithError:(NSError *)error;

@end

@protocol VZHTTPRequestInterface <NSObject>

@property (nonatomic,strong) NSString* requestURL;
@property (nonatomic,strong) NSDictionary* queries;
@property (nonatomic,strong) NSDictionary* headerParams;
@property (nonatomic,assign) VZHTTPRequestConfig requestConfig;
@property (nonatomic,assign) VZHTTPResponseConfig responseConfig;
@property (nonatomic,weak) id<VZHTTPRequestDelegate> delegate;
@property (nonatomic,strong,readonly) NSString* responseString;
@property (nonatomic,strong,readonly) id responseObject;
@property (nonatomic,strong,readonly) NSError* responseError;
@property(nonatomic,assign,readonly) BOOL isCachedResponse;

/**
 *  创建请求的request
 *
 *  @param url
 */
- (void)initWithBaseURL:(NSString*)url RequestConfig:(VZHTTPRequestConfig)config ResponseConfig:(VZHTTPResponseConfig)responseConfig;
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


/**
 *  HTTP缓存
 */
- (id<VZHTTPResponseDataCacheInterface>)globalCache;


@end

