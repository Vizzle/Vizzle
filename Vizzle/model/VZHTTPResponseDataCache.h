//
//  VZHTTPURLResponseCache.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZHTTPResponseDataCacheInterface.h"



extern const  NSTimeInterval kVZHTTPNetworkURLCacheTimeOutValue;

@interface VZHTTPResponseDataCache : NSObject<VZHTTPResponseDataCacheInterface>

+ (instancetype) sharedInstance;

@end
