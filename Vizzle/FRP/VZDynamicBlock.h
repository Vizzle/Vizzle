//
//  VZDynamicBlock.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-3-7.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZTuple;

@interface VZDynamicBlock : NSObject

+ (id)invokeBlock:(id)block withArguments:(VZTuple* )args;

@end
