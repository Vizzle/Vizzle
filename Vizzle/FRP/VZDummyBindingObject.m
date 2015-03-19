//
//  VZDummyBindingObject.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-5.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZDummyBindingObject.h"
#import "VZSignal.h"

@implementation VZDummyBindingObject
{
    __strong id _target;
}

- (id)initWithTarget:(id)target
{
    if (!target) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        
        _target = target;
        
    }
    return self;
}

- (void)setObject:(VZSignal* )sig forKeyedSubscript:(NSString *)keyPath
{
    [sig setKeypath:keyPath onTarget:_target];
    
}
@end
