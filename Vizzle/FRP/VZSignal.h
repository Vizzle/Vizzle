//
//  VZSignal.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-24.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZSignal;

typedef VZSignal* (^VZSignalBindBlock)(id value, BOOL *stop);

@protocol VZSignalSubscriber;
@class VZSignalDisposalProxy;
@class VZSignalScheduler;

@interface VZSignal : NSObject

//name of the current signal;
@property (nonatomic,strong,readonly) NSString *name;

// The block to invoke for each subscriber.
@property (nonatomic, copy, readonly) VZSignalDisposalProxy* (^didSubscribe)(id<VZSignalSubscriber> subscriber);

+ (VZSignal* )createSignal:(VZSignalDisposalProxy* (^)(id<VZSignalSubscriber> subscriber))handler;


@end

@interface VZSignal(Reactive)

- (VZSignalDisposalProxy *)subscribe:(id<VZSignalSubscriber>)subscriber;

- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock;

/// Convenience method to subscribe to the `next` and `completed` events.
- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock;

/// Convenience method to subscribe to the `next`, `completed`, and `error` events.
- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;

/// Convenience method to subscribe to `error` events.
- (VZSignalDisposalProxy *)subscribeError:(void (^)(NSError *error))errorBlock;

/// Convenience method to subscribe to `completed` events.
- (VZSignalDisposalProxy *)subscribeCompleted:(void (^)(void))completedBlock;

/// Convenience method to subscribe to `next` and `error` events.
- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock;

/// Convenience method to subscribe to `error` and `completed` events.
- (VZSignalDisposalProxy *)subscribeError:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;

@end

@interface VZSignal(Functional)

+ (VZSignal *)pass:(id)value;

+ (VZSignal *)empty;

+ (VZSignal* )error:(NSError* )err;

+ (VZSignal* )combine:(id<NSFastEnumeration>)list reduce:(id(^)())reduceBlock;

+ (VZSignal *)combineLatest:(id<NSFastEnumeration>)signals;

+ (VZSignal *)defer:(VZSignal * (^)(void))block;

- (VZSignal* )bind:(VZSignalBindBlock(^)(void))block;

- (VZSignal* )flattenMap:(VZSignal * (^)(id value))block;

- (VZSignal* )map:(id (^)(id value))block;

- (VZSignal* )filter:(BOOL (^)(id value))block;

- (VZSignal* )reduce:(id(^)())block;

- (VZSignal* )combineLatestWith:(VZSignal* )signal;

- (VZSignal* )concat:(VZSignal* )signal;

@end

@interface VZSignal(Thread)

- (void)deliverOnBackgroundThread;

- (void)deliverOnMainThread;

- (void)deliverOn:(VZSignalScheduler* )scheduler;

@end


@interface VZSignal(SideEffect)

- (VZSignal* )doNext:(void(^)(id value))block;

- (VZSignal* )doError:(void(^)(NSError* err))block;

- (VZSignal* )doComplete:(void(^)(void))block;

@end


@interface VZSignal(Subscription)

- (void)setKeypath:(NSString* )keypath onTarget:(id)target;

@end

@interface VZSignal(Name)

- (instancetype)setNameWithFormat:(NSString* )format,...;

@end


///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Signal Subclasses

@interface VZValueSignal : VZSignal

@property(nonatomic,strong,readonly) id value;

+ (VZSignal* )pass:(id)value;

@end

@interface VZErrorSignal : VZSignal

@property(nonatomic,strong,readonly) NSError* error;

+ (VZSignal* )error:(NSError* )err;

@end

@interface VZEmptySignal : VZSignal;

@end
