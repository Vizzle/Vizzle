//
//  VZCollectionViewDelegate.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VZCollectionViewController;
@protocol VZCollectionCellDelegate;
@interface VZCollectionViewDelegate : NSObject<UICollectionViewDelegate>

@property(nonatomic,weak)VZCollectionViewController* controller;
/**
 *  pull-2-refresh view 处于刷新状态
 */
@property(nonatomic,assign) BOOL isRefreshing;
/**
 *  开始下拉刷新
 */
- (void)beginRefreshing;
/**
 *  结束下拉刷新
 */
- (void)endRefreshing;
@end
