//
//  VZCollectionViewDataSource.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZCollectionViewController;
@class VZCollectionItem;
@class VZHTTPListModel;

@protocol VZCollectionViewDataSource <UICollectionViewDataSource>

/*
 * 指定cell的类型
 */
- (Class)cellClassForItem:(VZCollectionItem*)item AtIndex:(NSIndexPath *)indexPath;
/**
 指定返回的item
 */
- (VZCollectionItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath;
/**
 绑定items和model
 */
- (void)collectionViewControllerDidLoadModel:(VZHTTPListModel*)model;

@end

@interface VZCollectionViewDataSource : NSObject<VZCollectionViewDataSource>

/**
 * remote controller
 */
@property(nonatomic,weak)  VZCollectionViewController*  controller;
/**
 * <k:NSArray v:section>
 * section到列表数据的映射
 */
@property(nonatomic,strong, readonly)  NSDictionary* itemsForSection;

#pragma mark - sections

/**
 *  更新某个section的数据
 *
 *  @param items 待更新的数据列表
 *  @param n     section
 *
 *  @return 操作是否成功
 */
- (BOOL)setItems:(NSArray<__kindof VZCollectionItem* > *)items ForSection:(NSInteger)n; //增

/**
 *  返回某个section对应的items
 *
 *  @param section 数据对应的section
 *
 *  @return 该section的所有item
 */
- (NSArray<__kindof VZCollectionItem* > *)itemsForSection:(NSInteger)section;
/**
 *  向datasource中插入一个section数据
 *
 *  @param sectionIndex：插入的section位置，sectionIndex >= 0 && sectionIndex < numberOfSections
 *  @param items
 *
 *  @return 操作是否成功
 */
- (BOOL)insertSectionAtIndex:(NSInteger)sectionIndex withItems:(NSArray<__kindof VZCollectionItem* > *)items;
/**
 *  删除某个section数据
 *
 *  @param sectionIndex：sectionIndex >= 0 && sectionIndex < numberOfSections
 *
 *  @return 操作是否成功
 */
- (BOOL)removeSectionByIndex:(NSInteger)section;

#pragma mark - items
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
