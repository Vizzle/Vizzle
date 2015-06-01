//
//  VZHTTPModel.h
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZModel.h"
#import "VZHTTPNetworkConfig.h"

/**
 *  model的http请求类型
 */
typedef NS_ENUM(NSInteger,VZModelRequestType)
{
    /**
     *  默认HTTP请求，使用VZHTTPRequest
     */
    VZModelDefault = 0,
    /**
     *  使用第三方request，需要实现<VZHTTPRequestInterface>
     */
    VZModelCustom
};


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
 *  解析JSON RESPONSE，并返回结果给Model来处理
 *  如果解析JSON错误，请设置error，并返回nil
 *
 *  @param JSON 请求返回的JSON结果
 *  @param error 如果解析JSON错误，请设置error
 *
 *  @return NSArray
 */
- (BOOL)parseResponse:(id)JSON;

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


@end


@interface VZHTTPModel : VZModel<VZHTTPModel>



/**
 *  model的请求类型
 *
 *  VZModel  => 1.1
 */
@property(nonatomic,assign) VZModelRequestType requestType;
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
 *  增加model的请求参数
 *
 *  VZModel => 1.4
 *
 */
- (void)setRequestParam:(id)value forKey:(id <NSCopying>)key;
/**
 *  去掉model的参数
 *
 *  VZModel => 1.4
 *
 */
- (void)removeRequestParamForKey:(id <NSCopying>)key;


@end

@interface VZHTTPModel(SubclassingHooks)

/**
 *  子类调用
 */
- (void)loadInternal;

@end
