//
//  VZHTTPListModel.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPListModel.h"

@interface VZHTTPListModel()

@property(nonatomic,assign) BOOL willLoadMore;

@end

@implementation VZHTTPListModel


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSMutableArray* )objects
{
    if (!_objects) {
        _objects = [NSMutableArray new];
    }
    return _objects;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (void)loadMore
{
    if (self.state == VZModelStateLoading) {
        return;
    }
    
    if (self.hasMore) {
        self.currentPageIndex += 1;
        [self loadInternal];
    }
}

- (void)loadMoreWithCompletion:(VZModelCallback)callBack
{
    if (self.hasMore) {
        self.currentPageIndex +=1;
        self.willLoadMore = YES;
        __weak typeof(self)weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadWithCompletion:^(VZModel *model, NSError *error) {
                weakSelf.willLoadMore = NO;
                if (callBack) {
                    callBack(weakSelf,error);
                }
                
            }];
        });

    }
    else
    {
        self.willLoadMore = NO;
    }
}

- (void)load
{
    if (self.needLoadAll) {
        [self loadAll];
    }
    else
        [super load];
}

- (void)loadAll
{
    [self loadAllWithCompletion:^(VZModel *model, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(modelDidFinish:)]) {
                [self.delegate modelDidFinish:self];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(modelDidFail:withError:)]) {
                [self.delegate modelDidFail:self withError:error];
            }
        }
    }];
}

- (void)loadAllWithCompletion:(VZModelCallback)aCallback
{
    __weak typeof(self) weakSelf = self;
    [self loadWithCompletion:^(VZModel *model, NSError *error) {
       
        if (error) {
            weakSelf.willLoadMore = NO;
            if (aCallback) {
                aCallback(weakSelf,error);
            }
        }
        else
        {
            if(weakSelf.hasMore)
            {
                weakSelf.willLoadMore = YES;
                weakSelf.currentPageIndex += 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf loadAllWithCompletion:aCallback];
                });
            }
            else
            {
                weakSelf.willLoadMore = NO;
                if (aCallback)
                {
                    aCallback(model,error);
                }
            }
        }
    }];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZModel

- (void)reset
{
    [super reset];
    
    if (!_willLoadMore) {
        
        self.currentPageIndex = 0;
        [self.objects removeAllObjects];
    
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZHTTPModel


- (BOOL)parseResponse:(id)response
{
    if (![super parseResponse:response]) {
        return NO;
    }
    else
    {
        NSArray* list = [self responseObjects:response];
   
        if (self.pageMode == VZPageModePageDefault) {
            _hasMore = list.count > 0;
        }
        else if (self.pageMode == VZPageModePageReturnCount){
            _hasMore = list.count == self.pageSize;
        }
        else if(self.pageMode == VZPageModePageCustomize){
            
            NSInteger currentCount = self.objects.count + list.count;
            if (currentCount < self.totalCount) {
                _hasMore = YES;
            }
            else
                _hasMore = NO;
        }
        else
            _hasMore = NO;
        
        if (list.count > 0) {
            [self.objects addObjectsFromArray:list];
            
        }
        return YES;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - protocol methods

- (NSMutableArray* )responseObjects:(id)response
{
    return nil;
}


@end
