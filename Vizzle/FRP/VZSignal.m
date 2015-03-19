//
//  VZSignal.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-24.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>
#import "VZSignal.h"
#import "VZSignalSubscriber.h"
#import "VZSignalDisposal.h"
#import "VZSignalDisposalProxy.h"
#import "VZDynamicBlock.h"
#import "VZTuple.h"

@implementation VZSignal
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

+ (VZSignal* )createSignal:(VZSignalDisposalProxy* (^)(id<VZSignalSubscriber> subscriber))handler
{
    VZSignal* sig=  [VZSignal new];
    sig -> _didSubscribe = [handler copy];
    sig -> _name = @"-create";
    return sig;
}

- (void)dealloc
{
    //NSLog(@"[%@]:%@ -> will dealloc",self,self.name);

    if (_didSubscribe) {
        _didSubscribe = nil;
    }
    
    //NSLog(@"[%@]:%@ -> did dealloc",self,self.name);
    
}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Reactive

- (VZSignalDisposalProxy* )subscribe:(id<VZSignalSubscriber>)subscriber
{
    
    NSParameterAssert(subscriber != nil);
    
    VZSignalDisposalProxy* allDisposalProxy = [VZSignalDisposalProxy proxy];
    [subscriber addOtherSignalDisposalProxy:allDisposalProxy];
    
    if (self.didSubscribe) {
        
        //should be a schedualer here
        VZSignalDisposalProxy* innerDisposalProxy = self.didSubscribe(subscriber);
        [allDisposalProxy addDisposals:[innerDisposalProxy allDisposals]];
    }
    
    return allDisposalProxy;

}

- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock
{
    NSParameterAssert(nextBlock != nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nextBlock error:nil completed:nil];
    return  [self subscribe:o];
    
}

/// Convenience method to subscribe to the `next` and `completed` events.
- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock
{
    NSParameterAssert(nextBlock != nil && completedBlock != nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nextBlock error:nil completed:completedBlock];
    return [self subscribe:o];
    
}

/// Convenience method to subscribe to the `next`, `completed`, and `error` events.
- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock
{
    NSParameterAssert(nextBlock != nil && errorBlock != nil && completedBlock != nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nextBlock error:errorBlock completed:completedBlock];
    return [self subscribe:o];
}

/// Convenience method to subscribe to `error` events.
- (VZSignalDisposalProxy *)subscribeError:(void (^)(NSError *error))errorBlock
{
    NSParameterAssert(errorBlock != nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nil error:errorBlock completed:nil];
    return [self subscribe:o];

}

/// Convenience method to subscribe to `completed` events.
- (VZSignalDisposalProxy *)subscribeCompleted:(void (^)(void))completedBlock
{
    NSParameterAssert(completedBlock != nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nil error:nil completed:completedBlock];
    return  [self subscribe:o];
}

