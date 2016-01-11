//
//  VZHTTPModelCacheTimeTests.m
//  VizzleTest
//
//  Created by moxin on 15/7/19.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BXTWTripListModel.h"

@interface VZHTTPModelCacheTimeTests : XCTestCase

@property(nonatomic,strong)BXTWTripListModel* model;
@property(nonatomic,strong)XCTestExpectation* expecation;

@end

@implementation VZHTTPModelCacheTimeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.model = [BXTWTripListModel new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _model = nil;
}

/**
 *  30s过期时间未到
 */
- (void)testCacheTimeUnexpired
{
    VZHTTPNetworkURLCacheTime t = VZHTTPNetworkURLCacheTime30Sec;
    self.expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.cachePolicy = VZHTTPNetworkURLCachePolicyDefault;
    self.model.cacheTime = t;
    self.model.delegate = nil;
    
    __weak typeof(self) weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        [weakSelf delay:0.5 * t completion:^{
            
            [weakSelf.model loadWithCompletion:^(VZModel *model, NSError *error) {
                
                VZHTTPModel* httpModel = (VZHTTPModel* )model;
                XCTAssertEqual(httpModel.isResponseObjectFromCache, YES);
                [weakSelf.expecation fulfill];
                
            }];
            
        }];
//
    }];
    
    [self waitForExpectationsWithTimeout:t*2 handler:nil];
}

/**
 *  超过30s过期时间
 */
- (void)testCacheTimeExpired
{
    VZHTTPNetworkURLCacheTime time = VZHTTPNetworkURLCacheTime30Sec;
    self.expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.cachePolicy = VZHTTPNetworkURLCachePolicyDefault;
    self.model.cacheTime = time;
    self.model.delegate = nil;
    
    __weak typeof(self) weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
       
        [weakSelf delay:time completion:^{
            
            [weakSelf.model loadWithCompletion:^(VZModel *model, NSError *error) {
                
                VZHTTPModel* httpModel = (VZHTTPModel* )model;
                XCTAssertEqual(httpModel.isResponseObjectFromCache, NO);
                [weakSelf.expecation fulfill];
                
            }];
            
            
        }];
        
    }];
    [self waitForExpectationsWithTimeout:time*3 handler:nil];
    
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
