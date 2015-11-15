//
//  VZCollectionCell.m
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionCell.h"

@implementation VZCollectionCell

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _item = nil;
    _delegate = nil;
}

@end