/// Convenience method to subscribe to `next` and `error` events.
- (VZSignalDisposalProxy *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock
{
    NSParameterAssert(nextBlock!=nil && errorBlock !=nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nextBlock error:errorBlock completed:nil];
    return [self subscribe:o];
}

/// Convenience method to subscribe to `error` and `completed` events.
- (VZSignalDisposalProxy *)subscribeError:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock
{
    NSParameterAssert(errorBlock != nil && completedBlock != nil);
    
    VZSignalSubscriber* o = [VZSignalSubscriber subscriberWithNext:nil error:errorBlock completed:completedBlock];
    return [self subscribe:o];
}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functional

+ (VZSignal* )pass:(id)value
{
    return [VZValueSignal pass:value];
}

+ (VZSignal* )empty
{
    return [VZEmptySignal empty];
}

+ (VZSignal* )error:(NSError* )err
{
    return [VZErrorSignal error:err];
}

+ (VZSignal* )combine:(id<NSFastEnumeration>)list reduce:(id(^)())reduceBlock
{
    NSParameterAssert(reduceBlock != nil);
    
    VZSignal* combinedSigs = [self combineLatest:list];
    VZSignal* reducedSig = nil;
  
    if (reduceBlock) {
        reducedSig = [combinedSigs reduce:reduceBlock];
    }
    
    reducedSig -> _name = @"-combine-reduce";
    
    return reducedSig;
}

+ (VZSignal *)combineLatest:(id<NSFastEnumeration>)signals {
    
    VZSignal* sig = [self join:signals block:^VZSignal *(VZSignal* left, VZSignal* right) {
        
        VZSignal* combinedSig =  [left combineLatestWith:right];
        return combinedSig;
        
    }];
    
    sig -> _name = @"-combine latest signals";
    
    return sig;
}

+ (VZSignal* )join:(id<NSFastEnumeration>)signals block:(VZSignal* (^)(id,id))block
{
    VZSignal *current = nil;
    
    for (VZSignal *signal in signals)
    {
        //第一个signal中的输出变为tuple
        if (current == nil) {
            current = [signal map:^(id x) {
                
                id ret = [VZTuple tupleWithObjects:x, nil];
                
                return ret;
            }];
            
            continue;
        }
        
        current = block(current, signal);
    }
    
    if (current == nil)
        return [self empty];
    
    VZSignal* sig = [current map:^(VZTuple *xs) {
        // Right now, each value is contained in its own tuple, sorta like:
        //
        // (((1), 2), 3)
        //
        // We need to unwrap all the layers and create a tuple out of the result.
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        while (xs != nil) {
            [values insertObject:xs.last ?: [NSNull null] atIndex:0];
            xs = (xs.count > 1 ? xs.first : nil);
        }
        
        return [VZTuple tupleWithArray:values];
    }];
    
    sig -> _name = @"-join";
    
    
    return sig;
}


+ (VZSignal *)defer:(VZSignal * (^)(void))block {
    NSCParameterAssert(block != NULL);
    
    return [[VZSignal createSignal:^(id<VZSignalSubscriber> subscriber) {
        return [block() subscribe:subscriber];
    }] setNameWithFormat:@"+defer:"];
}



- (VZSignal* )flattenMap:(VZSignal *(^)(id))block
{
    Class clz = [self class];
    
    //function currying:
    VZSignal* sig = [self bind:^VZSignalBindBlock{
        
        VZSignal*(^retBlock)(id value, BOOL* stop) = ^VZSignal* (id value, BOOL* stop)
        {
            id signal = block(value) ?: [clz empty];
            
            return signal;
        };
        
        return retBlock;
        
        
    }];
    sig -> _name = @"-flattenMap";
    
    return sig;
}

- (VZSignal* )map:(id (^)(id))block
{
    NSParameterAssert(block != nil);
    
    Class class = self.class;
    
    VZSignal* sig = [self flattenMap:^VZSignal *(id value) {
        
        id ret = block(value);
        
        return [class pass:ret ];
    }];
    
    sig -> _name = @"-map";
    
    return sig;
}

- (VZSignal* )filter:(BOOL (^)(id))block {
   
    NSCParameterAssert(block != nil);
    
    Class class = self.class;
    
    VZSignal* sig = [self flattenMap:^ id (id value) {
        
        if (block(value))
        {
            return [class pass:value];
        } else {
            return class.empty;
        }
    }];
    
    sig -> _name = @"-filter";
    
    return sig;
}

- (VZSignal* )reduce:(id(^)())block
{
     NSCParameterAssert(block != nil);
    
    VZSignal* sig = [self map:^id(VZTuple* value) {
       
        NSCAssert([value isKindOfClass:[VZTuple class]], @"Value from signal is not a tuple: %@",value);
    
        return [VZDynamicBlock invokeBlock:block withArguments:value];
    
    }];
    
    sig -> _name = @"-reduce";
    
    return sig;
}

- (VZSignal* )combineLatestWith:(VZSignal* )signal
{
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        VZSignalDisposalProxy* compoundDisposals = [VZSignalDisposalProxy proxy];
        
        
        __block id lastSelfValue = nil;
        __block BOOL selfCompleted = NO;
        
        
        __block id lastOtherValue = nil;
        __block BOOL otherCompleted = NO;
        
        
        void (^sendNext)(void) = ^{
            @synchronized (compoundDisposals) {
                if (lastSelfValue == nil || lastOtherValue == nil) return;
                
                VZTuple* tuple = [VZTuple tupleWithObjects:lastSelfValue,lastOtherValue, nil];
                
                [subscriber sendNext:tuple];
            }
        };
        
        
        //subscribe self
        VZSignalDisposalProxy* selfSignalDisposal = [self subscribeNext:^(id x) {
            
            @synchronized (compoundDisposals) {
                lastSelfValue = x ?: [NSNull null];
                sendNext();
            }
            
        } error:^(NSError *error) {
            
            [subscriber sendError:error];
            
        } completed:^{
            
            @synchronized (compoundDisposals) {
                
                selfCompleted = YES;
                
                if (otherCompleted)
                    [subscriber sendCompleted];
            }
        }];
        
        
        //subscribe other
        VZSignalDisposalProxy* otherSignalDisposal = [signal subscribeNext:^(id x) {
            
            @synchronized (compoundDisposals) {
                lastOtherValue = x ?: [NSNull null];
                sendNext();
            }
            
        } error:^(NSError *error) {
            
            [subscriber sendError:error];
            
        } completed:^{
           
            if (selfCompleted) {
                [subscriber sendCompleted];
            }
            
        }];
        
        [compoundDisposals addDisposalProxy:selfSignalDisposal];
        [compoundDisposals addDisposalProxy:otherSignalDisposal];
        
        return compoundDisposals;
        
        }];
    
    sig -> _name = @"-combine latest signal";
    
    return sig;
}


