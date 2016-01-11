//
//  VZCollectionDefaultErrorCell.m
//  VizzleListExample
//
//  Created by moxin on 16/1/11.
//  Copyright © 2016年 VizLab. All rights reserved.
//

#import "VZCollectionDefaultErrorCell.h"
#import "VZCollectionItem.h"
#import "VZCollectionDefaultTextItem.h"

@implementation VZCollectionDefaultErrorCell
{
    UILabel* _label;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:16.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
        
    }
    return self;
}

- (void)setItem:(VZCollectionItem *)item
{
    [super setItem:item];
    
    if ([item isKindOfClass:[VZCollectionDefaultTextItem class]]) {
        _label.text = ((VZCollectionDefaultTextItem* )item).text;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
