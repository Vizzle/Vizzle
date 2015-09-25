//
//  VZListDataSourceTest.m
//  VizzleTest
//
//  Created by moxin on 15/9/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VZListViewDataSource.h"
#import "BXTWTripListModel.h"


@interface VZListDataSourceTest : XCTestCase

@property(nonatomic,strong)VZListViewDataSource* ds;
@property(nonatomic,strong)BXTWTripListModel* model;

@end

@implementation VZListDataSourceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.ds = [VZListViewDataSource new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
