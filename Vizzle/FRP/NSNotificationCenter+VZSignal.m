//
//  NSNotificationCenter+VZSignal.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-3-13.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "NSNotificationCenter+VZSignal.h"
#import "VZSignal.h"
#import "VZSignalSubscriber.h"
#import "VZSignalDisposalProxy.h"
#import "VZSignalDisposal.h"

@implementation NSNotificationCenter (VZSignal)


- (VZSignal *)vz_addObserverForName:(NSString *)notificationName object:(id)object
{
    __weak typeof(object) weakObj = object;
    VZSignal* sig = [VZSignal createSignal:^(id<VZSignalSubscriber> subscriber) {
        
        __strong typeof(weakObj) strongObj = weakObj;
        
        id observer = [self addObserverForName:notificationName object:strongObj queue:nil usingBlock:^(NSNotification *note) {
            [subscriber sendNext:note];
        }];
        
        VZSignalDisposalProxy* proxy = [VZSignalDisposalProxy proxyWithDisposal:[VZSignalDisposal disposableWithBlock:^{
            
            	[self removeObserver:observer];
        }]];
        
        return proxy;
        
    }];
    return sig;
}



@end
