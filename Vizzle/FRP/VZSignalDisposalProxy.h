//
//  VZSignalDisposalProxy.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-3.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZSignalDisposal;
@class VZSignalDisposalProxy;

@interface VZSignalDisposalProxy : NSObject

@property(nonatomic,assign,readonly) BOOL isDisposed;
@property(nonatomic,strong) NSString* name;


+ (instancetype)proxy;

+ (instancetype)proxyWithDisposal:(VZSignalDisposal* )disposal;

- (void)disposeAll;



@end

@interface VZSignalDisposalProxy(Disposals)

- (NSArray* )allDisposals;

- (void)addDisposal:(VZSignalDisposal* )disposal;

- (void)addDisposals:(NSArray* )disposals;

- (void)removeDisposal:(VZSignalDisposal* )dispsal;

- (void)removeDisposals:(NSArray *)dispsals;

- (void)disposeAllDisposals;

@end

@interface VZSignalDisposalProxy(DisposalProxys)

- (NSArray* )allDisposalProxys;

- (void)addDisposalProxy:(VZSignalDisposalProxy* )proxy;

- (void)removeDisposalProxy:(VZSignalDisposalProxy* )proxy;

- (void)disposeAllDisposalProxys;

@end
