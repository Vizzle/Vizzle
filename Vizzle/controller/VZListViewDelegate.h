//
//  VZListViewDelegate.h
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VZListViewController;
@protocol VZListViewDelegate <UITableViewDelegate>
@end

/**
 *  第三方下拉刷新需要实现下面接口
 */
@protocol VZListPullToRefreshViewDelegate <NSObject>

@property(nonatomic,assign,readonly) BOOL isRefreshing;
@property(nonatomic,copy) void(^pullRefreshDidTrigger)(void);

@optional
- (void)scrollviewDidScroll:(UIScrollView*)scrollview;
- (void)scrollviewDidEndDragging:(UIScrollView*)scrollview;
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView;

@required
- (void)startRefreshing;
- (void)stopRefreshing;
@end


@interface VZListViewDelegate : NSObject<VZListViewDelegate>

/**
 *  pull-2-refresh view 处于刷新状态
 */
@property(nonatomic,assign) BOOL isRefreshing;
/**
 *  对controller的弱引用
 */
@property (nonatomic, weak) VZListViewController* controller;
/**
 * 支持设置自定义pull-2-refresh view
 */
@property(nonatomic,strong) id<VZListPullToRefreshViewDelegate> pullRefreshView;
/**
 *  开始下拉刷新
 */
- (void)beginRefreshing;
/**
 *  结束下拉刷新
 */
- (void)endRefreshing;


@end
