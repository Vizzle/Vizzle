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

@interface VZHTTPModelCachePolicyTests : XCTestCase<VZModelDelegate>

@property(nonatomic,strong)BXTWTripListModel* model;
@property(nonatomic,strong)XCTestExpectation* expecation;

@end

@implementation VZHTTPModelCachePolicyTests{}

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

/**
 *  测试load，reload, loadmore，loadAll 几种情况下的cache机制。
 */
- (void)testDefaultCachePolicy
{
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyDefault;
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadmore:defaultPolicy];
    [self testCacheBehaviorWithLoadmoreWithCompletion:defaultPolicy];
}

/**
 *  测试load，reload, loadmore，loadAll 几种情况下的cache机制。
 */
- (void)testOnlyReadCachePolicy
{
    
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyOnlyReading;
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadmore:defaultPolicy];
    [self testCacheBehaviorWithLoadmoreWithCompletion:defaultPolicy];
}

/**
 *  测试load，reload, loadmore，loadAll 几种情况下的cache机制。
 */
- (void)testOnlyWriteCachePolicy
{
    
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyOnlyWriting;
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadmore:defaultPolicy];
    [self testCacheBehaviorWithLoadmoreWithCompletion:defaultPolicy];
    [self testCacheBehaviorWithLoadmore:defaultPolicy];
    [self testCacheBehaviorWithLoadmoreWithCompletion:defaultPolicy];
}

/**
 *  测试load，reload, loadmore，loadAll 几种情况下的cache机制。
 */
- (void)testNoneCachePolicy
{
    
    VZHTTPNetworkURLCachePolicy defaultPolicy = VZHTTPNetworkURLCachePolicyNone;
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoad:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:false];
    [self testCacheBehaviorWithLoadWithCompletion:defaultPolicy isReload:true];
    [self testCacheBehaviorWithLoadmore:defaultPolicy];
    [self testCacheBehaviorWithLoadmoreWithCompletion:defaultPolicy];
}



- (void)testCacheBehaviorWithLoad:(VZHTTPNetworkURLCachePolicy)policy isReload:(BOOL)b
{

    _expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    
    if (b)
    {
        NSLog(@"///////BeginTesting【reLoad】///////////");
        [self.model reload];
    }
    else
    {
        NSLog(@"///////BeginTesting【Load】///////////");
        [self.model load];
    }
    
    NSTimeInterval t = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:t handler:^(NSError *error) {
       
        if (error) {
             XCTFail(@"\xE2\x9D\x8C[Timeout]");
        }
    }];
    
}


- (void)testCacheBehaviorWithLoadWithCompletion:(VZHTTPNetworkURLCachePolicy)policy isReload:(BOOL)b
{
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    self.model.delegate = nil;
    
    SEL selecotr=NULL;
    if (!b) {
        
        self.expecation = [self expectationWithDescription: [NSStringFromSelector(_cmd) stringByAppendingString:@":load"]];
        
        NSLog(@"///////BeginTesting【loadWithCompletion】///////////");
        selecotr = NSSelectorFromString(@"loadWithCompletion:");
    }
    else
    {
        self.expecation = [self expectationWithDescription: [NSStringFromSelector(_cmd) stringByAppendingString:@":reload"]];
        
        NSLog(@"///////BeginTesting【reloadWithCompletion】///////////");
        selecotr = NSSelectorFromString(@"reloadWithCompletion:");
    }
    
    
    __weak typeof(self)weakSelf = self;
    void(^block)(VZModel*,NSError*) = ^(VZModel* model, NSError* error)
    {
        if (weakSelf.model.isResponseObjectFromCache) {
            NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
        }
        else
        {
            NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
        }
        [weakSelf.expecation fulfill];
    
    };
    [weakSelf.model performSelector:selecotr withObject:block];
    [self waitForExpectationsWithTimeout:self.model.requestConfig.requestTimeoutSeconds handler:nil];
}