- (VZSignal *)concat:(VZSignal *)signal
{
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
       
        
        VZSignalDisposalProxy* disposalProxy = [VZSignalDisposalProxy proxy];
        
        VZSignalDisposalProxy* origDisposal = [self subscribeNext:^(id x) {
            
            [subscriber sendNext:x];
            
        } error:^(NSError *error) {
            
            [subscriber sendError:error];
            
        } completed:^{
            
            VZSignalDisposalProxy* otherDisposal = [signal subscribe:subscriber];
            [disposalProxy addDisposalProxy:otherDisposal];
        }];
        
        [disposalProxy addDisposalProxy:origDisposal];
        
        return disposalProxy;
        
        
    }];
    
    sig -> _name = @"-concat";
    
    return sig;
}





////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Side effect

- (VZSignal* )doNext:(void(^)(id value))block
{
    NSCParameterAssert(block != NULL);
    
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        VZSignalDisposalProxy* disposal = [self subscribeNext:^(id x) {
            
            block(x);
            [subscriber sendNext:x];
            
        } error:^(NSError *error) {
            
            [subscriber sendError:error];
            
        } completed:^{
            
            [subscriber sendCompleted];
        }];
        
        return disposal;
    }];
    
    sig -> _name = @"-doNext";
    
    return sig;
}

- (VZSignal* )doError:(void(^)(NSError* err))block
{
    NSCParameterAssert(block != NULL);
    
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        VZSignalDisposalProxy* disposal = [self subscribeNext:^(id x) {
            
            [subscriber sendNext:x];
            
        } error:^(NSError *error) {
            
            block(error);
            [subscriber sendError:error];
            
        } completed:^{
            
            [subscriber sendCompleted];
        }];
        
        return disposal;
    }];
    
    sig -> _name = @"-doError";
    
    return sig;
}

- (VZSignal* )doComplete:(void(^)(void))block
{
    NSCParameterAssert(block != NULL);
    
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
        
        VZSignalDisposalProxy* disposal = [self subscribeNext:^(id x) {
            
            [subscriber sendNext:x];
            
        } error:^(NSError *error) {
            
            [subscriber sendError:error];
            
        } completed:^{
            
            block();
            [subscriber sendCompleted];
        }];
        
        return disposal;
    }];
    
    sig -> _name = @"-doNext";
    
    return sig;
}



////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - bind

- (VZSignal* )bind:(VZSignalBindBlock (^)(void))block
{
    NSParameterAssert(block != nil);
    

    //理解Monad:
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
       
        VZSignalBindBlock bindingBlock = block();
        
//        NSMutableArray* signals = [NSMutableArray arrayWithObject:self];
//        
//        VZSignalDisposalProxy *compoundDisposable = [VZSignalDisposalProxy proxy];
//        
//        
//        //完成后
//        void (^completeSignal)(VZSignal *, VZSignalDisposal *) = ^(VZSignal *signal, VZSignalDisposal *finishedDisposable) {
//            
//            @synchronized (signals) {
//                
//                [signals removeObject:signal];
//                
//                if (signals.count == 0) {
//                    [subscriber sendCompleted];
//                    [compoundDisposable disposeAll];
//                    
//                } else {
//                    
//                    [compoundDisposable removeDisposal:finishedDisposable];
//                }
//            }
//        };
        
        //add signal
//        void (^addSignal)(VZSignal *) = ^(VZSignal *signal) {
//            @synchronized (signals) {
//                [signals addObject:signal];
//            }
//            
//            VZSignalDisposal* selfDisposable = [VZSignalDisposal new];
//            [compoundDisposable addDisposal:selfDisposable];
//            
//            VZSignalDisposalProxy *disposable = [signal subscribeNext:^(id x) {
//                [subscriber sendNext:x];
//            } error:^(NSError *error) {
//                
//                [compoundDisposable disposeAll];
//                [subscriber sendError:error];
//                
//            } completed:^{
//                @autoreleasepool {
//                    completeSignal(signal, selfDisposable);
//                }
//            }];
//        };

        @autoreleasepool
        {
//            VZSignalDisposal *selfDisposable = [[VZSignalDisposal alloc] init];
//            [compoundDisposable addDisposal:selfDisposable];
//            
            VZSignalDisposalProxy *bindingDisposable = [self subscribeNext:^(id x) {
                // Manually check disposal to handle synchronous errors.
                //if (compoundDisposable.isDisposed) return;
                
                BOOL stop = NO;
                id signal = bindingBlock(x, &stop);
                
                @autoreleasepool
                {
                    if (signal != nil)
                    {
                        [signal subscribeNext:^(id x) {
                            
                            [subscriber sendNext:x];
                            
                        } error:^(NSError *error) {
                            
                            [subscriber sendError:error];
                            
                        } completed:^{
                            
                           // NSLog(@"name:%@",[signal valueForKey:@"name"]);
                            
                            [subscriber sendCompleted];
                            
                        }];
                    }
                  
                    if (signal == nil || stop)
                    {
//                        [selfDisposable dispose];
//                        completeSignal(self, selfDisposable);
                        [subscriber sendCompleted];
                    }
                }
            } error:^(NSError *error) {
                //[compoundDisposable disposeAll];
                [subscriber sendError:error];
            } completed:^{
//                @autoreleasepool {
//                    completeSignal(self, selfDisposable);
//                }
                [subscriber sendCompleted];
            }];
            
            //selfDisposable.disposable = bindingDisposable;
        }
        
        //return compoundDisposable;
        return nil;
    }];
    
    
    sig -> _name = @"-bind";
    
    return sig;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - thread

