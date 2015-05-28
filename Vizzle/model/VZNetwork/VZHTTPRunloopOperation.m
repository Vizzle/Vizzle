//
//  VZHTTPRunloopOperation.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "VZHTTPRunloopOperation.h"




static  NSString* const kVZHTTPOperationLockName      = @"com.VZHTTPOperation.lock.www";
NSString * const kVZHTTPNetworkErrorDomain            = @"VZHTTPNetworkingErrorDomain";
NSString * const kVZHTTPNetworkRequestFailedErrorKey  = @"VZHTTPNetworkRequestFailedErrorKey";
NSString * const kVZHTTPNetworkResponseFailedErrorKey = @"VZHTTPNetworkResponseFailedErrorKey";

//////////////////////////////////////////////////////////////////////////////////////////
// global static method
// the state machine is borrowed from afnetworking
// http://afnetworking.com/
//////////////////////////////////////////////////////////////////////////////////////////
static inline NSString * vz_keyForOperationState(VZHTTPOperationState state) {
    switch (state) {
        case VZHTTPOperationReadyState:
            return @"isReady";
        case VZHTTPOperationExecutingState:
            return @"isExecuting";
        case VZHTTPOperationFinishedState:
            return @"isFinished";
        case VZHTTPOperationPauseState:
            return @"isPaused";
        default:
            return @"state";
    }
}

static inline BOOL vz_isOperationStateTransationValid(VZHTTPOperationState fromState, VZHTTPOperationState toState, BOOL isCancelled) {
    
    NSString* f = vz_keyForOperationState(fromState);
    NSString* t = vz_keyForOperationState(toState);
    
    switch (fromState) {
           
        case VZHTTPOperationReadyState:
            switch (toState) {
                case VZHTTPOperationPauseState:
                case VZHTTPOperationExecutingState:
                {
                    NSLog(@"[VZHTTPRunloopOperation]-->[valid state trans: %@-->%@]",f,t);
                    return YES;
                }
                case VZHTTPOperationFinishedState:
                    return isCancelled;
                default:
                {
                    NSLog(@"[VZHTTPRunloopOperation]-->[Invalid state trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        case VZHTTPOperationExecutingState:
            switch (toState) {
                case VZHTTPOperationPauseState:
                case VZHTTPOperationFinishedState:
                {
                     NSLog(@"[VZHTTPRunloopOperation]-->[valid state trans: %@-->%@]",f,t);
                    return YES;
                }
                default:
                {
                    NSLog(@"[VZHTTPRunloopOperation]-->[Invalid state trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        case VZHTTPOperationFinishedState:
        {
             NSLog(@"[VZHTTPRunloopOperation]-->[Invalid state trans: %@-->%@]",f,t);
            return NO;
        }
        case VZHTTPOperationPauseState:
        {
            
            return toState == VZHTTPOperationReadyState;
        }
        default:
            return YES;
    }
}


@interface VZHTTPRunloopOperation()
{

}   

//@property (readwrite, nonatomic, assign, getter = isCancelled) BOOL cancelled;
@property (readwrite, nonatomic, assign) VZHTTPOperationState state;



@end



@implementation VZHTTPRunloopOperation


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setter

/**
 the state machine is inspired by afnetworking
 http://afnetworking.com/
 */
- (void)setState:(VZHTTPOperationState)state
{
    [self.lock lock];
    
    if (vz_isOperationStateTransationValid(self.state, state, [self isCancelled]))
    {
        NSString *oldStateKey = vz_keyForOperationState(self.state);
        NSString *newStateKey = vz_keyForOperationState(state);
        
        [self willChangeValueForKey:newStateKey];
        [self willChangeValueForKey:oldStateKey];
        _state = state;
        [self didChangeValueForKey:oldStateKey];
        [self didChangeValueForKey:newStateKey];
        
    }
    [self.lock unlock];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getter

- (NSThread*)actualRunLoopThread
{
    if(_runLoopThread)
        return _runLoopThread;
    else
        return [NSThread mainThread];
}

- (BOOL)isPaused
{
    return self.state == VZHTTPOperationPauseState;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - constructor


- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.state = VZHTTPOperationReadyState;
        self.lock = [[NSRecursiveLock alloc] init];
        self.lock.name = kVZHTTPOperationLockName;
        self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[VZHTTPRunloopOperation]-->dealloc");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSOperation


- (BOOL)isReady {
    return self.state == VZHTTPOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == VZHTTPOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == VZHTTPOperationFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}



- (void)start
{
    [self.lock lock];
    
    if ([self isReady]) {
        self.state = VZHTTPOperationReadyState;
        
        [self performSelector:@selector(operationWillStart) onThread:self.actualRunLoopThread withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    
    [self.lock unlock];
}

- (void)cancel
{
    [self.lock lock];
    
    if (![self isFinished] && ![self isCancelled]) {
       // [self willChangeValueForKey:@"isCancelled"];
       // _cancelled = YES;
        [super cancel];
       // [self didChangeValueForKey:@"isCancelled"];
        
        [self performSelector:@selector(operationWillBeCancelled) onThread:self.actualRunLoopThread withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    [self.lock unlock];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public method

- (void)pause {
   
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }
    
    [self.lock lock];
    
    if ([self isExecuting]) {

        [self cancel];
    }
    
    self.state = VZHTTPOperationPauseState;
    
    [self.lock unlock];
}

- (void)resume {
    if (![self isPaused]) {
        return;
    }
    
    [self.lock lock];
    self.state = VZHTTPOperationReadyState;
    
    [self start];
    [self.lock unlock];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method


- (void)operationWillStart
{
    [self.lock lock];
    
    if (![self isCancelled]) {
        
        [self operationDidStart];
        
    }
    
    [self.lock unlock];
    
    if ([self isCancelled]) {
    
        [self operationDidFinish];
    }

}

- (void)operationWillBeCancelled
{
    [self operationDidCancel];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclassing method

- (void)operationDidStart
{
    self.state = VZHTTPOperationExecutingState;
}

- (void)operationDidFinish
{
    self.state = VZHTTPOperationFinishedState;
}

- (void)operationDidCancel
{
    self.state = VZHTTPOperationReadyState;
}


@end
