//
//  VZListViewDelegate+UIRefreshControl.m
//  VizzleListExample
//
//  Created by moxin on 16/4/4.
//  Copyright © 2016年 VizLab. All rights reserved.
//

#import "VZListViewDelegate+UIRefreshControl.h"
#import <objc/runtime.h>

const void* g_vzlistrefreshcontrol_key = &g_vzlistrefreshcontrol_key;
@implementation VZListViewDelegate (UIRefreshControl)

- (void)setDummyTableViewController:(UITableViewController *)dummyTableViewController{
    objc_setAssociatedObject(self, g_vzlistrefreshcontrol_key, dummyTableViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewController* )dummyTableViewController{
    return objc_getAssociatedObject(self, g_vzlistrefreshcontrol_key);
}

@end
