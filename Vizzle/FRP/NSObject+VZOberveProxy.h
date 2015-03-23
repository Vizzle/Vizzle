//
//  NSObject+VZOberveProxy.h
//  VZAsyncTemplate
//
//  Created by moxin on 15/3/21.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZObserverProxy;

@interface NSObject (VZOberveProxy)

@property (nonatomic, strong) VZObserverProxy *kvoProxy;

@end
