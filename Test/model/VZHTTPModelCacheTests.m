//
//  VZHTTPModelCacheTests.m
//  VizzleTest
//
//  Created by moxin on 15/7/18.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BXTWTripListItem.h"
#import "BXTWTripListModel.h"

@interface VZHTTPModelCacheTests : XCTestCase<VZModelDelegate>

@property(nonatomic,strong)BXTWTripListModel* model;

@end

@implementation VZHTTPModelCacheTests
{
    XCTestExpectation* _expecation;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.model = [BXTWTripListModel new];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.model=nil;
}

- (void)testDefaultCachePolicy
{

    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyDefault;
//    [self testCacheBehaviorWithLoad:defaultPolicy];
//    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy];
    [self testCacheBehaviorWithLoadMoreWithCompletion:defaultPolicy];
//    [self testCacheBehaviorWithLoadALLWithCompletion:defaultPolicy];
}

- (void)testOnlyReadCachePolicy
{
    
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyOnlyReading;
    [self testCacheBehaviorWithLoad:defaultPolicy];
    [self testCacheBehaviorWithLoad:defaultPolicy];
    [self testCacheBehaviorWithLoadMoreWithCompletion:defaultPolicy];
    [self testCacheBehaviorWithLoadALLWithCompletion:defaultPolicy];
}

- (void)testOnlyWriteCachePolicy
{
    
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyOnlyWriting;
    [self testCacheBehaviorWithLoad:defaultPolicy];
    [self testCacheBehaviorWithLoad:defaultPolicy];
    [self testCacheBehaviorWithLoadMoreWithCompletion:defaultPolicy];
    [self testCacheBehaviorWithLoadALLWithCompletion:defaultPolicy];
}

- (void)testNoneCachePolicy
{
    
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyNone;
    [self testCacheBehaviorWithLoad:defaultPolicy];
    [self testCacheBehaviorWithLoad:defaultPolicy];
    [self testCacheBehaviorWithLoadMoreWithCompletion:defaultPolicy];
    [self testCacheBehaviorWithLoadALLWithCompletion:defaultPolicy];
}



- (void)testCacheBehaviorWithLoad:(VZHTTPNetworkURLCachePolicy)policy
{
    NSLog(@"///////BeginTesting【Load】///////////");
    _expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    [self.model load];
    
    NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:t handler:^(NSError *error) {
       
        if (error) {
             XCTFail(@"\xE2\x9D\x8C[Timeout]");
        }
    }];
    
}

- (void)testCacheBehaviorWithLoadWithCompletion:(VZHTTPNetworkURLCachePolicy)policy
{
    NSLog(@"///////BeginTesting【LoadWithCompletion】///////////");
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    self.model.delegate = nil;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        if (self.model.isResponseObjectFromCache) {
            NSLog(@"\xE2\x9C\x85[Hit Cache]");
        }
        else
        {
            NSLog(@"\xE2\x9C\x85[Requset From Network]");
        }
    }];
    
    NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self delay:t completion:^{
       
        
        
    }];
    
}

/**
 *
 */
- (void)testCacheBehaviorWithLoadALLWithCompletion:(VZHTTPNetworkURLCachePolicy)policy
{
    NSLog(@"///////BeginTesting【LoadAllWithCompletion】///////////");
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    self.model.delegate = nil;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        if (self.model.isResponseObjectFromCache) {
            NSLog(@"\xE2\x9C\x85[Hit Cache]");
            [self.model loadMore];
        }
        else
        {
            NSLog(@"\xE2\x9C\x85[Requset From Network]");
            [self.model loadMore];
        }
    }];
    
    NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self delay:t completion:^{
        
        
        
    }];
    
}

- (void)testCacheBehaviorWithLoadMoreWithCompletion:(VZHTTPNetworkURLCachePolicy)policy
{
     NSLog(@"///////BeginTesting【LoadMoreWithCompletion】///////////");
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    self.model.delegate = nil;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        if (self.model.isResponseObjectFromCache) {
            NSLog(@"\xE2\x9C\x85[Hit Cache]");
            [self.model loadMore];
        }
        else
        {
            NSLog(@"\xE2\x9C\x85[Requset From Network]");
            [self.model loadMore];
        }
    }];
    
    NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self delay:t completion:^{
        
        
        
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
    XCTAssertEqual(model.state, VZModelStateFinished);
    
    if (!model.isResponseObjectFromCache) {
        
        NSLog(@"\xE2\x9C\x85[Request From Network]");
        [_expecation fulfill];
    }
    else
    {
        NSLog(@"\xE2\x9C\x85[Hit Cache]");
    }
  
}

- (void)modelDidFail:(VZModel *)model withError:(NSError *)error
{
    XCTAssertEqual(model.state, VZModelStateError);
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
