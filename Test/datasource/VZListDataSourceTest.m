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
#import <objc/runtime.h>

static const void* kTagKey = &kTagKey;
@interface VZListItem(Tag)

@property(nonatomic,strong)NSString* tag;

@end

@implementation VZListItem(Tag)

- (NSString* )tag
{
    return objc_getAssociatedObject(self, kTagKey);
}

- (void)setTag:(NSString *)tag{
    
    return objc_setAssociatedObject(self, kTagKey, tag, OBJC_ASSOCIATION_RETAIN);
}


@end


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
    VZListItem* insertedItem = [VZListItem new];
    insertedItem.tag = @"top";
    [self.ds insertSectionAtIndex:0 withItems:@[insertedItem]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).tag, @"top");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:1][0]).tag, @"a");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:2][0]).tag, @"b");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:3][0]).tag, @"c");
    
    //insert section at bottom
    [self prepareDataSource];
    insertedItem.tag = @"bottom";
    [self.ds insertSectionAtIndex:(self.ds.itemsForSection.count) withItems:@[insertedItem]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).tag, @"a");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:1][0]).tag, @"b");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:2][0]).tag, @"c");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:3][0]).tag, @"bottom");
    
    //insert in the middle
    [self prepareDataSource];
    insertedItem.tag = @"z";
    [self.ds insertSectionAtIndex:1 withItems:@[insertedItem]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).tag, @"a");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:1][0]).tag, @"z");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:2][0]).tag, @"b");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:3][0]).tag, @"c");
    
    //insert in the middle
    [self prepareDataSource];
    insertedItem.tag = @"z";
    [self.ds insertSectionAtIndex:2 withItems:@[insertedItem]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).tag, @"a");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:1][0]).tag, @"b");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:2][0]).tag, @"z");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:3][0]).tag, @"c");
    
    //double insert
    [self prepareDataSource];
    VZListItem* insertedXItem = [VZListItem new];
    insertedXItem.tag = @"x";
    VZListItem* insertedYItem = [VZListItem new];
    insertedYItem.tag = @"y";
    
    [self.ds insertSectionAtIndex:1 withItems:@[insertedXItem]];
    [self.ds insertSectionAtIndex:1 withItems:@[insertedYItem]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).tag, @"a");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:1][0]).tag, @"y");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:2][0]).tag, @"x");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:3][0]).tag, @"b");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:4][0]).tag, @"c");
    
    [self prepareDataSource];
    insertedXItem.tag = @"x";
    insertedYItem.tag = @"y";
    [self.ds insertSectionAtIndex:1 withItems:@[insertedXItem]];
    [self.ds insertSectionAtIndex:2 withItems:@[insertedYItem]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).tag, @"a");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:1][0]).tag, @"x");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:2][0]).tag, @"y");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:3][0]).tag, @"b");
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:4][0]).tag, @"c");
}

- (void)testRemoveSection
{
    //remove first section
    [self prepareDataSource];
    [self.ds removeSectionByIndex:0];
    XCTAssertEqual([self.ds itemsForSection:0][0], @"b");
    XCTAssertEqual([self.ds itemsForSection:1][0], @"c");
}

- (void)testInsertItem{
    
    VZListItem* item = [VZListItem new];
    
    //头部插入
    [self perpareDataSourceForItems];
    [self.ds insertItem:item AtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).indexPath.row,0);
    
    //尾部插入
    [self perpareDataSourceForItems];
    [self.ds insertItem:item AtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][4]).indexPath.row,4);
    
    //中间插入
    [self perpareDataSourceForItems];
    [self.ds insertItem:item AtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][3]).indexPath.row,3);
}

- (void)testRemoveItem
{
    //头部删除
    [self perpareDataSourceForItems];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
     (((VZListItem* )[self.ds itemsForSection:0][0]).indexPath.row,0);
    
    //尾部删除
    [self perpareDataSourceForItems];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
     XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][1]).indexPath.row,1);
    
    //中间删除
    [self perpareDataSourceForItems];
    [self.ds removeItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][1]).indexPath.row,1);
}

- (void)testReplaceItem
{
    VZListItem* item = [VZListItem new];
    
    //头部替换
    [self perpareDataSourceForItems];
    [self.ds replaceItem:item AtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][0]).indexPath.row,0);
    
    //尾部替换
    [self perpareDataSourceForItems];
    [self.ds replaceItem:item AtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][4]).indexPath.row,4);
    
    //中间替换
    [self perpareDataSourceForItems];
    [self.ds replaceItem:item AtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    XCTAssertEqual(((VZListItem* )[self.ds itemsForSection:0][3]).indexPath.row,3);
    
}

- (void)prepareDataSource
{
    [self.ds removeAllItems];
    
    VZListItem* l1 = [VZListItem new];
    l1.tag = @"a";

    VZListItem* l2 = [VZListItem new];
    l2.tag = @"b";
    
    VZListItem* l3 = [VZListItem new];
    l3.tag = @"c";
    
    [self.ds setItems:@[l1] ForSection:0];
    [self.ds setItems:@[l2] ForSection:1];
    [self.ds setItems:@[l3] ForSection:2];
}


- (void)perpareDataSourceForItems{
    
    [self.ds removeAllItems];
    
    NSMutableArray* list = [NSMutableArray new];
    for (int i=0; i<5; i++) {
        
        VZListItem* item = [VZListItem new];
        item.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [list addObject:item];
    }
    [self.ds setItems:[list copy] ForSection:0];
}

@end
