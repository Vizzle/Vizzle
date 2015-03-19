//
//  NSObject+VZSignal.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VZSignal;
@class VZObserverProxy;
@interface NSObject (VZSignal)

@property(nonatomic,strong,readonly)VZObserverProxy* proxy;

- (VZSignal* )vz_observeKeypath:(NSString* )keypath;

- (VZSignal* )vz_observeChannel:(NSString* )channelName KeyPath:(NSString* )keypath;

@end

