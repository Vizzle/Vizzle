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
- (void)request:(id<VZHTTPRequestInterface>)request DidFinish:(id)responseObject FromCache:(BOOL)fromCache;
- (void)request:(id<VZHTTPRequestInterface>)request DidFailWithError:(NSError *)error;

@end

@protocol VZHTTPRequestInterface <NSObject>

/**
 *  HTTP请求的URL
 */
@property (nonatomic,strong) NSString* requestURL;
/**
 *  HTTP请求的Query
 */
@property (nonatomic,strong) NSDictionary* queries;
/**
 *  HTTP头参数
 */
@property (nonatomic,strong) NSDictionary* headerParams;
/**
 *  HTTP请求参数，包括HTTPMethod,Cache等
 */
@property (nonatomic,assign) VZHTTPRequestConfig requestConfig;
/**
 *  HTTP请求结果参数，包括Response类型
 */
@property (nonatomic,assign) VZHTTPResponseConfig responseConfig;
/**
 *  描述本次请求的cacheKey
 */
@property (nonatomic,strong) NSString* cachedKey;
/**
 *  本次请求是否要忽略cache策略
 */
@property (nonatomic,assign) BOOL ignoreCachePolicy;
/**
 *  本次请求的delegate
 */
@property (nonatomic,weak) id<VZHTTPRequestDelegate> delegate;
/**
 *  本次请求返回的Response字符串
 */
@property (nonatomic,strong,readonly) NSString* responseString;
/**
 *  本次请求返回的Response对象
 */
@property (nonatomic,strong,readonly) id responseObject;
/**
 *  本次请求返回的错误
 */
@property (nonatomic,strong,readonly) NSError* responseError;
/**
 *  创建请求的request
 */
- (void)initWithBaseURL:(NSString*)url RequestConfig:(VZHTTPRequestConfig)config ResponseConfig:(VZHTTPResponseConfig)responseConfig;
/**
 *  增加HTTP GET请求参数
 */
- (void)addQueries:(NSDictionary* )queries;

/**
 *  增加HTTP Header参数
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
 *  设置HTTP的全局缓存对象
 */
- (id<VZHTTPResponseDataCacheInterface>)globalCache;


@end

