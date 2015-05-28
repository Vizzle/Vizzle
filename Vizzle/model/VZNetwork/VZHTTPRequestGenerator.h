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

@property(nonatomic,assign) NSStringEncoding stringEncoding;
@property(nonatomic,copy) VZHTTPRequestStringGeneratorBlcok requestStringGenerator;

- (NSURLRequest *)generateRequestWithConfig:(VZHTTPRequestConfig) config
                                         URLString:(NSString *)aURLString
                                            Params:(NSDictionary *)aParams;


@end



