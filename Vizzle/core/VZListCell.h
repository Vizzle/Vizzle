//
//  VZListCell.h
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZCellActionInterface.h"

@class VZItem;
@interface VZListCell : UITableViewCell

/**
 *  cell的index
 */
@property (nonatomic,strong) NSIndexPath* indexPath;
/**
 *  cell绑定的item数据
 */
@property (nonatomic,strong) VZItem* item;
/**
 *  cell的delegate
 */
@property (nonatomic,weak) id<VZCellActionInterface> delegate;

/**
 *  cell高度计算
 *
 *  @param tableView cell所在tableview
 *  @param item      cell对应的数据源
 *  @param indexPath cell的index
 *
 *  @return 高度值
 *  @important 这个方法在UI线程回调，如果需要很复杂的计算，请使用item.itemHeight字段。
 */
+ (CGFloat)tableView:(UITableView*)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath*)indexPath;

@end
