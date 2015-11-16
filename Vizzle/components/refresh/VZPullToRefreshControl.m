//
//  VZPullToRefreshController.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZPullToRefreshControl.h"

@implementation VZPullToRefreshControl

@synthesize progress     = _progress;
@synthesize pullRefreshDidTrigger = _pullRefreshDidTrigger;
// Make sure to be called in every init method
- (void)initialize {
    self.tintColor = [UIColor grayColor];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview{
    
    if (self.isRefreshing) {
        if (self.pullRefreshDidTrigger) {
            self.pullRefreshDidTrigger();
        }
    }
}

- (void)scrollviewDidScroll:(UIScrollView *)scrollview
{
    CGFloat visibleHeight = MAX ( -scrollview.contentOffset.y - scrollview.contentInset.top, 0 );
    _progress = MIN(MAX(visibleHeight/80, 0.0f),1.0f);
}

- (void)startRefreshing
{
    [self beginRefreshing];
}

- (void)stopRefreshing
{
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.1];
}

@end