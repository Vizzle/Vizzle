//
//  VZHTTPNetworkResponseCacheInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/6/2.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VZHTTPResponseCacheInterface <NSObject>

+ (NSString* )identifierForRequest:(NSURLRequest*) request;

@end
