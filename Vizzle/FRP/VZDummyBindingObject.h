//
//  VZDummyBindingObject.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-5.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZSignal;
@interface VZDummyBindingObject : NSObject

@property(nonatomic,strong,readonly) id target;

- (id)initWithTarget:(id)target;

- (void)setObject:(VZSignal* )obj forKeyedSubscript:(NSString *)keyPath;

@end
