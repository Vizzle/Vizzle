//
//  VZHTTPNetworkResponseCacheInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/6/2.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VZHTTPRequestInterface;
@protocol VZHTTPResponseDataCacheInterface <NSObject>
/**
 *  根据identifier查看cache数据是否存在
 *
 *  @param identifier cache key
 *
 *  @return cache是否存在
 */
- (BOOL)hasCache:(NSString* )identifier;
/**
 *  根据request生成cache key
 *
 *  @param request 目标request
 *
 *  @return 生成的cacheKey
 */
- (NSString* )cachedKeyForVZHTTPRequest:(id<VZHTTPRequestInterface>) request;
/**
 *  根据key获取cache response
 *
 *  @param identifier cache key
 *  @param aCallback  回调block
 */
- (void)cachedResponseForUrlString:(NSString*)identifier completion:(void(^)(id object))aCallback;
/**
 *  根据cache key 存response
 *
 *  @param data         待缓存的response对象
 *  @param identifier   cache key
 *  @param timeInterval 过期时间
 */
- (void)saveResponse:(id)data WithUrlString:(NSString *)identifier ExpireTime:(NSTimeInterval)timeInterval;

@end
