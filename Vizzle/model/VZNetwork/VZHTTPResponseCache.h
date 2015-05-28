//
//  VZHTTPResponseCache.h
//  VZNetworkTest
//
//  Created by moxin on 15/5/28.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger kVZDefaultHTTPResponseMemoryCacheSize = 3*1024*1024;
static const NSUInteger kVZDefaultHTTPResponseFileCacheSize = 10*1024*1024;

@interface VZHTTPResponseCache : NSURLCache

+(void)install;

@end
