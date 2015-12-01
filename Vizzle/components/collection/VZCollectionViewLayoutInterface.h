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

/**
 *  默认每个cell的Attribute值
 *
 *  @return attribute值
 */
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
/**
 *  layout关联的controller
 */
@property(nonatomic,weak)VZCollectionViewController* controller;
/**
 *  是否需要扩展scrollview的contentsize
 */
@property(nonatomic,assign)BOOL shouldExtendScrollContentSize;

@optional
/**
 *  返回每个cell对应的attribute
 *
 *  @param item      cell对应的item
 *  @param indexPath cell的indexpath
 *
 *  @return attribute值
 */
- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item AtIndexPath:(NSIndexPath* )indexPath;
/**
 *  返回section的headerview对应的attribute
 *
 *  @param identifier section header的复用串
 *  @param section    对应的section
 *
 *  @return attribute值
 */
- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )identifier AtSectionIndex:(NSInteger) section;
/**
 *  返回section的footerview对应的attribute
 *
 *  @param identifier section footer的复用串
 *  @param section    对应的section
 *
 *  @return attribute值
 */
- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )identifier AtSectionIndex:(NSInteger) section;

@end
