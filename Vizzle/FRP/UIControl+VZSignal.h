//
//  UIControl+VZSignal.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-26.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VZSignal;
@interface UIControl (VZSignal)

- (VZSignal *)vz_signalForControlEvents:(UIControlEvents)controlEvents;

@end
