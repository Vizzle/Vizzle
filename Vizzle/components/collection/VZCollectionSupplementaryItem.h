//
//  VZCollectionSupplementaryItem.h
//  VizzleListExample
//
//  Created by moxin on 15/11/29.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionItem.h"

@interface VZCollectionSupplementaryItem : VZCollectionItem

/**
 *  UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
 */
@property(nonatomic,strong)NSString* type;
/**
 *  supplementaryView的reuseidentifier
 */
@property(nonatomic,strong)NSString* reuseIdentifier;
/**
 *  配置SupplementaryView的代码
 */
@property(nonatomic,copy)void(^viewConfigurationBlock)(UICollectionReusableView* view, id data);

@end
