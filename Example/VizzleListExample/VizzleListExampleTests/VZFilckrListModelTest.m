//
//  VZFilckrListModelTest.m
//  VizzleListExample
//
//  Created by moxin.xt on 14-10-7.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VizzleConfig.h"
#import "VZFlickrListModel.h"


@interface VZFlickrListModelTest : XCTestCase

@property(nonatomic,strong)VZFlickrListModel* flickrSearchModel;

@end

@implementation VZFlickrListModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.flickrSearchModel = [VZFlickrListModel new];
    self.flickrSearchModel.requestType = VZModelAFNetworking;
    self.flickrSearchModel.keyword = @"bird";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResult {
    // This is an example of a functional test case.
   
    __block BOOL waitingForBlock = YES;
    [self.flickrSearchModel loadWithCompletion:^(VZModel *model, NSError *error) {
       
        //VZFlickrListModel* listModel = (VZFlickrListModel* )model;
        XCTAssert(!error, @"Pass");
        waitingForBlock = NO;
        
    }];
    
    while (waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

