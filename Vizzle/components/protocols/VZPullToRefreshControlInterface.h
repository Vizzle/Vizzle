//
//  VZPullToRefreshControlInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VZPullToRefreshControlInterface <NSObject>

@property(nonatomic,assign,readonly) BOOL isRefreshing;
@property(nonatomic,assign,readonly) float progress;
@property(nonatomic,copy) void(^pullRefreshDidTrigger)(void);

@optional
- (void)scrollviewDidScroll:(UIScrollView*)scrollview;
- (void)scrollviewDidEndDragging:(UIScrollView*)scrollview;
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView;

@required
- (void)startRefreshing;
- (void)stopRefreshing;

@end
