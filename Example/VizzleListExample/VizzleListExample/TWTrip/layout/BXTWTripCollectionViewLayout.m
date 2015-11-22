//
//  BXTWTripCollectionViewLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripCollectionViewLayout.h"
#import "BXTWTripListItem.h"

@implementation BXTWTripCollectionViewLayout

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(BXTWTripListItem* )item
{
    
    VZCollectionLayoutAttributes attr;
    attr.frame = CGRectMake(item.x, item.y, item.itemWidth, item.itemHeight);
    attr.transform3D = CATransform3DIdentity;
    attr.tranform2D = CGAffineTransformIdentity;
    attr.alpha = 1.0f;
    attr.zIndex = 0;

    return attr;

}
- (CGSize)calculateScrollViewContentSize
{
    NSLog(@"begin calculate layout!");
    int i=0;
    int topl = 0;
    int topr = 0;
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
        
        NSLog(@"{x:%.1f,y:%.1f,w:%.1f,h:%.1f}",item.x,item.y,item.itemWidth,item.itemHeight);
    }

    CGSize sz = CGSizeMake(w, MAX(topl, topr));
    NSLog(@"end calculate layout:%.1f!",sz.height);
    
    return sz;
}


@end
