//
//  VZSignalSubscriber.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-31.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VZSignalDisposalProxy;
@protocol VZSignalSubscriber <NSObject>

- (void)sendNext:(id)value;

- (void)sendError:(NSError *)error;

- (void)sendCompleted;

- (void)addOtherSignalDisposalProxy:(VZSignalDisposalProxy* )proxy;


@end

@interface VZSignalSubscriber : NSObject<VZSignalSubscriber>

@property(nonatomic,strong,readonly) VZSignalDisposalProxy* disposalProxy;

+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed;

@end
