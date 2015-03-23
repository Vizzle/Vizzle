//
//  VZSignal+VZChannel.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-3-4.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZSignal+VZChannel.h"
#import "NSObject+VZChannel.h"
#import "VZSignalSubscriber.h"

@implementation VZSignal (VZChannel)

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Channel

- (void )send:(NSString *)channel
{
    if (!channel || channel.length == 0) {
        return;
    }
     __weak typeof(self)weakSelf = self;
    [self subscribeNext:^(id x) {
        
        [weakSelf vz_postToChannel:channel withObject:weakSelf Data:x];
        
    } error:^(NSError *error) {
        
        [weakSelf vz_postToChannel:channel withObject:weakSelf Data:error];
        
        
    } completed:^{
        
        //noop..
    }];
}

@end
