//
//  VZTemplate.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-14.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZTemplate.h"
#import "NSObject+VZChannel.h"
#import "NSObject+VZSignal.h"
#import "VZObserverProxy.h"
#import "NSObject+VZOberveProxy.h"


typedef void(^TemplateCallback)(id value);

@interface VZTemplate()


@end

@implementation VZTemplate
{
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame Identifier:@""];
}
- (instancetype)initWithFrame:(CGRect)frame Identifier:(NSString *)identifier
{
    self = [super init];

    if (self) {
        
        _identifier = identifier;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        
    }
    return self;
}

- (void)dealloc
{
    [self endBinding];
}

- (NSString* )key:(NSString* )key
{
    return [NSString stringWithFormat:@"%@-%@",self.identifier,key];
}



- (void)beginBinding
{

}

- (void)endBinding
{
    self.kvoProxy = nil;
    [self vz_removeFromChannel];
}


@end


