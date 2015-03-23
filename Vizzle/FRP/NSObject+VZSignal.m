//
//  NSObject+VZSignal.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "NSObject+VZSignal.h"

@interface NSObject()


@end


@implementation NSObject (VZSignal)


- (VZSignal* )vz_observeKeypath:(NSString* )keypath
{

    NSRecursiveLock *objectLock = [[NSRecursiveLock alloc] init];
    objectLock.name = @"org.vizlab.vizzle.vzsignal";
    

    __weak typeof(self) weakSelf = self;
    
    VZSignal* signal = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        
    
        //watching for KVO-change:
        [weakSelf.proxy observe:weakSelf keyPath:keypath options:NSKeyValueObservingOptionNew block:^(id observer, NSDictionary *change) {
            
            if (change.count > 0) {
                
                if (change[@"newvalue"] != [NSNull null]) {
                   
                    [subscriber sendNext:change[@"newvalue"]];
                }
                else
                    [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }] ;
    
    return signal;

}


- (VZSignal* )vz_observeChannel:(NSString* )channelName KeyPath:(NSString* )keypath
{
    
    
    NSRecursiveLock *objectLock = [[NSRecursiveLock alloc] init];
    objectLock.name = @"org.vizlab.vizzle.vzchannel";
    
    
    __weak typeof(self) weakSelf = self;
    
    VZSignal* signal = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        NSString* newChannelName =  [NSString stringWithFormat:@"%@-%@",channelName,keypath];
        
        [weakSelf vz_listOnChannel:newChannelName withNotificationBlock:^(id obj, id data) {
           
     
            if (data) {
                
                [subscriber sendNext:data];
            }
            else
                [subscriber sendCompleted];

        }];
        
        return nil;
        
    }];
    
    return signal;

}


@end
