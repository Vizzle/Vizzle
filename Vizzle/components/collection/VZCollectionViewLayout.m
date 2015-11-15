//
//  VZCollectionViewLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionViewLayout.h"
#import "VZCollectionViewController.h"
#import "VZCollectionItem.h"


@interface VZCollectionViewLayout()

@end

@implementation VZCollectionViewLayout

//--hooks:

//--prepareLayout
//--collectionViewContentSize
//--layoutAttribuetsForElementsInRect

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewLayout

/**
 *  自定义collectionview要指定
 *  scrollview的content size
 *
 *  @return contentsize大小
 */
- (CGSize)collectionViewContentSize
{
    return [self scrollViewContentSize];
}
/**
 *  返回当前scrollview可见区域内，所有item的attribute对象
 *
 *  @param rect scrollview可见范围
 *
 *  @return attribute的数组
 */
- (NSArray* )layoutAttributesForElementsInRect:(CGRect)rect
{
    
    //add cell
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    [self.controller.dataSource.itemsForSection enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSNumber* sectionNum = (NSNumber* )key;
        NSArray* list = (NSArray* )obj;
        
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSIndexPath* index  = [NSIndexPath indexPathForItem:idx inSection:sectionNum.intValue];
            
            [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:index]];
            
        }];
    }];
    
    //add supplementary views
    
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* items = self.controller.dataSource.itemsForSection[@(indexPath.section)];
    VZCollectionItem* item = items[indexPath.item];
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    VZCollectionLayoutAttributes attr = [self layoutAttributesForCellWithItem:item AtIndexPath:indexPath];
    attributes.frame = attr.frame;
    attributes.center = attr.center;
    attributes.size = attr.size;
    attributes.transform = attr.tranform2D;
    attributes.transform3D = attr.transform3D;
    attributes.alpha = attr.alpha;
    attributes.zIndex = attr.zIndex;
    
    return attributes;
    
    
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    VZCollectionLayoutAttributes attr = [self layoutAttributesForHeaderView:kind AtSectionIndex:indexPath.section];
    
    attributes.frame = attr.frame;
    attributes.center = attr.center;
    attributes.size = attr.size;
    attributes.transform = attr.tranform2D;
    attributes.transform3D = attr.transform3D;
    attributes.alpha = attr.alpha;
    attributes.zIndex = attr.zIndex;
    
    return attributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    //todo:/...
    
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclass methods

- (CGSize)scrollViewContentSize
{
    return CGSizeZero;
}

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* ) indexPath
{
    VZCollectionLayoutAttributes attr = {CGRectZero,CGPointZero,CGSizeZero,CATransform3DIdentity,CGAffineTransformIdentity,1,0};
    
    return attr;
}
- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )kind AtSectionIndex:(NSInteger) section
{
    VZCollectionLayoutAttributes attr = {CGRectZero,CGPointZero,CGSizeZero,CATransform3DIdentity,CGAffineTransformIdentity,1,0};
    
    return attr;
}
- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )kind AtSectionIndex:(NSInteger) section
{
    VZCollectionLayoutAttributes attr = {CGRectZero,CGPointZero,CGSizeZero,CATransform3DIdentity,CGAffineTransformIdentity,1,0};
    
    return attr;
    
}


@end
