//
//  VZHTTPRunloopOperation.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////////////////////////////////////
// state machine //

typedef NS_ENUM(NSInteger, VZHTTPOperationState)
{
    VZHTTPOperationPauseState       = -1,
    VZHTTPOperationReadyState       = 1,
    VZHTTPOperationExecutingState   = 2,
    VZHTTPOperationFinishedState    = 3,
};


@interface VZHTTPRunloopOperation : NSOperation

/**
 recursive lock
 */
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
/**
 default : NSRunLoopCommonModes
 */
@property (nonatomic, strong) NSSet *runLoopModes;
/**
 operation状态机
 */
@property(nonatomic,assign,readonly) VZHTTPOperationState operationState;
/**
 runloop thread
 */
@property(nonatomic,strong,readwrite) NSThread* runLoopThread;
/**
 actual runloop thread, in case the current run loop thread has been killed
 */
@property(nonatomic,strong,readonly) NSThread* actualRunLoopThread;
/**
 pause the current operation
 */
- (void)pause;

- (void)resume;

@end


@interface VZHTTPRunloopOperation(SubclassingOverride)

- (void)operationDidStart;
- (void)operationDidFinish;
- (void)operationDidCancel;


@end
