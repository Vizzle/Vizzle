//
//  VZCollectionViewLayout.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZCollectionViewLayoutInterface.h"

typedef struct
{
    CGRect frame;
    CATransform3D transform3D;
    CGAffineTransform tranform2D;
    CGFloat alpha;
    NSInteger zIndex;
    
}VZCollectionLayoutAttributes;

@class VZCollectionItem;
@class VZCollectionViewController;
@interface VZCollectionViewLayout : UICollectionViewLayout<VZCollectionViewLayoutInterface>

@end

@interface VZCollectionViewLayout(attributes)

- (VZCollectionLayoutAttributes) layoutAttributesForCellWithItem:(VZCollectionItem* )item;


//todo:没想好，这个方法该怎么抽象
- (VZCollectionLayoutAttributes) layoutAttributesForHeaderView:(NSString* )kind AtSectionIndex:(NSInteger) section;
- (VZCollectionLayoutAttributes) layoutAttributesForFooterView:(NSString* )kind AtSectionIndex:(NSInteger) section;

@end