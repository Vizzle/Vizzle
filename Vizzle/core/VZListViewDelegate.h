//
//  VZListViewDelegate.h
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VZListViewController;
@class VZPullToRefreshControl;
@protocol VZListViewDelegate <UITableViewDelegate>
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
 *  开始下拉刷新
 */
- (void)beginRefreshing;
/**
 *  结束下拉刷新
 */
- (void)endRefreshing;


@end
