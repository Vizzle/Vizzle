//
//  VZSignalDisposalProxy.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-3.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZSignalDisposalProxy.h"
#import "VZSignalDisposal.h"
#import <libkern/OSAtomic.h>

@interface VZSignalDisposalProxy()

@property(nonatomic,strong) NSMutableSet* disposalList;
@property(nonatomic,strong) NSMutableSet* disposalProxyList;

@end

@implementation VZSignalDisposalProxy
{
    OSSpinLock _lock;

}

+ (instancetype)proxy
{
    return [[self class] new];
}

+ (instancetype)proxyWithDisposal:(VZSignalDisposal* )disposal
{
    VZSignalDisposalProxy* proxy = [[self class] proxy];
    
    [proxy addDisposal:disposal];
    
    return proxy;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _lock = OS_SPINLOCK_INIT;
        self.disposalList = [NSMutableSet set];
        self.disposalProxyList = [NSMutableSet set];
    
    }
    
    return self;
}

- (void)dealloc
{
    //NSLog(@"[%@]:%@-->dealloc",self,self.name);
    
    [self.disposalList removeAllObjects];
    [self.disposalProxyList removeAllObjects];
}


- (NSArray* )allDisposals
{
    OSSpinLockLock(&_lock);
   
    NSArray* ret =  [self.disposalList allObjects];
    
    OSSpinLockUnlock(&_lock);
    
    return ret;
}

- (NSArray* )allDisposalProxys
{
    OSSpinLockLock(&_lock);
    
    NSArray* ret =  [self.disposalProxyList allObjects];
    
    OSSpinLockUnlock(&_lock);
    
    return ret;

}

- (void)addDisposal:(VZSignalDisposal *)disposal
{
    if(!disposal || disposal.isDisposed)
        return;
    
    if (_isDisposed) {
        
        [disposal dispose];
    }
    else
    {
    
        OSSpinLockLock(&_lock);
        
        [self.disposalList addObject:disposal];
        
        OSSpinLockUnlock(&_lock);
    }

}

- (void)addDisposals:(NSArray* )disposals
{
    if (!disposals) {
        return;
    }
    
    
    for (int i=0; i<disposals.count; i++) {
        
        VZSignalDisposal* disposal = disposals[i];
        
        [self addDisposal:disposal];
    }
    
}

- (void)removeDisposal:(VZSignalDisposal *)disposal
{
    if(!disposal || disposal.isDisposed)
        return;
    
    OSSpinLockLock(&_lock);
    
    [self.disposalList removeObject:disposal];
    
    OSSpinLockUnlock(&_lock);
    
}

- (void)removeDisposals:(NSArray *)disposals
{
    if (!disposals) {
        return;
    }

    for (VZSignalDisposal* disposal in disposals) {
        [self removeDisposal:disposal];
    }

}

- (void)addDisposalProxy:(VZSignalDisposalProxy* )proxy
{
    
    if (!proxy || [proxy isDisposed]) {
        return;
    }
    
    OSSpinLockLock(&_lock);
    
    [self.disposalProxyList addObject:proxy];
    
    OSSpinLockUnlock(&_lock);
    
}

- (void)removeDisposalProxy:(VZSignalDisposalProxy* )proxy
{
    if (!proxy) {
        return;
    }
    
    OSSpinLockLock(&_lock);
    
    [self.disposalProxyList removeObject:proxy];
    
    OSSpinLockUnlock(&_lock);
}

- (void)disposeAllDisposals
{
    OSSpinLockLock(&_lock);
    
    NSMutableSet* copyList = [self.disposalList copy];
    
    OSSpinLockUnlock(&_lock);
    
    [copyList enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        
        VZSignalDisposal* disposal = (VZSignalDisposal* )obj;
        
        [disposal dispose];
    }];
    
    _isDisposed = true;
    

}

- (void)disposeAllDisposalProxys
{
    OSSpinLockLock(&_lock);
    
    NSMutableSet* copyProxyList = [self.disposalProxyList copy];
    
    OSSpinLockUnlock(&_lock);
    
    [copyProxyList enumerateObjectsUsingBlock:^(VZSignalDisposalProxy* obj, BOOL *stop) {
        
        [obj disposeAllDisposals];

    }];
    
   
}


- (void)disposeAll
{
    
    [self disposeAllDisposals];
    
    [self disposeAllDisposalProxys];

}

@end
