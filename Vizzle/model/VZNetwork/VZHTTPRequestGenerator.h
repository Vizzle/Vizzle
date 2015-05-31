//
//  VZHTTPRequestGenerator.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NSString* (^VZHTTPRequestStringGeneratorBlcok)(NSURLRequest* request,NSDictionary* params,NSError *__autoreleasing *error);
struct requestConfig;
typedef struct requestConfig VZHTTPRequestConfig;

@interface VZHTTPRequestGenerator : NSObject

+(instancetype) generator;

@property(nonatomic,copy) VZHTTPRequestStringGeneratorBlcok requestStringGenerator;

//生成requet
- (NSURLRequest *)generateRequestWithConfig:(VZHTTPRequestConfig) config
                                         URLString:(NSString *)aURLString
                                            Params:(NSDictionary *)aParams;

//add header params
- (void)addHeaderParams:(NSDictionary* )params ToRequest:(NSMutableURLRequest* )request;

//add body params
- (void)addQueryParams:(NSDictionary* )params EncodingType:(NSStringEncoding)encoding ToRequest:(NSMutableURLRequest* )request ;

//HTTPS的用户名，密码
- (void)addAuthHeaderWithUserName:(NSString*)aName Password:(NSString*)aPassword ToRequest:(NSMutableURLRequest* )request;

//HTTPS token
- (void)addAuthHeaderWithToken:(NSString* )token toRequest:(NSMutableURLRequest* )request;

@end



