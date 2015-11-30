//
//  BXTWTripCollectionViewLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripWaterflowLayout.h"
#import "BXTWTripListItem.h"
#import "BXTWTripConfig.h"

@implementation BXTWTripWaterflowLayout

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(BXTWTripListItem* )item AtIndexPath:(NSIndexPath *)indexPath
{
    VZCollectionLayoutAttributes attr = vz_defaultAttributes();
    CGRect itemRect = CGRectMake(item.x, item.y, item.itemWidth, item.itemHeight);
    attr.frame = CGRectInset(itemRect, 5, 5);
    return attr;

}
- (CGSize)calculateScrollViewContentSize
{
    NSLog(@"begin calc ulate layout!");
    int i=0;
    int topl = kSegmentHeaderHeight;
    int topr = kSegmentHeaderHeight;
    int w = CGRectGetWidth(self.collectionView.frame);
    NSArray* items = [self.controller.dataSource itemsForSection:0];
    
    for (BXTWTripListItem* item in items) {

        //left
        if (i%2 == 0)
        {
            topl += item.itemHeight;
        }
        //right
        else
        {
            topr += item.itemHeight;
        }
        i++;
    }
    
    CGSize sz = CGSizeMake(w, MAX(topl, topr));
    NSLog(@"end calculate layout:%.1f!",sz.height);
    
    return sz;
}

- (VZCollectionLayoutAttributes)layoutAttributesForHeaderView:(NSString *)identifier AtSectionIndex:(NSInteger)section
{
    VZCollectionLayoutAttributes attr = vz_defaultAttributes();
    
    if (section == 0) {
      
        attr.frame = CGRectMake(0, 0, CGRectGetWidth(self.controller.collectionView.bounds), 44);
    }
    
    return attr;
}

- (VZCollectionLayoutAttributes)layoutAttributesForFooterView:(NSString *)identifier AtSectionIndex:(NSInteger)section
{
    VZCollectionLayoutAttributes attr = vz_defaultAttributes();
    
    if (section == 0) {
        
        attr.frame = CGRectMake(0, 0, CGRectGetWidth(self.controller.collectionView.bounds), 44);
    }
    
    return attr;
}


@end
