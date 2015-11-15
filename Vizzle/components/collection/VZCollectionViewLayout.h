//
//  VZCollectionViewLayout.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct
{
    CGRect frame;
    CGPoint center;
    CGSize size;
    CATransform3D transform3D;
    CGAffineTransform tranform2D;
    CGFloat alpha;
    NSInteger zIndex;
    
}VZCollectionLayoutAttributes;

@class VZCollectionItem;
@class VZCollectionViewController;
@protocol VZCollectionViewLayoutInterface;

@interface VZCollectionViewLayout : UICollectionViewLayout<VZCollectionViewLayoutInterface>

@property(nonatomic,weak)VZCollectionViewController* controller;

@end

@interface VZCollectionViewLayout(attributes)

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* ) indexPath;
- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )kind AtSectionIndex:(NSInteger) section;
- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )kind AtSectionIndex:(NSInteger) section;

@end