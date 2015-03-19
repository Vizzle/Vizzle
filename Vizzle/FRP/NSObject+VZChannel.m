//
//  NSObject+VZChannel.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "NSObject+VZChannel.h"
#import "VZChannel.h"

@implementation NSObject (VZChannel)

- (void)vz_postToChannel:(NSString* )channelName withObject:(id)object Data:(NSDictionary* )dictionary
{
    [[VZChannel sharedInstance] vz_post:dictionary To:channelName From:self];
}
- (void)vz_listOnChannel:(NSString* )channelName withNotificationBlock:(void(^)(id obj,id data))block
{
    [[VZChannel sharedInstance] vz_listenOn:channelName Object:self Callback:block];
}

- (void)vz_removeFromChannel:(NSString *)channelName
{
   [[VZChannel sharedInstance] vz_removeListener:self From:channelName];

}

- (void)vz_removeFromChannel
{
    [[VZChannel sharedInstance] vz_removeListener:self];
}



@end
