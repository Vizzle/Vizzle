//
//  VZKVOCenter.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-1.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZObserveInfo;
@interface VZKVOCenter : NSObject

+ (instancetype)sharedInstance;

- (void)observe:(id)object info:(VZObserveInfo *)info;
- (void)unobserve:(id)object info:(VZObserveInfo *)info;

@end
