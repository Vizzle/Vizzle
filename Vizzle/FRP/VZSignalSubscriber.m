//
//  VZSignalSubscriber.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-31.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZSignalSubscriber.h"
#import "VZSignalDisposal.h"
#import "VZSignalDisposalProxy.h"


@interface VZSignalSubscriber()

@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^completed)(void);

@end

@implementation VZSignalSubscriber

+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed
{
    VZSignalSubscriber* sub = [VZSignalSubscriber new];
    sub.next = next;
    sub.error = error;
    sub.completed = completed;
   
    return sub;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        VZSignalDisposal* disposal = [VZSignalDisposal disposableWithBlock:^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            @synchronized(strongSelf)
            {
                strongSelf.next = nil;
                strongSelf.completed = nil;
                strongSelf.error = nil;
            }
        }];
        disposal.name = @"subscriber inner disposal ";
        _disposalProxy = [VZSignalDisposalProxy proxyWithDisposal:disposal];
        _disposalProxy.name = @"subscriber inner disposal proxy";
        
    }
    return self;
}

- (void)dealloc
{
    
    //NSLog(@"[%@]-->will dealloc",self);
    
    [self.disposalProxy disposeAll];
    
    //NSLog(@"[%@]-->did dealloc",self);
}



/**
 *
 *  These methods should be thread safe
 *
 *
 **/
- (void)sendNext:(id)value
{
    if (self.disposalProxy.isDisposed) {
        return;
    }
   
    @synchronized(self)
    {
        void (^nextBlock)(id) = [self.next copy];
        
        if (nextBlock)
        {
            nextBlock(value);
        }
        
    }

}

- (void)sendError:(NSError *)e
{
    if (self.disposalProxy.isDisposed) {
        return;
    }
    
    @synchronized (self) {
        void (^errorBlock)(NSError *) = [self.error copy];

        //终止signal
        [self.disposalProxy disposeAll];
        
        if (errorBlock)
        {
            errorBlock(e);
        }
    }
}

- (void)sendCompleted
{
    if (self.disposalProxy.isDisposed) {
        return;
    }
    
    @synchronized (self) {
        void (^completedBlock)(void) = [self.completed copy];

        //终止signal
        [self.disposalProxy disposeAll];
        
        if (completedBlock)
        {
            completedBlock();
        }
        
    }
}

- (void)addOtherSignalDisposalProxy:(VZSignalDisposalProxy* )proxy
{
    if ([proxy isDisposed]) {
        return;
    }
    [self.disposalProxy addDisposalProxy:proxy];

    
//    __weak typeof(self) weakSelf = self;
//    __unsafe_unretained typeof(proxy) weakProxy = proxy;
//    [proxy addDisposal:[VZSignalDisposal disposableWithBlock:^{
//        
//        __strong typeof(weakProxy) strongProxy = weakProxy;
//        [weakSelf.disposalProxy removeDisposalProxy:strongProxy];
//    }]];
}

@end
