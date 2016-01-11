//
//  VZCollectionDefaultLoadingCell.m
//  VizzleListExample
//
//  Created by moxin on 16/1/11.
//  Copyright © 2016年 VizLab. All rights reserved.
//

#import "VZCollectionDefaultLoadingCell.h"
#import "VZCollectionDefaultTextItem.h"
#import "VZCollectionItem.h"

@implementation VZCollectionDefaultLoadingCell
{
    UIActivityIndicatorView* _indicator;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGRect frame = self.contentView.frame;
        
        _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(frame)-20)/2, (CGRectGetHeight(frame)-20)/2, 20, 20)];
        _indicator.color = [UIColor redColor];
        [_indicator stopAnimating];
        
        [self.contentView addSubview:_indicator];
        
    }
    return self;
}
- (void)setItem:(VZCollectionItem *)item
{
    [super setItem:item];
    
    if ([item isKindOfClass:[VZCollectionDefaultTextItem class]]) {
        [_indicator startAnimating];
    }
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
    _indicator.hidden = NO;
    _indicator.frame = CGRectMake((CGRectGetWidth(frame)-20)/2, (CGRectGetHeight(frame)-20)/2, 20, 20);
    
}
@end
