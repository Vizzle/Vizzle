//
//  VZHTTPListModel.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPListModel.h"

@interface VZHTTPListModel()

@property(nonatomic,copy) VZModelCallback requestCallbackInternal;

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
    if (self.hasMore) {
        self.currentPageIndex += 1;
        [self loadInternal];
    }
}



- (void)loadAllWithCompletion:(VZModelCallback)aCallback
{
    __weak typeof(self) weakSelf = self;
    [self loadWithCompletion:^(VZModel *model, NSError *error) {
       
        VZHTTPListModel* listModel = (VZHTTPListModel* )model;
        
        if(listModel.hasMore)
        {
            [listModel loadMore];
        }
        else
        {
            if (aCallback)
            {
                aCallback(model,error);
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf -> _requestCallbackInternal = nil;
            }
        }
        
  
    }];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZModel

- (void)reset
{
    self.currentPageIndex = 0;
    [self.objects removeAllObjects];
    [super reset];
}

- (void)didFinishLoading
{
    [super didFinishLoading];
    
    if (_requestCallbackInternal) {
        _requestCallbackInternal(self,nil);
       // _requestCallbackInternal = nil;
    }
}

- (void)didFailWithError:(NSError *)error
{
    [super didFailWithError:error];
    
    if (_requestCallbackInternal) {
        _requestCallbackInternal(self,error);
        _requestCallbackInternal = nil;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZHTTPModel


- (void)loadWithCompletion:(VZModelCallback)aCallback
{
    if (aCallback) {
        _requestCallbackInternal = aCallback;
    }
    [self loadInternal];
}


- (BOOL)parseResponse:(id)JSON
{
    if (![super parseResponse:JSON]) {
        return NO;
    }
    else
    {
        NSArray* list = [self responseObjects:JSON];
   
        if (self.pageMode == VZPageModePageDefault) {
            _hasMore = list.count > 0;
            
        }
        else if (self.pageMode == VZPageModePageReturnCount){
            _hasMore = list.count == self.pageSize;
        }
        else{
            _hasMore = self.pageSize*self.currentPageIndex < self.totalCount;
        }
        
        if (list.count > 0) {
            [self.objects addObjectsFromArray:list];
            
        }
        return YES;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - protocol methods

- (NSMutableArray* )responseObjects:(id)JSON
{
    return nil;
}


@end
