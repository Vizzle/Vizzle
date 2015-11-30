//
//  BXTWTripLayoutChangeSegment.m
//  VizzleListExample
//
//  Created by moxin on 15/11/27.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripLayoutSectionHeader.h"
#import "VZCollectionSupplementaryItem.h"

@interface BXTWTripLayoutSectionHeader()

@property(nonatomic,strong)UISegmentedControl* segmentControl;

@end

@implementation BXTWTripLayoutSectionHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"WaterFall",@"List"]];
        self.segmentControl.selectedSegmentIndex = 0;
        [self.segmentControl addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.segmentControl];
    
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.frame = CGRectMake(layoutAttributes.frame.origin.x, layoutAttributes.frame.origin.y, layoutAttributes.frame.size.width, layoutAttributes.size.height);
    self.segmentControl.frame = CGRectInset(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), 10, 10);
}

- (void)onSegmentChanged:(UISegmentedControl* )seg
{
    VZCollectionSupplementaryItem* item = self.item;
    if (item.viewConfigurationBlock) {
        item.viewConfigurationBlock(self,@(seg.selectedSegmentIndex));
    }
}

@end
