//
//  NSObject+VZOberveProxy.m
//  VZAsyncTemplate
//
//  Created by moxin on 15/3/21.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "NSObject+VZOberveProxy.h"
#import "VZObserverProxy.h"
#import <libkern/OSAtomic.h>
#import <objc/message.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

#pragma mark NSObject Category -

static void *VZObserveProxyKey     = &VZObserveProxyKey;
static void *VZObserveProxyWeakKey = &VZObserveProxyWeakKey;


@implementation NSObject (VZOberveProxy)

- (VZObserverProxy *)kvoProxy
{
    id proxy = objc_getAssociatedObject(self, VZObserveProxyKey);
    
    if (nil == proxy) {
    
        VZObserverProxy* proxy = [[VZObserverProxy alloc]initWithObserver:self];
        self.kvoProxy = proxy;
    }
    
    return proxy;
}

- (void)setKvoProxy:(VZObserverProxy *)kvoProxy
{
    objc_setAssociatedObject(self, VZObserveProxyKey, kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
