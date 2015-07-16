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
   
}

- (void)setUp {
    
    [super setUp];
    self.model = [VZHTTPTestModel new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _model = nil;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - test Load

/**
 *  测试API:load,使用delegate
 */
- (void)testLoad
{
    self.model.delegate = self;
    [self.model load];
    NSTimeInterval timeoutValue = self.model.requestConfig.requestTimeoutSeconds;
    [self delay:timeoutValue completion:^{
        XCTFail(@"Timeout!");
    }];
}

- (void)testLoadWithCompletion
{
    self.model.delegate = nil;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
       
        if (!error) {
            
            XCTAssertEqual(model.state, VZModelStateFinished);
            
        }
        else
        {
            XCTAssertEqual(model.state, VZModelStateError);
            
        }
    }];
    NSTimeInterval timeoutValue = self.model.requestConfig.requestTimeoutSeconds;
    [self delay:timeoutValue completion:^{
        XCTFail(@"Timeout!");
    }];

}

- (void)testReloadWithCompletion
{
    
    
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - test timeout



- (void)testLoadSucceed
{

}

- (void)testLoadFailed
{

}

- (void)modelDidStart:(VZModel *)model
{
    XCTAssertEqual(model.state, VZModelStateLoading);
}

- (void)modelDidFinish:(VZModel *)model
{
    NSLog(@"!!!%ld!!!",(long)model.state);
    XCTAssertEqual(model.state, VZModelStateFinished);
}

- (void)modelDidFail:(VZModel *)model withError:(NSError *)error
{
    NSLog(@"!!!%ld!!!",(long)model.state);
    XCTAssertEqual(model.state, VZModelStateError);
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
