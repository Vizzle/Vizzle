//
//  NSNotificationCenter+VZSignal.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-3-13.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZSignal;
@interface NSNotificationCenter (VZSignal)


// Sends the NSNotification every time the notification is posted.
- (VZSignal *)vz_addObserverForName:(NSString *)notificationName object:(id)object;


@end
