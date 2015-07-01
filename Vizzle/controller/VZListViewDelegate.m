//
//  VZListViewDelegate.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZListViewDelegate.h"
#import "VZListViewDataSource.h"
#import "VZListCell.h"
#import "VZListItem.h"
#import "VZHTTPListModel.h"
#import "VZListViewController.h"


@interface VZListDefaultPullRefreshView : UIView<VZListPullToRefreshViewDelegate>

@property(nonatomic,assign) BOOL bRefreshing;
@property(nonatomic,assign) float progress;
@end

@interface VZListRefreshControl : UIRefreshControl<VZListPullToRefreshViewDelegate>
@end

@interface VZListViewDelegate()
@property(nonatomic,strong) VZListRefreshControl* pullRefreshViewInternal;
@end


@implementation VZListViewDelegate

@synthesize controller      = _controller;
@synthesize pullRefreshView = _pullRefreshView;

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setPullRefreshView:(id<VZListPullToRefreshViewDelegate>)pullRefreshView
{
    _pullRefreshView = pullRefreshView;
    [self.controller.tableView addSubview:(UIView*)_pullRefreshView];
}



///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (VZListRefreshControl*)pullRefreshViewInternal
{
    if (!_pullRefreshViewInternal) {
        _pullRefreshViewInternal=  [[VZListRefreshControl alloc]init];
        // 如果设置背景色，位置将会随着下拉改变，否则定在原地
//        _pullRefreshViewInternal.backgroundColor = self.controller.tableView.backgroundColor;
        
        __weak typeof(self)weakSelf = self;
        _pullRefreshViewInternal.pullRefreshDidTrigger = ^(void){
            [weakSelf.controller performSelector:@selector(pullRefreshDidTrigger) withObject:nil];
        };
        [self.controller.tableView addSubview:_pullRefreshViewInternal];
        
    }
    return _pullRefreshViewInternal;
}

- (id<VZListPullToRefreshViewDelegate>)pullRefreshView
{
    if (_pullRefreshView) {
        return _pullRefreshView;
    }
    else
        return self.pullRefreshViewInternal;
}

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _controller = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

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

#define kRefreshViewHeight          44

typedef NS_ENUM(NSInteger, PullRefreshState)
{
    kIsIdle    = 0,
    kIsPulling,
    kIsLoading
};

@implementation  VZListDefaultPullRefreshView
{
    PullRefreshState _state;
    UIActivityIndicatorView* _indicator;
    UILabel* _textLabel;
}

@synthesize pullRefreshDidTrigger = _pullRefreshDidTrigger;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _state = kIsIdle;
        
        int w = frame.size.width;
        int h = frame.size.height;
        
        int orix = (w-100)/2;
        
        _textLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(orix, 15, 100, 14)];
        _textLabel.font            = [UIFont systemFontOfSize:14.0f];
        _textLabel.textAlignment   = NSTextAlignmentCenter;
        _textLabel.textColor       = [UIColor lightGrayColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text            = @"下拉刷新";
        [self addSubview:_textLabel];
        
        
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(orix - 30, (h-20)/2, 20, 20)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicator.hidden = YES;
        [self addSubview:_indicator];
        
    }
    return self;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollviewDidScroll:(UIScrollView *)scrollview
{
    //fix section header problem
    if(self.bRefreshing)
    {
        if( scrollview.contentOffset.y >= 0 )
            scrollview.contentInset = UIEdgeInsetsZero;
        else
            scrollview.contentInset = UIEdgeInsetsMake( MIN( -scrollview.contentOffset.y, kRefreshViewHeight ), 0, 0, 0 );
    }
    else
    {
        CGFloat visibleHeight = MAX ( -scrollview.contentOffset.y - scrollview.contentInset.top, 0 );
        self.progress = MIN(MAX(visibleHeight/44, 0.0f),1.0f);
        
        if(self.progress >= 1.0)
        {
            _textLabel.text = @"松开刷新";
        }
        else
        {
            _textLabel.text = @"下拉刷新";
        }
    }
    

}

- (void)scrollviewDidEndDragging:(UIScrollView *)scrollview
{
    if (self.progress >= 1.0) {
        
        if (!self.bRefreshing) {
            
            [self startRefreshing];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //通知controller
    
                if (self.pullRefreshDidTrigger) {
                    self.pullRefreshDidTrigger();
                }
                
            });
        }
        else
        {
      
        }
        
        
    }
    else
    {
        //noop..
    }

}

- (void)startRefreshing
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (!self.bRefreshing) {
        
        _bRefreshing = YES;
        _textLabel.text = @"努力加载中";
        [_indicator startAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            
            UIEdgeInsets inset = scrollView.contentInset;
            inset.top = 44;
            scrollView.contentInset = inset;
            
        } completion:^(BOOL finished) {
            
            [self startAnimation];
        }];
        
    }
}

- (void)stopRefreshing
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (self.bRefreshing)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            UIEdgeInsets inset = scrollView.contentInset;
            inset.top = 0;
            scrollView.contentInset = inset;
            
        } completion:^(BOOL finished) {
            
            [self stopAnimation];
            _bRefreshing = NO;
            _textLabel.text = @"下拉刷新";
            [_indicator stopAnimating];
            
        }];
        
    }
    else
    {
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top = 0;
        scrollView.contentInset = inset;
    }
}

- (void)startAnimation
{

}

- (void)stopAnimation
{
}


@end


@implementation VZListRefreshControl

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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    
    if (self.isRefreshing)
    {
        if (self.pullRefreshDidTrigger) {
            self.pullRefreshDidTrigger();
        }
    }
}

- (void)startRefreshing {
    [self beginRefreshing];
}

- (void)stopRefreshing {
    [self endRefreshing];
}

@end