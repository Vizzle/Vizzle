//
//  VZCollectionViewFlowLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionViewFlowLayout.h"
#import "VZCollectionViewController.h"
#import "VZCollectionViewDataSource.h"
#import "VZCollectionItem.h"
#import "VZCollectionViewConfig.h"

@interface VZCollectionViewFlowLayout()

@end

@implementation VZCollectionViewFlowLayout

@synthesize controller = _controller;
@synthesize shouldExtendScrollContentSize = _shouldExtendScrollContentSizel;


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewLayout


- (CGSize)collectionViewContentSize
{
    CGSize sz = [super collectionViewContentSize];
    if (self.shouldExtendScrollContentSize) {
        return CGSizeMake(sz.width, sz.height+kVZCollectionViewFooterViewHeight);
    }
    return sz;
}


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclass Override

- (CGSize) sizeOfCellAtIndexPath:(NSIndexPath* )indexPath
{
    VZCollectionViewDataSource* ds = (VZCollectionViewDataSource* )self.controller.dataSource;
    NSArray* items = [ds itemsForSection:indexPath.section];
    
    if (indexPath.row < items.count) {
        
        VZCollectionItem* item = items[indexPath.row];
        return CGSizeMake(item.itemWidth, item.itemHeight);
    }
    else
    {
        return CGSizeZero;
    }
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