- (void)deliverOnBackgroundThread
{

}

- (void)deliverOnMainThread
{

}

- (void)deliverOn:(VZSignalScheduler* )scheduler
{

}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subscription

- (void)setKeypath:(NSString *)keypath onTarget:(id)target
{
    NSParameterAssert(keypath != nil);
    NSParameterAssert(target!= nil);
    
    NSString* keyPath = [keypath copy];
    
    VZSignalDisposalProxy *disposalProxy = [VZSignalDisposalProxy proxy];
    
    __block void * volatile objectPtr = (__bridge void *)target;
    
    //这里触发signal
    VZSignalDisposalProxy *subscriptionDisposal = [self subscribeNext:^(id x) {

        __strong NSObject *object __attribute__((objc_precise_lifetime)) = (__bridge __strong id)objectPtr;
        [target setValue:x ?: nil forKeyPath:keyPath];
    } error:^(NSError *error) {
        __strong NSObject *object __attribute__((objc_precise_lifetime)) = (__bridge __strong id)objectPtr;
        
        NSCAssert(NO, @"Received error from %@ in binding for key path \"%@\" on %@: %@", self, keyPath, object, error);
        
        NSLog(@"Received error from %@ in binding for key path \"%@\" on %@: %@", self, keyPath, object, error);
        
        [disposalProxy disposeAll];
        
    } completed:^{
        [disposalProxy disposeAll];
    }];
    
    [disposalProxy addDisposals:[subscriptionDisposal allDisposals]];
    
    
    VZSignalDisposal* cleanDisposal = [VZSignalDisposal disposableWithBlock:^{
        
        while (YES) {
            void *ptr = objectPtr;
            if (OSAtomicCompareAndSwapPtrBarrier(ptr, NULL, &objectPtr)) {
                break;
            }
        }
        
    }];
    
    [disposalProxy addDisposal:cleanDisposal];
    
   
    
    //[object.rac_deallocDisposable addDisposable:disposable];
    
//    RACCompoundDisposable *objectDisposable = object.rac_deallocDisposable;
//    return [RACDisposable disposableWithBlock:^{
//        [objectDisposable removeDisposable:disposable];
//        [disposable dispose];
//    }];
}



////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Name

- (instancetype)setNameWithFormat:(NSString* )format,...
{
#if DEBUG
    NSCParameterAssert(format != nil);
    
    va_list args;
    va_start(args, format);
    
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    _name = str;
    return self;
#else
    return self;

#endif

}


@end

@implementation VZValueSignal


+ (VZSignal* )pass:(id)value
{
    VZValueSignal* sig = [VZValueSignal new];
    sig ->_value = value;
    [sig setValue:@"-pass" forKey:@"name"];
    return sig;
}

- (VZSignalDisposalProxy* )subscribe:(id<VZSignalSubscriber>)subscriber
{
    [subscriber sendNext:self.value];
    [subscriber sendCompleted];
    
    return nil;
}

@end

@implementation VZErrorSignal

+ (VZSignal* )error:(NSError *)err
{
    VZErrorSignal* sig = [VZErrorSignal new];
    sig -> _error = err;
    [sig setValue:@"-error" forKey:@"name"];
    return sig;
}

- (VZSignalDisposalProxy *)subscribe:(id<VZSignalSubscriber>)subscriber {
    NSCParameterAssert(subscriber != nil);
    
    [subscriber sendError:self.error];
    
    return nil;
//    return [RACScheduler.subscriptionScheduler schedule:^{
//        [subscriber sendError:self.error];
//    }];
}

@end

@implementation VZEmptySignal

+ (VZSignal* )empty
{
    static id singleton;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
        [singleton setValue:@"-empty" forKey:@"name"];
    });
    
    return singleton;
}

- (VZSignalDisposalProxy* )subscribe:(id<VZSignalSubscriber>)subscriber
{
    NSParameterAssert(subscriber != nil);
    
    [subscriber sendCompleted];
    
    return nil;
}

@end


