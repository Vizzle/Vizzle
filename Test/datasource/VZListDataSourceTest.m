//
//  VZListDataSourceTest.m
//  VizzleTest
//
//  Created by moxin on 15/9/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXTWTripListDataSource.h"
#import "BXTWTripListModel.h"


@interface VZListDataSourceTest : XCTestCase

@property(nonatomic,strong)XCTestExpectation* expecation;
@property(nonatomic,strong)BXTWTripListDataSource* ds;
@property(nonatomic,strong)BXTWTripListModel* model;

@end

@implementation VZListDataSourceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.ds = [BXTWTripListDataSource new];
    self.model = [BXTWTripListModel new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _ds = nil;
    _model = nil;
}

- (void)testModelBindingForSingleSection {
    
    self.ds.singleSection = true;
    self.expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    __weak typeof(self) weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
        
        VZHTTPListModel* listModel = (VZHTTPListModel* )model;
        [weakSelf.ds tableViewControllerDidLoadModel:listModel];
        
        XCTAssertEqual([[weakSelf.ds itemsForSection:0] count], listModel.objects.count);
        
        [weakSelf.expecation fulfill];
        
        
    }];
    [self waitForExpectationsWithTimeout:self.model.requestConfig.requestTimeoutSeconds handler:nil];
}

- (void)testModelBindingForMultipleSection{

    self.ds.singleSection = false;
    self.ds.numberOfSection = 3;
    self.expecation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    __weak typeof(self) weakSelf = self;
    [self.model loadWithCompletion:^(VZModel *model, NSError *error) {
       
        VZHTTPListModel* listModel = (VZHTTPListModel* )model;
        [weakSelf.ds tableViewControllerDidLoadModel:listModel];
        
        XCTAssertEqual( weakSelf.ds.itemsForSection.count, weakSelf.ds.numberOfSection);
        
        [weakSelf.expecation fulfill];

    }];
    [self waitForExpectationsWithTimeout:self.model.requestConfig.requestTimeoutSeconds handler:nil];
}

- (void)testInsertSection{
    
    //insert section at top
    [self prepareDataSource];
    [self.ds insertSectionAtIndex:0 withItems:@[@"top"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"top");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"c");
    
    //insert section at bottom
    [self prepareDataSource];
    [self.ds insertSectionAtIndex:(self.ds.itemsForSection.count) withItems:@[@"bottom"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"c");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"bottom");
    
    //insert in the middle
    [self prepareDataSource];
    [self.ds insertSectionAtIndex:1 withItems:@[@"z"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"z");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"c");
    
    //insert in the middle
    [self prepareDataSource];
    [self.ds insertSectionAtIndex:2 withItems:@[@"z"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"z");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"c");
    
    //double insert
    [self prepareDataSource];
    [self.ds insertSectionAtIndex:1 withItems:@[@"x"]];
    [self.ds insertSectionAtIndex:1 withItems:@[@"y"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"y");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"x");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:4][0], @"c");
    
    [self prepareDataSource];
    [self.ds insertSectionAtIndex:1 withItems:@[@"x"]];
    [self.ds insertSectionAtIndex:2 withItems:@[@"y"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"x");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"y");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:4][0], @"c");
}

- (void)testRemoveSection
{
    //remove first section
    [self prepareDataSource];
    [self.ds removeSectionByIndex:0];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"c");
    
    
    

}

- (void)prepareDataSource
{
    [self.ds removeAllItems];
    [self.ds setItems:@[@"a"] ForSection:0];
    [self.ds setItems:@[@"b"] ForSection:1];
    [self.ds setItems:@[@"c"] ForSection:2];
}

@end
