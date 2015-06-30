//
//  VZHTTPNetworkResponseCacheInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/6/2.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "VZHTTPRequestInterface.h"

@protocol VZHTTPRequestInterface;
@protocol VZHTTPResponseDataCacheInterface <NSObject>

- (BOOL)hasCache:(NSString* )identifier;
- (NSString* )cachedKeyForVZHTTPRequest:(id<VZHTTPRequestInterface>) request;
- (void)cachedResponseForUrlString:(NSString*)identifier completion:(void(^)(NSError* err, id object))aCallback;
- (void)saveResponse:(id)data WithUrlString:(NSString *)identifier ExpireTime:(NSTimeInterval)timeInterval;

@end
