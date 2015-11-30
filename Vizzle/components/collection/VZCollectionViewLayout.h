//
//  VZCollectionViewLayout.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZCollectionViewLayoutInterface.h"



@class VZCollectionItem;
@class VZCollectionViewController;
@interface VZCollectionViewLayout : UICollectionViewLayout<VZCollectionViewLayoutInterface>

/**
 *  计算scrollview的contentsize
 *
 *  @discuss:继承VZCollectionViewFlowLayout的子类无需override这个方法
 *  @return contentsize值
 */
- (CGSize)calculateScrollViewContentSize;

@end

