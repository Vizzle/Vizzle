//
//  VZHTTPModelAPITests.m
//  VizzleTest
//
//  Created by moxin on 15/7/16.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VZHTTPModel.h"

@interface VZHTTPTestModel : VZHTTPModel

@end

@implementation VZHTTPTestModel

- (NSString* )methodName
{
    return @"https://api.app.net/stream/0/posts/stream/global";
}

- (BOOL)parseResponse:(id)response
{
    return true;
}


@end

@interface VZHTTPModelAPITests : XCTestCase<VZModelDelegate>

@property(nonatomic,strong)VZHTTPTestModel* model;

@end

@implementation VZHTTPModelAPITests
{
    XCTestExpectation* _expecation;
}

- (void)setUp {
    
    [super setUp];
    self.model = [VZHTTPTestModel new];
    [self.model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [_model removeObserver:self forKeyPath:@"state" context:nil];
    _model = nil;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - test Load

/**
 *  测试API:load,使用delegate
 */
- (void)testLoad
{
    
    _expecation = [self expectationWithName:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    [self.model load];
    NSTimeInterval timeoutValue = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:timeoutValue handler:^(NSError *error) {
        
        if (error) {
             XCTFail(@"\xE2\x9D\x8C[Timeout]:%@",error.userInfo[NSLocalizedDescriptionKey]);
        }
        else
        {
            NSLog(@"\xE2\x9C\x85[Test]-->Succeed");
        }
       
    }];
}
/**
 *  测试API:loadWithCompletion,使用block
 */
- (void)testLoadWithCompletion
{
    _expecation = [self expectationWithName:NSStringFromSelector(_cmd)];
    self.model.delegate = nil;
    
    __weak typeof(self) weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
       
        if (!error) {
            
            XCTAssertEqual(model.state, VZModelStateFinished);
            
        }
        else
        {
            XCTAssertEqual(model.state, VZModelStateError);
            
        }
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf->_expecation fulfill];
        }
        
    }];
    NSTimeInterval timeoutValue = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:timeoutValue handler:^(NSError *error) {
        
        if (error) {
            XCTFail(@"\xE2\x9D\x8C[Timeout]");
        }
        else
        {
            NSLog(@"\xE2\x9C\x85[Test]-->Succeed");
        }
        
    }];

}

/**
 *  测试 API: reloadWithCompletion
 */
- (void)testReloadWithCompletion
{
    _expecation = [self expectationWithName:NSStringFromSelector(_cmd)];
    self.model.delegate = nil;
    
    __weak typeof(self) weakSelf = self;
    [self.model reloadWithCompletion:^(VZModel *model, NSError *error) {
        
        if (!error) {
            
            XCTAssertEqual(model.state, VZModelStateFinished);
            
        }
        else
        {
            XCTAssertEqual(model.state, VZModelStateError);
            
        }
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf->_expecation fulfill];
        }
        
    }];
    NSTimeInterval timeoutValue = self.model.requestConfig.requestTimeoutSeconds;
    [self waitForExpectationsWithTimeout:timeoutValue handler:^(NSError *error) {
        
        if (error) {
            XCTFail(@"\xE2\x9D\x8C[Timeout]");
        }
        else
        {
            NSLog(@"\xE2\x9C\x85[Test]-->Succeed");
        }
        
    }];
    
}

/**
 *  测试 API: cancel
 */
- (void)testCancel1
{
    [self.model load];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.model cancel];
    });
    NSTimeInterval timeoutValue = 2.0f;
    [self delay:timeoutValue completion:^{
        
        XCTAssertEqual(self.model.state, VZModelStateReady);
    }];


}

- (void)testCancel2
{
    self.model.delegate = nil;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        //noop
    }];
    NSTimeInterval timeoutValue = 2.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.model cancel];
        [self.model cancel];
    });
    [self delay:timeoutValue completion:^{
       
        XCTAssertEqual(self.model.state, VZModelStateReady);
    }];

}

- (void)testCancel3
{
    self.model.delegate = nil;
    [self.model reloadWithCompletion:^(VZModel *model, NSError *error) {
        
        //noop
    }];
    NSTimeInterval timeoutValue = 2.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.model cancel];
    });
    [self delay:timeoutValue completion:^{
        
        XCTAssertEqual(self.model.state, VZModelStateReady);
    }];
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        
        NSLog(@"%@",change);
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - callback


- (void)modelDidStart:(VZModel *)model
{
    XCTAssertEqual(model.state, VZModelStateLoading);
}

- (void)modelDidFinish:(VZModel *)model
{
    XCTAssertEqual(model.state, VZModelStateFinished);
    [_expecation fulfill];
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

- (XCTestExpectation* )expectationWithName:(NSString* )name
{
    return [self expectationWithDescription:name];
}

@end
