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

- (VZSignal* )send:(NSString *)channel
{
    
    __weak typeof(self)weakSelf = self;
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        VZSignalDisposalProxy* disposal = [self subscribeNext:^(id x) {
            
            [weakSelf vz_postToChannel:channel withObject:weakSelf Data:x];
            [subscriber sendNext:x];
            
        } error:^(NSError *error) {
            
            [subscriber sendError:error];
            
        } completed:^{
            
            [subscriber sendCompleted];
        }];
        
        return disposal;
    }];
    
    return sig;
}

@end