- (void)testCacheBehaviorWithLoadmore:(VZHTTPNetworkURLCachePolicy)policy
{
    NSLog(@"///////BeginTesting【testCacheBehaviorWithLoadmore】///////////");
    self.expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    self.model.key = NSStringFromSelector(_cmd);
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    [self.model load];
    [self waitForExpectationsWithTimeout:self.model.requestConfig.requestTimeoutSeconds handler:nil];

}

- (void)testCacheBehaviorWithLoadmoreWithCompletion:(VZHTTPNetworkURLCachePolicy)policy
{
    NSLog(@"///////BeginTesting【testCacheBehaviorWithLoadmoreWithCompletion】///////////");
    self.expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.model.key = NSStringFromSelector(_cmd);
    self.model.cachePolicy = policy;
    self.model.cacheTime = 0;
    
    __weak typeof(self) weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
       
        if (weakSelf.model.isResponseObjectFromCache) {
            
            NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
           
            if (weakSelf.model.cachePolicy == VZHTTPNetworkURLCachePolicyOnlyReading) {
                [weakSelf.model loadMoreWithCompletion:^(VZModel *model, NSError *error) {
                    
                    if (weakSelf.model.isResponseObjectFromCache) {
                        NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
                    }
                    else
                        NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
                    
                    [weakSelf.expecation fulfill];
                    
                }];
            }
            else
            {
                //this should fail
                XCTAssertEqual([self.model loadMoreWithCompletion:nil], NO);
                
                [weakSelf.model reloadWithCompletion:^(VZModel *model, NSError *error) {
                   
                    if (weakSelf.model.isResponseObjectFromCache) {
                        NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
                    }
                    else
                        NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
                    
                    [weakSelf.model loadMoreWithCompletion:^(VZModel *model, NSError *error) {
                       
                        if (weakSelf.model.isResponseObjectFromCache) {
                            NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
                        }
                        else
                            NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
                        
                        [weakSelf.expecation fulfill];
                    }];
                }];
            }
        }
        else
        {
            NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
            
            [weakSelf.model reloadWithCompletion:^(VZModel *model, NSError *error) {
                
                if (weakSelf.model.isResponseObjectFromCache) {
                    NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
                }
                else
                    NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
                
                
                [weakSelf.model loadMoreWithCompletion:^(VZModel *model, NSError *error) {
                    
                    if (weakSelf.model.isResponseObjectFromCache) {
                        NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
                    }
                    else
                        NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
                    
                    
                    [weakSelf.expecation fulfill];
                }];
            }];
        }
        
    }];
    
    [self waitForExpectationsWithTimeout:self.model.requestConfig.requestTimeoutSeconds handler:nil];
    
}

- (void)testCacheBehaviorWithLoadAll:(VZHTTPNetworkURLCachePolicy)policy
{
    
    
}

- (void)testCacheBehaviorWithLoadAllWithCompletion:(VZHTTPNetworkURLCachePolicy)policy
{
    
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - callback


- (void)modelDidStart:(VZModel *)model
{
}

- (void)modelDidFinish:(VZHTTPListModel *)model
{
    if ([model.key isEqualToString:@"testCacheBehaviorWithLoadmore:"]) {
        
        if (model.isResponseObjectFromCache) {
            
            NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
            
            if (self.model.cachePolicy == VZHTTPNetworkURLCachePolicyOnlyReading) {
               
                [self.model loadMore];
                
                //翻页到停止
                if (!self.model.hasMore) {
                    [self.expecation fulfill];
                }
            }
            else
            {
                //this should fail
                XCTAssertEqual([self.model loadMore], NO);
                [self.model reload];
            }
            
        }
        else
        {
            NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
            [self.model loadMore];
            
            //翻页到停止
            if (!self.model.hasMore) {
                [self.expecation fulfill];
            }
        }
        
    }
    else
    {
        if (!model.isResponseObjectFromCache) {
            
            NSLog(@"\xE2\x9C\x85 --> [Response From Network]");
            
        }
        else
        {
            NSLog(@"\xE2\x9C\x85 --> [Response From Cache]");
        }
        [_expecation fulfill];
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
