//
//  VZListViewDelegate.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZListViewDelegate.h"
#import "VZListViewDataSource.h"
#import "VZCellActionInterface.h"
#import "VZListCell.h"
#import "VZListItem.h"
#import "VZHTTPListModel.h"
#import "VZListViewController.h"
#import "VZPullToRefreshControlInterface.h"
#import "VZPullToRefreshControl.h"
#import "VZListViewDelegate+UIRefreshControl.h"
#import "VZAssert.h"

@interface VZListViewDelegate()<VZCellActionInterface>

@property(nonatomic,strong) VZPullToRefreshControl* pullRefreshView;

@end

@implementation VZListViewDelegate

@synthesize controller      = _controller;
@synthesize pullRefreshView = _pullRefreshView;

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (VZPullToRefreshControl* )pullRefreshView
{
    if (!self.controller.needPullRefresh) {
        return nil;
    }
    
    if (!_pullRefreshView) {
        _pullRefreshView = [[VZPullToRefreshControl alloc]init];
        
        
        //moxi.xt:创建一个假的UITableViewController，解决UIRefreshControl的Bug
        //see:
        /*
         * This initializes a UIRefreshControl with a default height and width.
         * Once assigned to a UITableViewController, the frame of the control is managed automatically.
         * When a user has pulled-to-refresh, the UIRefreshControl fires its UIControlEventValueChanged event.
         *
         */
        VZPullToRefreshControl* refreshControl = (VZPullToRefreshControl* )_pullRefreshView;
        [refreshControl addTarget:refreshControl action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        self.dummyTableViewController = [[UITableViewController alloc]init];
        self.dummyTableViewController.tableView = self.controller.tableView;
        self.dummyTableViewController.refreshControl = refreshControl;
            // _pullRefreshViewInternal.backgroundColor = self.controller.tableView.backgroundColor;
            // 如果设置背景色，位置将会随着下拉改变，否则定在原地
        __weak typeof(self)weakSelf = self;
        _pullRefreshView.pullRefreshDidTrigger = ^(void){
            [weakSelf.controller performSelector:@selector(pullRefreshDidTrigger) withObject:nil];
        };
        
    }
    return _pullRefreshView;
}

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (void)dealloc
{
    
    
    _controller = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (BOOL)isRefreshing
{
    return [self.pullRefreshView isRefreshing];
}


- (void)beginRefreshing
{
    if (self.controller.needPullRefresh) {
        [self.pullRefreshView startRefreshing];
    }
}
- (void)endRefreshing
{
    if (self.controller.needPullRefresh) {
        [self.pullRefreshView stopRefreshing];
    }
    
}



////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - uitableView delegate

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class cls;
    
    if ([tableView.dataSource isKindOfClass:[VZListViewDataSource class]]) {
        
        VZListViewDataSource* dataSource = (VZListViewDataSource*)tableView.dataSource;
        
        VZListItem* item = [dataSource itemForCellAtIndexPath:indexPath];
        
        if (item.itemHeight > 0) {
            return item.itemHeight;
        }
        else
        {
            cls = [dataSource cellClassForItem:item AtIndex:indexPath];
            
            if ([cls isSubclassOfClass:[VZListCell class]]) {
                
                return [cls tableView:tableView variantRowHeightForItem:item AtIndex:indexPath];
            }
            else
                return 44;
        }
    }
    else
        return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfSections = [self.controller.dataSource numberOfSectionsInTableView:tableView];
    if ( indexPath.section == numberOfSections - 1)
    {
        VZListViewDataSource* dataSource = (VZListViewDataSource*)tableView.dataSource;
        NSArray* items = dataSource.itemsForSection[@(indexPath.section)];
        if (indexPath.row  == items.count - 1 )
            [self.controller loadMore];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.controller tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VZListViewController* controller = (VZListViewController*)self.controller;
    
    if (controller.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    else
		return UITableViewCellEditingStyleDelete;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - scrollview's delegate


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    //下拉刷新
    if (self.controller.needPullRefresh && [self.pullRefreshView respondsToSelector:@selector(scrollviewDidEndDragging:)]) {
        [self.pullRefreshView scrollviewDidEndDragging:scrollView];
        
    }
    
    [self.controller scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if (self.controller.needPullRefresh && [self.pullRefreshView respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.pullRefreshView scrollViewDidEndDecelerating:scrollView];
    }
    
    [self.controller scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.controller.needPullRefresh && [self.pullRefreshView respondsToSelector:@selector(scrollviewDidScroll:)]) {
        [self.pullRefreshView scrollviewDidScroll:scrollView];
    }
    
    [self.controller scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.controller scrollViewWillBeginDragging:scrollView];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableview delegate

- (void)onCellComponentClickedAtIndex:(NSIndexPath *)indexPath Bundle:(NSDictionary *)extra
{
    if(extra == nil)
        return [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath];
    
    else
    {
        return [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath component:extra];
    }
}


@end



