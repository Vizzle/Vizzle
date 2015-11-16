//
//  VZCollectionViewFlowLayout.h
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZCollectionViewLayoutInterface.h"
@class VZCollectionItem;
@interface VZCollectionViewFlowLayout : UICollectionViewFlowLayout<VZCollectionViewLayoutInterface,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak)VZCollectionViewController* controller;

- (CGSize) sizeOfCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* )indexPath;

- (UIEdgeInsets) insectForSection:(NSInteger)section;

- (NSInteger) lineSpacingForSection:(NSInteger)section;

- (NSInteger) itemSpaceingForSection:(NSInteger)section;

- (CGSize) sizeForHeaderViewAtSectionIndex:(NSInteger)height;

- (CGSize) sizeForFooterViewAtSectionIndex:(NSInteger)height;

@end
