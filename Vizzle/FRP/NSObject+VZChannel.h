//
//  NSObject+VZChannel.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VZChannel)

- (void)vz_postToChannel:(NSString* )channelName withObject:(id)object Data:(id)data;
- (void)vz_listOnChannel:(NSString* )channelName withNotificationBlock:(void(^)(id obj,id data))block;
- (void)vz_removeFromChannel:(NSString* )channelName;
- (void)vz_removeFromChannel;

@end


