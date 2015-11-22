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
@property(nonatomic,strong)NSMutableArray* attrs;

@end

@implementation VZCollectionViewLayout

@synthesize controller = _controller;

- (NSMutableArray* )attrs
{
    if (!_attrs) {
        _attrs = [NSMutableArray new];
    }
    return _attrs;
}

//--hooks:

//--prepareLayout
//--collectionViewContentSize
//--layoutAttribuetsForElementsInRect

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrs removeAllObjects];
    [self.controller.dataSource.itemsForSection enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSNumber* sectionNum = (NSNumber* )key;
        NSArray* items = (NSArray* )obj;
    
        for(int i=0; i<items.count;i++)
        {
            NSIndexPath* indexPath  = [NSIndexPath indexPathForItem:i inSection:sectionNum.intValue];
            VZCollectionItem* item = items[i];
            
            VZCollectionLayoutAttributes attr = [self layoutAttributesForCellWithItem:item];
           
            UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            attributes.frame = attr.frame;
            attributes.center = CGPointMake(attr.frame.origin.x + 0.5*CGRectGetWidth(attr.frame), attr.frame.origin.y+0.5*CGRectGetHeight(attr.frame));
            attributes.size = CGSizeMake(attr.frame.size.width, attr.frame.size.height);
            attributes.transform = attr.tranform2D;
            attributes.transform3D = attr.transform3D;
            attributes.alpha = attr.alpha;
            attributes.zIndex = attr.zIndex;
        
            [self.attrs addObject:attributes];
        }
        
    }];
}

/**
 *  自定义collectionview要指定
 *  scrollview的content size
 *
 *  @return contentsize大小
 */
- (CGSize)collectionViewContentSize
{
    CGRect frame = self.collectionView.frame;
    CGSize sz = [self calculateScrollViewContentSize];
    return CGSizeMake(MAX(frame.size.width, sz.width),MAX(frame.size.height, sz.height));
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
    return self.attrs;
}

- (UICollectionViewLayoutAttributes* )layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* items = self.controller.dataSource.itemsForSection[@(indexPath.section)];
    VZCollectionItem* item = items[indexPath.item];
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    VZCollectionLayoutAttributes attr = [self layoutAttributesForCellWithItem:item];
    attributes.frame = attr.frame;
    attributes.center = CGPointMake(attr.frame.origin.x + 0.5*CGRectGetWidth(attr.frame), attr.frame.origin.y+0.5*CGRectGetHeight(attr.frame));
    attributes.size = CGSizeMake(attr.frame.size.width, attr.frame.size.height);
    attributes.transform = attr.tranform2D;
    attributes.transform3D = attr.transform3D;
    attributes.alpha = attr.alpha;
    attributes.zIndex = attr.zIndex;
    
    return attributes;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//   //   NSLog(@"%s",__PRETTY_FUNCTION__);
//    
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
//    
//    VZCollectionLayoutAttributes attr = [self layoutAttributesForHeaderView:kind AtSectionIndex:indexPath.section];
//    
//    attributes.frame = attr.frame;
//    attributes.center = CGPointMake(attr.frame.origin.x + 0.5*CGRectGetWidth(attr.frame), attr.frame.origin.y+0.5*CGRectGetHeight(attr.frame));
//    attributes.size = CGSizeMake(attr.frame.size.width, attr.frame.size.height);
//    attributes.transform = attr.tranform2D;
//    attributes.transform3D = attr.transform3D;
//    attributes.alpha = attr.alpha;
//    attributes.zIndex = attr.zIndex;
//    
//    return attributes;
//}
//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
//    
//    //todo:/...
//    //  NSLog(@"%s",__PRETTY_FUNCTION__);
//    
//    
//    return attributes;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - subclass methods

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item
{
    VZCollectionLayoutAttributes attr = {CGRectZero,CATransform3DIdentity,CGAffineTransformIdentity,1,0};
    
    return attr;
}
- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )kind AtSectionIndex:(NSInteger) section
{
    VZCollectionLayoutAttributes attr = {CGRectZero,CATransform3DIdentity,CGAffineTransformIdentity,1,0};
    
    return attr;
}
- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )kind AtSectionIndex:(NSInteger) section
{
    VZCollectionLayoutAttributes attr = {CGRectZero,CATransform3DIdentity,CGAffineTransformIdentity,1,0};
    
    return attr;
}
- (CGSize)calculateScrollViewContentSize
{
    return CGSizeZero;
}


@end
