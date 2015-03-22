//
//  VZViewModel.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZViewModel.h"

@interface VZViewModel()

@end

@implementation VZViewModel

- (id)init
{
    return [self initWithIdentifier:@""];
}

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
    //[self.proxy unObserveAll];
    [self vz_removeFromChannel];
    
    

    //[[VZChannel sharedInstance]vz_removeListener:self];
}



@end
