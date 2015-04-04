//
//  VZViewModel.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@class VZSignal;
@class VZViewController;
@interface VZViewModel : NSObject

//和template一对一的key
@property(nonatomic,copy)  NSString* identifier;

- (instancetype)initWithIdentifier:(NSString* )identifier;

- (NSString* )key:(NSString* )key;

//注册待观察的对象
- (void)beginObserving;

//dealloc时会调用
- (void)endObserving;

@end




