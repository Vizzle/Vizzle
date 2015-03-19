//
//  VZViewModel.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZViewModel.h"
#import "VZObserverProxy.h"
#import "NSObject+VZChannel.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "VZSignal.h"
#import "VZEXT.h"
#import "VZEXT_API.h"
#import "NSObject+VZSignal.h"
#import "VZSignal.h"
#import "VZSignalDisposal.h"
#import "VZSignalDisposalProxy.h"
#import "VZDummyBindingObject.h"
#import "VZSignalSubscriber.h"
#import "UIControl+VZSignal.h"


@interface VZViewModel()

@property(nonatomic,strong) NSMutableDictionary* map;

@end

@implementation VZViewModel

- (instancetype )initWithIdentifier:(NSString* )identifier
{
    self = [super init];
    
    if (self) {

        _identifier = identifier;

        [self observeSelf];
        
        [self observeCallback];
        
    }
    return self;
}

- (void)observeSelf
{

}

- (void)observeCallback
{

}

- (void)fire:(id) data id:(NSString* )viewId
{
    //将数据包装一下，发个channel
    NSString* name = [NSString stringWithFormat:@"%@-%@",self.identifier,viewId];
    [self vz_postToChannel:name withObject:self Data:data];
}

- (void)dealloc
{
    [self.proxy unObserveAll];
    [self vz_removeFromChannel];
}



@end
