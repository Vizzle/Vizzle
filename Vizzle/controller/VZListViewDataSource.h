//
//  VZListViewDataSource.h
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VZHTTPListModel,VZListViewController,VZListItem;

@protocol VZListViewDataSource<UITableViewDataSource>

@required
/**
 * 指定cell的类型
 */
- (Class)cellClassForItem:(VZListItem*)item AtIndex:(NSIndexPath *)indexPath;
/**
 *指定返回的item
 */
- (VZListItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath;
/**
 *绑定items和model
 */
- (void)tableViewControllerDidLoadModel:(VZHTTPListModel*)model ForSection:(NSInteger)section;

@end

@interface VZListViewDataSource : NSObject<VZListViewDataSource>
/**
 * remote controller
 */
@property(nonatomic,weak)  VZListViewController*  controller;
/**
 * <k:NSArray v:section>
 * section到列表数据的映射
 */
@property(nonatomic,strong)  NSDictionary* itemsForSection;

/**
 *  在datasource中插入item
 *
 *  @param item      待插入的item
 *  @param indexPath 位置
 *
 *  @return 操作是否成功
 */
- (BOOL)insertItem:(VZListItem* )item AtIndexPath:(NSIndexPath* )indexPath;

/**
 *  替换datasource中的item
 *
 *  @param item      待替换的item
 *  @param indexPath item所在indexPath
 *
 *  @return 是否替换成功
 */
- (BOOL)replaceItem:(VZListItem* )item AtIndexPath:(NSIndexPath* )indexPath;
/**
 *  更新某个section的数据
 *
 *  @param items 待更新的数据列表
 *  @param n     section
 *
 *  @return 操作是否成功
 */
- (BOOL)setItems:(NSArray*)items ForSection:(NSInteger)n; //增

/**
 *  返回某个section对应的items
 *
 *  @param section 数据对应的section
 *
 *  @return 该section的所有item
 */
- (NSArray *)itemsForSection:(NSInteger)section;

/**
 *  根据indexpath删除某条数据
 *
 *  @param indexPath 待删除item的indexpath
 *
 *  @return 操作是否成功
 */
- (BOOL)removeItemAtIndexPath:(NSIndexPath* )indexPath;
/**
 *  删除某个section中的数据
 *
 *  @param n section
 *
 *  @return 操作是否成功
 */
- (BOOL)removeItemsForSection:(NSInteger)n;
/**
 *  清除datasource所有数据
 */
- (void)removeAllItems;

@end
