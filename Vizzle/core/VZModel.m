// VZModel.m 
// iCoupon 
//created by Tao Xu on 2014-09-15 15:35:19 +0800. 
// Copyright (c) @VizLab. All rights reserved.
// 

#import "VZModel.h"
#import "VZAssert.h"
#import <libkern/OSAtomic.h>

static inline NSString * vz_descForModelState(VZModelState state) {
    switch (state) {
        case VZModelStateReady:
            return @"isReady";
        case VZModelStateLoading:
            return @"isLoading";
        case VZModelStateFinished:
            return @"isFinished";
        case VZModelStateError:
            return @"isError";
        default:
            return @"unKnown state";
    }
}

static inline BOOL vz_isModelStateTransationValid(VZModelState fromState, VZModelState toState, BOOL isCancelled)
{
    
    NSString* f = vz_descForModelState(fromState);
    NSString* t = vz_descForModelState(toState);
    
    switch (fromState) {
            
        case VZModelStateReady:
            switch (toState) {
                case VZModelStateReady:
                case VZModelStateLoading:
                {
                    VZCLog(@"\xE2\x9C\x85  [%@-->%@]",f,t);
                    return YES;
                }
                default:
                {
                     VZCLog(@"\xE2\x9D\x8C  [%@-->%@]",f,t);
                    return NO;
                }
            }
        case VZModelStateLoading:
            switch (toState) {
                case VZModelStateFinished:
                case VZModelStateError:
                {
                    VZCLog(@"\xE2\x9C\x85  [%@-->%@]",f,t);
                    return YES;
                }
                case VZModelStateReady:
                {
                    if (isCancelled) {
                        VZCLog(@"\xE2\x9C\x85 [%@-->%@]",f,t);
                        return YES;
                    }
                    else
                    {
                        VZCLog(@"\xE2\x9D\x8C  [%@-->%@]",f,t);
                        return NO;
                    }

                }
                default:
                {
                    VZCLog(@"\xE2\x9D\x8C[ VZModelState]-->[trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        case VZModelStateFinished:
        {
            switch (toState) {
                case VZModelStateLoading:
                {
                    VZCLog(@"\xE2\x9C\x85  [%@-->%@]",f,t);
                    return YES;
                }
                case VZModelStateReady:
                {
                    if (isCancelled) {
                        VZCLog(@"\xE2\x9C\x85 [%@-->%@]",f,t);
                        return YES;
                    }
                    else
                    {
                        VZCLog(@"\xE2\x9D\x8C  [%@-->%@]",f,t);
                        return NO;
                    }
                
                }
                default:
                {
                    VZCLog(@"\xE2\x9D\x8C  [trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        }
        case VZModelStateError:
        {
            switch (toState) {
                case VZModelStateLoading:
                {
                    VZCLog(@"\xE2\x9C\x85  [%@-->%@]",f,t);
                    return YES;
                }
                case VZModelStateReady:
                {
                    if (isCancelled) {
                        VZCLog(@"\xE2\x9C\x85 [%@-->%@]",f,t);
                        return YES;
                    }
                    else
                    {
                        VZCLog(@"\xE2\x9D\x8C  [%@-->%@]",f,t);
                        return NO;
                    }
                }
                default:
                {
                    VZCLog(@"\xE2\x9D\x8C  [trans: %@-->%@]",f,t);
                    return NO;
                }
            }
        }
        default:
            return NO;
    }
}

@interface VZModel()

@property(nonatomic,copy) VZModelCallback requestCallback;
@property(nonatomic,assign,readwrite) VZModelState state;
@property(nonatomic,assign) BOOL isCancelled;

@end

@implementation VZModel
{
    OSSpinLock _lock;
}

////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setState:(VZModelState)state
{
    OSSpinLockLock(& _lock);
    if (vz_isModelStateTransationValid(self.state, state, self.isCancelled))
    {
        NSString *oldStateKey = vz_descForModelState(self.state);
        NSString *newStateKey = vz_descForModelState(state);
        
        [self willChangeValueForKey:newStateKey];
        [self willChangeValueForKey:oldStateKey];
        _state = state;
        [self didChangeValueForKey:oldStateKey];
        [self didChangeValueForKey:newStateKey];
    }
    OSSpinLockUnlock(& _lock);
}

////////////////////////////////////////////////////////////////
#pragma mark - getters

- (BOOL)isReady {
    return self.state == VZModelStateReady;
}

- (BOOL)isLoading {
    return self.state == VZModelStateLoading;
}

- (BOOL)isFinished {
    return self.state == VZModelStateFinished;
}

- (BOOL)isError{
    return self.state == VZModelStateError;
}

////////////////////////////////////////////////////////////////
#pragma mark - life cycle API

- (void)dealloc {
    
    if ([self isLoading]) {
        [self cancel];
    }

    
}


////////////////////////////////////////////////////////////////
#pragma mark - public API

- (void)load
{
    if ([self isLoading]) {
        [self cancel];
    }
    if ([self shouldLoad]) {
        [self reset];
    }
    else
    {
        //noop.
    }
}

- (void)reload
{
    [self load];
}

- (void)cancel
{
    _isCancelled = true;
    self.state = VZModelStateReady;
}

- (void)reset
{
    _error = nil;
    _isCancelled = false;
}


- (void)loadWithCompletion:(VZModelCallback)aCallback
{
    if (aCallback) {
        self.requestCallback = aCallback;
    }
    [self load];

}

- (void)reloadWithCompletion:(VZModelCallback)aCallback
{
    if (aCallback) {
        self.requestCallback = aCallback;
    }
    [self reload];
}

@end



@implementation VZModel(CallBack)

- (void)didStartLoading
{
    self.state = VZModelStateLoading;
    
    if ([self.delegate respondsToSelector:@selector(modelDidStart:)]) {
        [self.delegate modelDidStart:self];
    }

}
- (void)didFinishLoading
{
    self.state = VZModelStateFinished;
    
    //优先block方式回调
    if (self.requestCallback) {
        self.requestCallback(self,nil);
        self.requestCallback = nil;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(modelDidFinish:)]) {
            [self.delegate modelDidFinish:self];
        }
    }
}
- (void)didFailWithError:(NSError* )error
{
    self.state = VZModelStateError;
    _error = error;

    //优先block方式回调
    if (self.requestCallback) {
        self.requestCallback(self,error);
        self.requestCallback = nil;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(modelDidFail:withError:)]) {
            [self.delegate modelDidFail:self withError:error];
        }
    }
}


@end

@implementation VZModel(SubclassingHooks)

- (BOOL)shouldLoad
{
    return YES;
}


@end
