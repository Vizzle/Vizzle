//
//  VZCollectionViewLayoutInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    CGRect frame;
    CATransform3D transform3D;
    CGAffineTransform transform2D;
    CGFloat alpha;
    NSInteger zIndex;
    
}VZCollectionLayoutAttributes;

static inline VZCollectionLayoutAttributes vz_defaultAttributes(){

    return (VZCollectionLayoutAttributes)
            {
                .frame = CGRectZero,
                .transform3D = CATransform3DIdentity,
                .transform2D = CGAffineTransformIdentity,
                .alpha = 1.0f,
                .zIndex = 0
            };
};

@class VZCollectionViewController;

@protocol VZCollectionViewLayoutInterface <NSObject>

@property(nonatomic,weak)VZCollectionViewController* controller;

- (CGSize)calculateScrollViewContentSize;
- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* )indexPath;

@optional
- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )identifier AtSectionIndex:(NSInteger) section;
- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )identifier AtSectionIndex:(NSInteger) section;

@end
