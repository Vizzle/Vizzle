//
//  VZPullToRefreshView.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZPullToRefreshView.h"

@implementation  VZPullToRefreshView
{
    VZPullToRefreshViewState _state;
    UIActivityIndicatorView* _indicator;
    UILabel* _textLabel;
}

@synthesize isRefreshing = _isRefreshing;
@synthesize progress     = _progress;
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
        _textLabel.text            = @"Pull to Refresh";
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
    if(self.isRefreshing)
    {
        if( scrollview.contentOffset.y >= 0 )
            scrollview.contentInset = UIEdgeInsetsZero;
        else
            scrollview.contentInset = UIEdgeInsetsMake( MIN( -scrollview.contentOffset.y, kVZPullToRefreshViewHeight ), 0, 0, 0 );
    }
    else
    {
        CGFloat visibleHeight = MAX ( -scrollview.contentOffset.y - scrollview.contentInset.top, 0 );
        _progress = MIN(MAX(visibleHeight/44, 0.0f),1.0f);
        
        if(self.progress >= 1.0)
        {
            _textLabel.text = @"Release to refresh";
        }
        else
        {
            _textLabel.text = @"Pull to refresh";
        }
    }
    
    
}

- (void)scrollviewDidEndDragging:(UIScrollView *)scrollview
{
    if (self.progress >= 1.0) {
        
        if (!self.isRefreshing) {
            
            [self startRefreshing];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //通知controller
                self->_isRefreshing = YES;
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
    if (self.isRefreshing) {
        return;
    }
    
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    _isRefreshing = YES;
    _textLabel.text = @"loading...";
    [_indicator startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top = 44;
        scrollView.contentInset = inset;
        
    } completion:^(BOOL finished) {
        
        [self startAnimation];
    }];
}

- (void)stopRefreshing
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (self.isRefreshing)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            UIEdgeInsets inset = scrollView.contentInset;
            inset.top = 0;
            scrollView.contentInset = inset;
            
        } completion:^(BOOL finished) {
            
            [self stopAnimation];
            self->_isRefreshing = NO;
            self->_textLabel.text = @"Pull to refresh";
            [self->_indicator stopAnimating];
            
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

