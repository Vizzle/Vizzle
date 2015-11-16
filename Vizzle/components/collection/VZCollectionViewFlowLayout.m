//
//  VZCollectionViewFlowLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionViewFlowLayout.h"
#import "VZCollectionViewDataSource.h"
#import "VZCollectionItem.h"

@interface VZCollectionViewFlowLayout()

@end

@implementation VZCollectionViewFlowLayout

@synthesize controller = _controller;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VZCollectionViewDataSource* ds = (VZCollectionViewDataSource* )self.controller.dataSource;
    NSArray* items = [ds itemsForSection:indexPath.section];
    
    if (indexPath.row < items.count) {
        
        VZCollectionItem* item = items[indexPath.row];
        return [self sizeOfCellWithItem:item AtIndexPath:indexPath];
        //CGSize sz = [self sizeOfCellWithItem:item AtIndexPath:indexPath];
    }
    else
    {
        return CGSizeZero;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self insectForSection:section];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self lineSpacingForSection:section];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self itemSpaceingForSection:section];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [self sizeForHeaderViewAtSectionIndex:section];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return [self sizeForFooterViewAtSectionIndex:section];
}

- (CGSize) sizeOfCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* )indexPath
{
    return CGSizeMake(item.itemWidth, item.itemHeight);
}

- (UIEdgeInsets) insectForSection:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (NSInteger) lineSpacingForSection:(NSInteger)section
{
    return 0;
}

- (NSInteger) itemSpaceingForSection:(NSInteger)section
{
    return 0;
}

- (CGSize) sizeForHeaderViewAtSectionIndex:(NSInteger)height
{
    return CGSizeZero;
}

- (CGSize) sizeForFooterViewAtSectionIndex:(NSInteger)height
{
    return CGSizeZero;
}


@end
