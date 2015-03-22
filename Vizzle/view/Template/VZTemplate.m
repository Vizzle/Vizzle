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
        
        [self createSubViews];
        [self createBindings];
        
    }
    return self;
}

- (void)dealloc
{
    
    //[self.proxy unObserveAll];
    [self vz_removeFromChannel];
}

- (void)createSubViews
{
    
    
}

- (void)createBindings
{
   
}



- (UIView* )findViewById:(NSUInteger)tag
{
    UIView* ret = nil;
    for (UIView* v in self.contentView.subviews) {
        
        if (v.tag == tag) {
            
            ret = v;
            break;
        }
    }
    return ret;
}


- (void)fire:(id)data id:(NSString* )identifier
{
    NSString* name = [NSString stringWithFormat:@"%@-%@",self.identifier,identifier];
    [self vz_postToChannel:name withObject:self Data:data];
}


@end


