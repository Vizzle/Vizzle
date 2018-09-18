//
//  VZHTTPListModelAPITests.m
//  VizzleTest
//
//  Created by moxin on 15/7/17.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BXTWTripListModel.h"
#import "BXTWTripListItem.h"


@interface VZHTTPListModelAPITests : XCTestCase<VZModelDelegate>

@property(nonatomic,strong)BXTWTripListModel* model;

@end

@implementation VZHTTPListModelAPITests
{
    XCTestExpectation* _expecation;
}

- (void)setUp {
    [super setUp];
    
    self.model = [BXTWTripListModel new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.model = nil;
    _expecation = nil;
}

- (void)testLoadMore
{
    _expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    self.model.key = NSStringFromSelector(_cmd);
    [self.model load];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

- (void)testLoadMoreWithCompletion
{
    _expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate=nil;
    
    __weak typeof(self)weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        if (!error) {
            [weakSelf.model loadMoreWithCompletion:^(VZModel *model1, NSError *error1) {
               
                if (error1) {
                    
                }
                else
                {
                    XCTAssertEqual(weakSelf.model.currentPageIndex, 1);
                
                }
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf ->_expecation fulfill];
                }

                
            }];
        }

    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

- (void)testLoadAll
{
    _expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    self.model.key = NSStringFromSelector(_cmd);
    [self.model loadAll];
    NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:t handler:^(NSError *error) {
        if (error) {
            XCTFail(@"\xE2\x9D\x8C[Timeout]");
        }
        else
        {
            
        }
    }];
}

- (void)testLoadAllWithCompletion
{
    _expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate=nil;
    
    __weak typeof(self)weakSelf = self;
    [self.model loadAllWithCompletion:^(VZModel *model, NSError *error) {
        
        if (model.error) {
            XCTAssertEqual(model.state, VZModelStateError);
        }
        else
        {
            XCTAssertEqual(model.state, VZModelStateFinished);
            XCTAssertEqual(((VZHTTPListModel*)model).hasMore, NO);
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf ->_expecation fulfill];
        }
    }];
    //NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
       
        
    }];

}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - callback


- (void)modelDidStart:(VZModel *)model
{
    XCTAssertEqual(model.state, VZModelStateLoading);
}

- (void)modelDidFinish:(VZHTTPListModel *)model
{
    if ([model.key isEqualToString:@"testLoadMore"]) {
        
        if (model.currentPageIndex == 0) {
             [model loadMore];
        }
        else
        {
            XCTAssertEqual(model.currentPageIndex, 1);
            [_expecation fulfill];
        }
    }
    if ([model.key isEqualToString:@"testLoadAll"]) {
        
        XCTAssertEqual(model.hasMore, NO);
        [_expecation fulfill];
        
    }

}

- (void)modelDidFail:(VZModel *)model withError:(NSError *)error
{
    XCTAssertEqual(model.state, VZModelStateError);
    [_expecation fulfill];
}

- (void)modelDidCancel:(VZModel *)model
{
    XCTAssertEqual(model.state, VZModelStateReady);
    [_expecation fulfill];
}
////////////////////////////////////////////////////////////////////////////////
#pragma mark - tool

- (void)delay:(NSTimeInterval)t completion:(void(^)(void))block
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:t];
    while ([date timeIntervalSinceNow] > 0) {
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];
    }
    if (block) {
        block();
    }
}

@end
