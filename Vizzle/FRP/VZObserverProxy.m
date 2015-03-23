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
    //NSMapTable* _observerMap;
    NSMutableDictionary* _observerMap;
    NSMutableDictionary* _objectMap;
    OSSpinLock _lock;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (id)initWithObserver:(id)observer
{
    self = [super init];
    
    if (self) {
        
        _observer = observer;
        
//        NSPointerFunctionsOptions keyOptions = NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality;
//        _observerMap = [[NSMapTable alloc] initWithKeyOptions:keyOptions valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];
        _observerMap = [[NSMutableDictionary alloc]initWithCapacity:1];
        _objectMap   = [[NSMutableDictionary alloc]initWithCapacity:1];
        
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
    
    
    //拿到object对应的key
    NSString* hashString = [self hashKey:object];

    //让proxy强引用object
    [_objectMap setObject:object forKey:hashString];
    
    NSMutableSet *infos = [_observerMap objectForKey:hashString];
    VZObserveInfo *existingInfo = [infos member:info];
    if (nil != existingInfo) {
        
        //set已经存在
        OSSpinLockUnlock(&_lock);
        return;
    }

    if (nil == infos) {
        infos = [NSMutableSet set];
        
        //引用callback等信息
        [_observerMap setObject:infos forKey:hashString];
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
    
    NSString* str = [self hashKey:object];
  
    NSMutableSet *infos = [_observerMap objectForKey:str];

    [_observerMap removeObjectForKey:str];
    
    // unlock
    OSSpinLockUnlock(&_lock);
    
    //center取消注册
    for (VZObserveInfo* info in infos) {
        
        [[VZKVOCenter sharedInstance] unobserve:object info:info];
        
    }
    
    //解开对object的引用
    [_objectMap removeObjectForKey:str];
}

- (void)unObserveAll
{
    // lock
    OSSpinLockLock(&_lock);
    
    NSMutableDictionary *objectInfoMaps = [_observerMap mutableCopy];
    NSMutableDictionary* objectMaps     = [_objectMap mutableCopy];
    
    // clear table and map
    [_observerMap removeAllObjects];
    [_objectMap removeAllObjects];
    
    // unlock
    OSSpinLockUnlock(&_lock);
    
    
    
    [objectMaps enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
        
        NSMutableSet* set = [objectInfoMaps objectForKey:key];
        
        for (VZObserveInfo* info in set) {
            
            [[VZKVOCenter sharedInstance] unobserve:obj info:info];
            
        }
        
    }];
    
    //clean object map
    [objectMaps removeAllObjects];


}

- (NSString* )hashKey:(id)object
{
    return [NSString stringWithFormat:@"<%@  - %ld>",[object class], [object hash]];
    
}


@end
