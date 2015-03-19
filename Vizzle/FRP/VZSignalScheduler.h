//
//  VZSignalScheduler.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-3.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZSignalHandler;

@interface VZSignalScheduler : NSObject


/// Returns a disposable which can be used to cancel the scheduled block before
/// it begins executing, or nil if cancellation is not supported.
- (VZSignalHandler *)schedule:(void (^)(void))block;


@end

