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

//--调用次序:
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
            
            VZCollectionLayoutAttributes attr = [self layoutAttributesForCellWithItem:item AtIndexPath:indexPath];
            UICollectionViewLayoutAttributes* cellAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            cellAttr.frame = attr.frame;
            cellAttr.center = CGPointMake(attr.frame.origin.x + 0.5*CGRectGetWidth(attr.frame), attr.frame.origin.y+0.5*CGRectGetHeight(attr.frame));
            cellAttr.size = CGSizeMake(attr.frame.size.width, attr.frame.size.height);
            cellAttr.transform = attr.transform2D;
            cellAttr.transform3D = attr.transform3D;
            cellAttr.alpha = attr.alpha;
            cellAttr.zIndex = attr.zIndex;
            
            [self.attrs addObject:cellAttr];
        }
    
        //add section header & footer
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionNum.integerValue];
        
//        UICollectionViewLayoutAttributes* supplementaryHeaderAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes* supplementaryHeaderAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [self.attrs addObject:supplementaryHeaderAttr];
        
        UICollectionViewLayoutAttributes* supplementaryFooterAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        [self.attrs addObject:supplementaryFooterAttr];
        
        
//        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionNum.integerValue]];
//        supplementaryHeaderAttr.frame = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionNum.integerValue]].frame;
//        [self.attrs addObject:supplementaryHeaderAttr];
        
//        
//        UICollectionViewLayoutAttributes* supplementaryFooterAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:-1 inSection:sectionNum.integerValue]];
//        [self.attrs addObject:supplementaryFooterAttr];

    }];
}

- (CGSize)collectionViewContentSize
{
    CGRect frame = self.collectionView.frame;
    CGSize sz = [self calculateScrollViewContentSize];
    return CGSizeMake(MAX(frame.size.width, sz.width),MAX(frame.size.height, sz.height));
}

- (NSArray* )layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrs;
}

- (UICollectionViewLayoutAttributes* )layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.attrs.count) {
        return nil;
    }
    return self.attrs[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    VZCollectionLayoutAttributes attr = vz_defaultAttributes();
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        attr = [self layoutAttributesForHeaderView:nil AtSectionIndex:indexPath.section];
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        attr = [self layoutAttributesForFooterView:nil AtSectionIndex:indexPath.section];
    }
    vz_convertLayoutAttributesToUILayoutAttributes(attr, attributes);
    
    return attributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    VZCollectionLayoutAttributes attr = [self layoutAttributesForFooterView:decorationViewKind AtSectionIndex:indexPath.section];
    
    attributes.frame = attr.frame;
    attributes.center = CGPointMake(attr.frame.origin.x + 0.5*CGRectGetWidth(attr.frame), attr.frame.origin.y+0.5*CGRectGetHeight(attr.frame));
    attributes.size = CGSizeMake(attr.frame.size.width, attr.frame.size.height);
    attributes.transform = attr.transform2D;
    attributes.transform3D = attr.transform3D;
    attributes.alpha = attr.alpha;
    attributes.zIndex = attr.zIndex;
    
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclass methods

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath *)indexPath
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclass methods

static inline void vz_convertLayoutAttributesToUILayoutAttributes(VZCollectionLayoutAttributes vzAttr, UICollectionViewLayoutAttributes* uiAttr)
{
    uiAttr.frame        = vzAttr.frame;
    uiAttr.center       = CGPointMake(vzAttr.frame.origin.x + 0.5*CGRectGetWidth(vzAttr.frame), vzAttr.frame.origin.y+0.5*CGRectGetHeight(vzAttr.frame));
    uiAttr.size         = CGSizeMake(vzAttr.frame.size.width, vzAttr.frame.size.height);
    uiAttr.transform    = vzAttr.transform2D;
    uiAttr.transform3D  = vzAttr.transform3D;
    uiAttr.alpha        = vzAttr.alpha;
    uiAttr.zIndex       = vzAttr.zIndex;
}


@end
