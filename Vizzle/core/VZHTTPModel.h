//
//  VZHTTPModel.h
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZModel.h"
#import "VZHTTPNetworkConfig.h"
#import "VZHTTPResponseDataCacheInterface.h"

// 子类需要重写的方法
@protocol VZHTTPModel <NSObject>

@required
/**
 *  querys
 *
 *  @return NSDictionary
 */
- (NSDictionary* )dataParams;
/**
 *  parameters for header
 *
 *  @return NSDictionary
 */
- (NSDictionary* )headerParams;
/**
 *  API NAME
 *
 *  @return NSString
 */
- (NSString *)methodName;
/**
 *  解析返回的response
 *
 *  @param response 可以是任意类型，可能是JSON，XML，或某个具体的对象
 *
 *  @return 解析成功或失败
 * 
 *  @notice:这个方法在子线程执行，使用主线程API要注意
 *
 */
- (BOOL)parseResponse:(id)response;

@optional

/**
 * 网络请求Config，特殊的请求覆盖这个方法，默认返回vz_httpConfigDefault()
 */
- (VZHTTPRequestConfig) requestConfig;

/**
 * 解析Response所用到的参数,特殊的请求覆盖这个方法，默认返回vz_httpConfigDefault()
 */
- (VZHTTPResponseConfig) responseConfig;
/**
 *  如果requestType指定为custom，则这个方法要返回第三方request的类名
 *
 *  v = VZModel : 1.1
 *
 *  @return 第三方request的类名
 */
- (NSString* )customRequestClassName;

/**
 *  返回model请求返回的Response对应的缓存Id
 *
 *  @return 默认为url+参数
 */
- (NSString* )cacheKey;

/**
 *  当model reload的时候会忽略Model的cache策略，它的优先级高于
 *  VZHTTPResponseConfig.cachePolicy
 *
 *  比如页面进行下拉刷新时，cache策略会失效
 *
 *  默认返回 YES
 */
- (BOOL)ignoreCachePolicyWhenModelReload;


@end


@interface VZHTTPModel : VZModel<VZHTTPModel>
/**
 *  返回的response 对象
 *
 *  VZModel=>1.2
 */
@property(nonatomic,strong,readonly) id responseObject;
/**
 *  返回的response string
 *
 *  VZModel=>1.2
 */
@property(nonatomic,strong,readonly) NSString* responseString;
/**
 *  返回的response object是否是从cache中获取的
 *
 *  default is no
 *
 */
@property(nonatomic,assign,readonly) BOOL isResponseObjectFromCache;



@end

@interface VZHTTPModel(SubclassingHooks)

/**
 *  子类调用
 */
- (void)loadInternal;

@end

