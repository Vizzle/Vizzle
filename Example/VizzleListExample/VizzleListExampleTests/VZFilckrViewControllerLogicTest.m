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
#import "VZFlickrLogic.h"


@interface VZFilckrViewControllerLogicTest : XCTestCase<VZViewControllerLogicInterface>

@property(nonatomic,strong)VZFlickrLogic* logic;

@end

@implementation VZFilckrViewControllerLogicTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.logic = [VZFlickrLogic new];
    self.logic.viewController = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_logic_view_did_load {

    [self.logic logic_view_did_load];
}

- (void)test_logic_view_will_appear
{
    [self.logic logic_view_will_appear];
}

- (void)test_logic_view_did_appear
{
    [self.logic logic_view_did_appear];
    
}

- (void)test_logic_view_will_disappear
{
    [self.logic logic_view_will_disappear];
    
}

- (void)test_logic_view_did_disappear
{
    [self.logic logic_view_did_disappear];
    
}

- (void)onControllerShouldPerformAction:(int)type args:(NSDictionary *)dict
{
    //test callback logic here:
    
    //todo...
    
}

@end

