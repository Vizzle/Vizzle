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

@property(nonatomic,copy)  NSString* identifier;

@property(nonatomic,weak)  VZViewController *viewController;

- (instancetype)initWithIdentifier:(NSString* )identifier;

- (NSString* )key:(NSString* )key;

- (void)beginObserving;

- (void)endObserving;

@end




