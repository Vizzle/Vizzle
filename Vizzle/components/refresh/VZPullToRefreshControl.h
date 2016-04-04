//
//  VZPullToRefreshController.h
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZPullToRefreshControlInterface.h"


@interface VZPullToRefreshControl : UIRefreshControl<VZPullToRefreshControlInterface>

- (void)refresh;

@end
