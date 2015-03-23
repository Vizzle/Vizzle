//
//  NSObject+VZSignal.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VZSignal;

@interface NSObject (VZSignal)

- (VZSignal* )vz_observeKeypath:(NSString* )keypath;

- (VZSignal* )vz_observeChannel:(NSString* )channelName;

@end

