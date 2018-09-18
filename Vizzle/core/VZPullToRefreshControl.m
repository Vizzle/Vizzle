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


- (void)refresh{

    if (self.pullRefreshDidTrigger) {
        self.pullRefreshDidTrigger();
    }
}


- (void)startRefreshing
{
    [self beginRefreshing];
}

- (void)stopRefreshing
{
    [self endRefreshing];
}

- (void)scrollviewDidScroll:(UIScrollView *)scrollview{
    
}


@end
