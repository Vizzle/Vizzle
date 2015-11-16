//
//  BXTWTripCollectionCell.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripCollectionCell.h"
#import "BXTWTripListItem.h"

@interface BXTWTripCollectionCell()

@property(nonatomic,strong)UIImageView* icon;

@end

@implementation BXTWTripCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.icon.layer.borderColor = [UIColor redColor].CGColor;
        self.icon.layer.borderWidth = 2.0f;
        [self.contentView addSubview:self.icon];
    }
    return self;
}

- (void)setItem:(BXTWTripListItem *)item
{
    [super setItem:item];
    
    [self.icon setImageWithURL:[NSURL URLWithString:item.servicePicUrl] placeholderImage:[UIImage imageNamed:@"default_list.jpg"]];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BXTWTripListItem* item = (BXTWTripListItem* )self.item;
    
    self.icon.frame = CGRectMake(0, 0, item.itemWidth, item.itemHeight);
    
    
}

@end
