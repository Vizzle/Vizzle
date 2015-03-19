//
//  VZSignalDisposal.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-3.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZSignalDisposal : NSObject

@property (atomic, assign, getter = isDisposed, readonly) BOOL disposed;
@property(nonatomic,strong)NSString* name;

+ (instancetype)disposableWithBlock:(void (^)(void))block;

- (void)dispose;


@end
