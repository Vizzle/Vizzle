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
#import "VZListItem.h"


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

- (void)testModelBinding{
    
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

- (void)testInsertSection{
    
    //insert section at top
    [self prepareDataSourceForInsertSection];
    [self.ds insertSectionAtIndex:0 withItems:@[@"top"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"top");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"c");
    
    //insert section at bottom
    [self prepareDataSourceForInsertSection];
    [self.ds insertSectionAtIndex:(self.ds.itemsForSection.count) withItems:@[@"bottom"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"c");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"bottom");
    
    //insert in the middle
    [self prepareDataSourceForInsertSection];
    [self.ds insertSectionAtIndex:1 withItems:@[@"z"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"z");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"c");
    
    //insert in the middle
    [self prepareDataSourceForInsertSection];
    [self.ds insertSectionAtIndex:2 withItems:@[@"z"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"z");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"c");
    
    //double insert
    [self prepareDataSourceForInsertSection];
    [self.ds insertSectionAtIndex:1 withItems:@[@"x"]];
    [self.ds insertSectionAtIndex:1 withItems:@[@"y"]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"y");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"x");
    XCTAssertEqual([self.ds itemsForSection:3][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:4][0], @"c");
    
    [self prepareDataSourceForInsertSection];
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
    [self prepareDataSourceForRemoveSection];
    [self.ds removeSectionByIndex:0];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"c");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"d");
    
    //remove last section
    [self prepareDataSourceForRemoveSection];
    [self.ds removeSectionByIndex:(self.ds.itemsForSection.count-1)];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"c");
    
    //remove middle section
    [self prepareDataSourceForRemoveSection];
    [self.ds removeSectionByIndex:1];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"c");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"d");
    
    [self prepareDataSourceForRemoveSection];
    [self.ds removeSectionByIndex:2];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"d");
    
    //remove twice
    [self prepareDataSourceForRemoveSection];
    [self.ds removeSectionByIndex:1];
    [self.ds removeSectionByIndex:1];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"d");
}


- (void)testSetItemsForSection
{
    [self.ds setItems:@[@"a"] ForSection:0];
    [self.ds setItems:@[@"b"] ForSection:1];
    [self.ds setItems:@[@"c"] ForSection:2];
    
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:2][0], @"c");
}

- (void)testInsertItem
{
    //insert item at top
    [self prepareDataSourceForItems];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual([[self.ds itemsForSection:0][0] class], [VZListItem class]);
    XCTAssertEqual([self.ds itemsForSection:0][1], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][2], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][3], @"c");
    
    //insert item at bottom
    [self prepareDataSourceForItems];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][1], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][2], @"c");
    XCTAssertEqual([[self.ds itemsForSection:0][3] class], [VZListItem class]);
    
    
    //insert a single item in the middle
    [self prepareDataSourceForItems];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][2], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][3], @"c");
    XCTAssertEqual([[self.ds itemsForSection:0][1] class], [VZListItem class]);
    
    //insert items in the middle
    [self prepareDataSourceForItems];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][3], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][4], @"c");
    XCTAssertEqual([[self.ds itemsForSection:0][1] class], [VZListItem class]);
    XCTAssertEqual([[self.ds itemsForSection:0][2] class], [VZListItem class]);
    
    //insert items in different section
    [self prepareDataSourceForItems];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.ds insertItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([[self.ds itemsForSection:0][1] class], [VZListItem class]);
    XCTAssertEqual([self.ds itemsForSection:0][2], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][3], @"c");

    XCTAssertEqual([self.ds itemsForSection:1][0], @"1");
    XCTAssertEqual([[self.ds itemsForSection:1][1] class], [VZListItem class]);
    XCTAssertEqual([self.ds itemsForSection:1][2], @"2");
    XCTAssertEqual([self.ds itemsForSection:1][3], @"3");
    
}


- (void)testRemoveItem
{
    //remove top item
    [self prepareDataSourceForItems];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][1], @"c");
    
    //remove bottom item
    [self prepareDataSourceForItems];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][1], @"b");
    
    
    //remove item at middle
    [self prepareDataSourceForItems];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][1], @"c");

}

- (void)testReplaceItem
{
    //replace top item
    [self prepareDataSourceForItems];
    [self.ds replaceItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual([[self.ds itemsForSection:0][0] class], [VZListItem class]);
    XCTAssertEqual([self.ds itemsForSection:0][1], @"b");
    XCTAssertEqual([self.ds itemsForSection:0][2], @"c");
    
    //replace bottom item
    [self prepareDataSourceForItems];
    [self.ds replaceItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    XCTAssertEqual([[self.ds itemsForSection:0][2] class], [VZListItem class]);
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][1], @"b");
    
    //replace middle item
    [self prepareDataSourceForItems];
    [self.ds replaceItem:[VZListItem new] AtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertEqual([[self.ds itemsForSection:0][1] class], [VZListItem class]);
    XCTAssertEqual([self.ds itemsForSection:0][0], @"a");
    XCTAssertEqual([self.ds itemsForSection:0][2], @"c");
}

- (void)testItemForCell
{
    [self prepareDataSourceForItems];
    
    XCTAssertEqual((NSString* )[self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]],@"a");
    XCTAssertEqual((NSString* )[self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]],@"b");
    XCTAssertEqual((NSString* )[self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]],@"c");
    XCTAssertEqual((NSString* )[self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]],@"1");
    XCTAssertEqual((NSString* )[self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]],@"2");
    XCTAssertEqual((NSString* )[self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]],@"3");
    
    [self.ds removeItemsForSection:1];
    [self.ds setItems:@[@"1",@"2",@"3"] ForSection:2];
    
    XCTAssertFalse([self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
    XCTAssertFalse([self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]);
    XCTAssertFalse([self.ds itemForCellAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]);
    
}

- (void)prepareDataSourceForInsertSection
{
    [self.ds removeAllItems];
    [self.ds setItems:@[@"a"] ForSection:0];
    [self.ds setItems:@[@"b"] ForSection:1];
    [self.ds setItems:@[@"c"] ForSection:2];
}

- (void)prepareDataSourceForRemoveSection
{
    [self.ds removeAllItems];
    [self.ds setItems:@[@"a"] ForSection:0];
    [self.ds setItems:@[@"b"] ForSection:1];
    [self.ds setItems:@[@"c"] ForSection:2];
    [self.ds setItems:@[@"d"] ForSection:3];
}

- (void)prepareDataSourceForItems
{
    [self.ds removeAllItems];
    [self.ds setItems:@[@"a",@"b",@"c"] ForSection:0];
    [self.ds setItems:@[@"1",@"2",@"3"] ForSection:1];
}

@end
