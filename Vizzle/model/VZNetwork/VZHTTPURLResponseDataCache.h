//
//  VZHTTPURLResponseCache.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VZHTTPURLResponseItem : NSObject<NSCoding>

@property(nonatomic,strong) NSDate*        triggerDate;
@property(nonatomic,assign) NSTimeInterval expireInterval;
@property(nonatomic,strong) NSString*      identifier;
@property(nonatomic,strong) id             response;
@property(nonatomic,strong) NSString*      responseStr;

@end

extern const  NSTimeInterval kVZHTTPNetworkURLCacheTimeOutValue;

@interface VZHTTPURLResponseDataCache : NSObject

+ (instancetype) sharedInstance;

- (void)cachedResponseForUrlString:(NSString*)identifier completion:(void(^)(NSError* err, id object))aCallback;

- (void)saveResponse:(id)data WithUrlString:(NSString*)identifier ExpireTime:(NSTimeInterval)timeInterval;


@end
