//
//  VZModelTests.m
//  VizzleTest
//
//  Created by moxin.xt on 14-11-6.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VZHTTPListModel.h"



@interface VZModelStateTests : XCTestCase

@property(nonatomic,strong)VZHTTPListModel* model;

@end

@implementation VZModelStateTests

- (void)setUp {
    [super setUp];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.model = nil;
}

- (void)testModelState{
    
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
       
        
    }];

}



@end
