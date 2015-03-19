//
//  UIControl+VZSignal.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-26.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "UIControl+VZSignal.h"
#import "VZSignal.h"
#import "VZSignalDisposal.h"
#import "VZSignalDisposalProxy.h"
#import "NSObject+Deallocation.h"
#import "VZSignalSubscriber.h"

@implementation UIControl (VZSignal)

- (VZSignal* )vz_signalForControlEvents:(UIControlEvents)controlEvents
{
    __weak typeof(self) weakSelf = self;
    
    VZSignal* sig = [VZSignal createSignal:^VZSignalDisposalProxy *(id<VZSignalSubscriber> subscriber) {
    
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        [strongSelf addTarget:subscriber action:@selector(sendNext:) forControlEvents:UIControlEventTouchUpInside];
        
        VZSignalDisposal* disposal = [VZSignalDisposal disposableWithBlock:^{
            
            [subscriber sendCompleted];
        }];
        
        [strongSelf.vz_deallocDisposalProxy addDisposal:disposal];
        
        
        VZSignalDisposalProxy* ret  = [VZSignalDisposalProxy proxyWithDisposal:[VZSignalDisposal disposableWithBlock:^{
            
            [strongSelf removeTarget:subscriber action:@selector(sendNext:) forControlEvents:UIControlEventTouchUpInside];
            
        }]];
        
        return ret;
        
    }];
    
    return sig;
    
}



@end
