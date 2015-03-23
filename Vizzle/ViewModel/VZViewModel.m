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
    
    }
    return self;
}
- (NSString* )key:(NSString* )key
{
    return [NSString stringWithFormat:@"%@-%@",self.identifier,key];
}

- (void)beginObserving
{

}

- (void)endObserving
{
    self.kvoProxy = nil;
    [self vz_removeFromChannel];
}


- (void)dealloc
{
    [self endObserving];
}



@end
