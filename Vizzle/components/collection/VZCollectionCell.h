//
//  VZCollectionCell.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VZCollectionCellDelegate<NSObject>

@optional
- (void)onCellComponentClickedAtIndex:(NSIndexPath*)indexPath Bundle:(NSDictionary*)extra;

@end

@class VZCollectionItem;
@interface VZCollectionCell : UICollectionViewCell

@property(nonatomic,strong)NSIndexPath* indexPath;
@property(nonatomic,strong)VZCollectionItem* item;
@property(nonatomic,weak) id<VZCollectionCellDelegate> delegate;


@end
