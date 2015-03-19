//
//  VZObserver.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZObserverProxy.h"
#import <libkern/OSAtomic.h>
#import "VZObserveInfo.h"
#import "VZKVOCenter.h"

@implementation VZObserverProxy
{
    NSMapTable* _observerMap;
    OSSpinLock _lock;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (id)initWithObserver:(id)observer
{
    self = [super init];
    
    if (self) {
        
        _observer = observer;
        
        _observerMap = [NSMapTable new];
        
        _lock = OS_SPINLOCK_INIT;
        
    }
    
    return self;
}

- (void)dealloc
{
    [self unObserveAll];
}

- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(VZObserverCallback)block
{
    NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);
    if (nil == object || 0 == keyPath.length || NULL == block) {
        return;
    }

    VZObserveInfo* info = [[VZObserveInfo alloc]initWithProxy:self keyPath:keyPath options:options block:block action:NULL context:NULL];
    
    // lock
    OSSpinLockLock(&_lock);
    
    NSMutableSet *infos = [_observerMap objectForKey:object];
    
    // check for info existence
    VZObserveInfo *existingInfo = [infos member:info];
    if (nil != existingInfo) {
        NSLog(@"observation info already exists %@", existingInfo);
        
        // unlock and return
        OSSpinLockUnlock(&_lock);
        return;
    }
    
    // lazilly create set of infos
    if (nil == infos) {
        infos = [NSMutableSet set];
        [_observerMap setObject:infos forKey:object];
    }
    
    // add info and oberve
    [infos addObject:info];
    
    // unlock prior to callout
    OSSpinLockUnlock(&_lock);
    
    [[VZKVOCenter sharedInstance] observe:object info:info];

}

- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options block:(VZObserverCallback)block
{
    NSAssert(0 != keyPaths.count && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPaths, block);
    if (nil == object || 0 == keyPaths.count || NULL == block) {
        return;
    }
    
    for (NSString *keyPath in keyPaths)
    {
        [self observe:object keyPath:keyPath options:options block:block];
    }
}

- (void)unObserve:(id)object
{
    if (nil == object) {
        return;
    }
    
    // lock
    OSSpinLockLock(&_lock);
    
    NSMutableSet *infos = [_observerMap objectForKey:object];
    
    // remove infos
    [_observerMap removeObjectForKey:object];
    
    // unlock
    OSSpinLockUnlock(&_lock);
    
    // unobserve
    [[VZKVOCenter sharedInstance] unobserve:object infos:infos];
}

- (void)unObserveAll
{
    // lock
    OSSpinLockLock(&_lock);
    
    NSMutableDictionary *objectInfoMaps = [_observerMap copy];
    
    // clear table and map
    [_observerMap removeAllObjects];
    
    // unlock
    OSSpinLockUnlock(&_lock);
    
    for (id object in objectInfoMaps) {
        // unobserve each registered object and infos
        NSSet *infos = [objectInfoMaps objectForKey:object];
        [[VZKVOCenter sharedInstance] unobserve:object infos:infos];
    }
}


@end
