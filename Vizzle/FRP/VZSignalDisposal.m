//
//  VZSignalDisposal.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-3.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZSignalDisposal.h"
#import <libkern/OSAtomic.h>

@interface VZSignalDisposal()

@property(atomic,copy) void(^disposeBlock)(void);

@end

@implementation VZSignalDisposal
{
    OSSpinLock _lock;
}

+ (instancetype)disposableWithBlock:(void (^)(void))block
{
    return [[VZSignalDisposal alloc]initWithBlock:block];
    
}

- (instancetype) initWithBlock:(void(^)(void))block
{
    self = [super init];
    
    if (self) {
        
        _lock = OS_SPINLOCK_INIT;
        _disposeBlock = [block copy];
    }
    return self;
}

- (void)dealloc
{
    _disposeBlock = nil;
    //NSLog(@"[%@]:%@-->dealloc",self,self.name);
    
}

- (void)dispose
{
    if (_disposed) {
        return;
    }
    
    if (_disposeBlock) {
        _disposeBlock();
        _disposed = true;
    }
}

@end


