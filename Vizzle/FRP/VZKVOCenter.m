//
//  VZKVOCenter.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-1.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZKVOCenter.h"
#import <libkern/OSAtomic.h>
#import "VZObserveInfo.h"
#import "VZObserverProxy.h"

@implementation VZKVOCenter
{
    OSSpinLock _lock;
    NSMutableSet* _infos;
}

+ (instancetype)sharedInstance
{
    static VZKVOCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VZKVOCenter alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _lock = OS_SPINLOCK_INIT;
        _infos = [NSMutableSet new];
        
    }
    return self;
    
}

- (NSString* )description
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"<%@ ==> ", NSStringFromClass([self class])];

    NSMutableArray *infoDescriptions = [NSMutableArray arrayWithCapacity:_infos.count];
    
    // lock
    OSSpinLockLock(&_lock);
    for (VZObserveInfo *info in _infos) {
        [infoDescriptions addObject:info.description];
    }
    // unlock
    OSSpinLockUnlock(&_lock);
    
    [s appendFormat:@" contexts:%@", infoDescriptions];
    [s appendString:@">"];
    return s;
    
}


- (void)observe:(id)object info:(VZObserveInfo *)info
{
    if (nil == info) {
        return;
    }
    
    // register info
    OSSpinLockLock(&_lock);
    [_infos addObject:info];
    OSSpinLockUnlock(&_lock);
    
    // add observer
    [object addObserver:self forKeyPath:info.keyPath options:info.options context:(void *)info];
}

- (void)unobserve:(id)object info:(VZObserveInfo *)info
{
    if (nil == info) {
        return;
    }
    
    // unregister info
    OSSpinLockLock(&_lock);
    [_infos removeObject:info];
    OSSpinLockUnlock(&_lock);
    
    // remove observer
    [object removeObserver:self forKeyPath:info.keyPath context:(void *)info];
}
- (void)unobserve:(id)object infos:(NSSet *)infos
{
    if (0 == infos.count) {
        return;
    }
    
    // unregister info
    OSSpinLockLock(&_lock);
    for (VZObserveInfo *info in infos) {
        [_infos removeObject:info];
    }
    OSSpinLockUnlock(&_lock);
    
    // remove observer
    for (VZObserveInfo *info in infos) {
        [object removeObserver:self forKeyPath:info.keyPath context:(void *)info];
    }
}



//KVO observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSAssert(context, @"missing context keyPath:%@ object:%@ change:%@", keyPath, object, change);
    
    VZObserveInfo* info = nil;
    
    OSSpinLockLock(&_lock);
    
    info = [_infos member:(__bridge id)(context)];
    
    OSSpinLockUnlock(&_lock);
    
    
    if (info) {
        
        // take strong reference to controller
        VZObserverProxy *proxy = info.proxy;
        if (nil != proxy) {
            
            // take strong reference to observer
            id observer = proxy.observer;
            if (nil != observer) {
                
                // dispatch custom block or action, fall back to default action
                if (info.observeCallback) {
                    
                    NSMutableDictionary* ret = [NSMutableDictionary new];
                    
                    
                    NSNumber* kind  = change[NSKeyValueChangeKindKey];
                    
                    //数据发生变化
                    if (kind.integerValue == NSKeyValueChangeSetting) {
                        
                        ret[@"keypath"] = keyPath;
                        ret[@"oldvalue"] = change[NSKeyValueChangeOldKey]?:[NSNull null];
                        ret[@"newvalue"] = change[NSKeyValueChangeNewKey]?:[NSNull null];
                        info.observeCallback(observer, [ret copy]);
                        
                    }
                    
                }
            }
        }
    }
    
}

@end
