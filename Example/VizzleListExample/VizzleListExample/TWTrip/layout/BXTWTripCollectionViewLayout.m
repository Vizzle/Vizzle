//
//  BXTWTripCollectionViewLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripCollectionViewLayout.h"

@implementation BXTWTripCollectionViewLayout

@synthesize scrollViewContentSize = _scrollViewContentSize;


- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* ) indexPath
{
    
    VZCollectionLayoutAttributes attr;
    
    attr.frame = CGRectMake(item.x, item.y, item.itemWidth, item.itemHeight);
    attr.transform3D = CATransform3DIdentity;
    attr.tranform2D = CGAffineTransformIdentity;
    attr.alpha = 1.0f;
    attr.zIndex = 0;

    return attr;

}
//- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )kind AtSectionIndex:(NSInteger) section
//{
//
//}
//- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )kind AtSectionIndex:(NSInteger) section
//{
//
//}


@end
