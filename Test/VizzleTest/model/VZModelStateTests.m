//
//  VZModelTests.m
//  VizzleTest
//
//  Created by moxin.xt on 14-11-6.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BXTWTripListModel.h"
#import "BXTWTripListItem.h"


@interface VZModelStateTests : XCTestCase<VZModelDelegate>

@property(nonatomic,strong)BXTWTripListModel* model;
@property(nonatomic,strong)XCTestExpectation* expecation;
@end

@implementation VZModelStateTests
{
   
}

- (void)setUp {
    [super setUp];
    
    self.model = [BXTWTripListModel new];
    [self.model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [self.model removeObserver:self forKeyPath:@"state" context:nil];
    self.model = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - model状态的TC

/**
 *  model状态: isLoading -> isReady
 *  model状态: isReady -> isReady
 */
- (void)test1_0{
    
    self.model.delegate = self;
    [self.model load];
    [self.model cancel];
    [self.model cancel];
    
    NSTimeInterval timeoutValue = 1.0f;
    [self delay:timeoutValue completion:^{
        
        XCTAssertEqual(self.model.state, VZModelStateReady);
        
    }];
}

/**
 *  model状态: isReady -> isLoading
 *  model状态: isLoading -> isFinshed/isError
 */
- (void)test1_1{
    
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
 *  model状态: isFinished/isError -> isLoading
 */
- (void)test1_2
{
    self.model.delegate = nil;
    [self.model loadWithCompletion:nil];
    [self delay:2.0 completion:^{
       
        //wait for the model finish
        [self.model reloadWithCompletion:nil];
        
        XCTAssertEqual(self.model.state, VZModelStateLoading);
        
        [self delay:2.0 completion:^{
           
            if (self.model.error) {
                XCTAssertEqual(self.model.state, VZModelStateError);
            }
            else
                XCTAssertEqual(self.model.state, VZModelStateFinished);
            
        }];
        
    }];

}

/**
 *  model状态: isFinished/isError -> isReady
 */
- (void)test1_3
{
    self.expecation = [self expectationWithName:NSStringFromSelector(_cmd)];
    __weak typeof(self)weakSelf=self;
    self.model.delegate = nil;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        [weakSelf.model cancel];
        
        XCTAssertEqual(weakSelf.model.state, VZModelStateReady);
        
        [weakSelf.expecation fulfill];
        
        
    }];
    [self waitForExpectationsWithTimeout:self.model.requestConfig.requestTimeoutSeconds handler:nil];

}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - model异常操作的TC
/**
 *  model行为：load -> load
 *
 *  这种情况出现于对同一个model做两次load操作，那么第二次load会被cancel掉
 *
 *  model的状态：isReady -> isLoading -> isReady -> isLoading -> isFinished/isError
 *
 */
- (void)test2_1
{
    _expecation = [self expectationWithName:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    [self.model load];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.model loadWithCompletion:nil];
    });
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
 *  model行为：load -> reload -> reload
 *
 *  这种情况出现于连续下拉刷新的场景，model在loading的过程连续触发reLoad操作
 *
 *  model的状态：isReady -> isLoading -> isReady -> isLoading -> isFinished/isError
 *
 */
- (void)test2_2
{
    _expecation = [self expectationWithName:NSStringFromSelector(_cmd)];
    self.model.delegate = self;
    [self.model load];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.model reload];
    });
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


////////////////////////////////////////////////////////////////////////////////
#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        
        //NSLog(@"\xF0\x9F\x98\x8A : %@",change[NSKeyValueChangeNewKey]);
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
