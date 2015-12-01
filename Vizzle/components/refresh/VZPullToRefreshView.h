//
//  VZPullToRefreshView.h
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZPullToRefreshControlInterface.h"

#define kVZPullToRefreshViewHeight          44

typedef NS_ENUM(NSInteger, VZPullToRefreshViewState)
{
    kIsIdle    = 0,
    kIsPulling,
    kIsLoading
};


@interface VZPullToRefreshView : UIView<VZPullToRefreshControlInterface>

@end
