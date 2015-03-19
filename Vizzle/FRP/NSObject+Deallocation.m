//
//  NSObject+Deallocation.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-26.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "NSObject+Deallocation.h"
#import "VZSignalDisposalProxy.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const void *VZSignalDispsalProxyKey = &VZSignalDispsalProxyKey;


static NSMutableSet *vz_swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

static void vz_swizzleDeallocMethod(Class classToSwizzle) {
    @synchronized (vz_swizzledClasses())
    {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([vz_swizzledClasses() containsObject:className]) return;
        
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        
        
        //new dealloc method
        id newDealloc = ^(__unsafe_unretained id self)
        {
            VZSignalDisposalProxy *proxy = objc_getAssociatedObject(self, VZSignalDispsalProxyKey);
            [proxy disposeAll];
            
            if (originalDealloc == NULL)
            {
                //call [super dealloc]
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            }
            else
            {
                //call original dealloc
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {

            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
        [vz_swizzledClasses() addObject:className];
    }
}

@implementation NSObject (Deallocation)


- (VZSignalDisposalProxy* )vz_deallocDisposalProxy
{
    @synchronized(self)
    {
        VZSignalDisposalProxy* proxy = objc_getAssociatedObject(self, VZSignalDispsalProxyKey);
        
        if (proxy) {
            return proxy;
        }
    
        vz_swizzleDeallocMethod([self class]);
        
        proxy = [VZSignalDisposalProxy proxy];
        objc_setAssociatedObject(self, VZSignalDispsalProxyKey, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return proxy;
    }
}

@end
