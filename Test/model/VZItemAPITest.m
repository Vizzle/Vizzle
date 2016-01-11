//
//  VZItemAPITest.m
//  VizzleTest
//
//  Created by moxin on 15/7/21.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BXTWTripListItem.h"
#import "BXTWMockListItem.h"


@interface VZItemAPITest : XCTestCase

@property(nonatomic,strong)BXTWTripListItem* listItem;
@property(nonatomic,strong)BXTWMockListItem* mockItem;
@property(nonatomic,strong)NSDictionary* json;

@end

@implementation VZItemAPITest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.listItem = [BXTWTripListItem new];
    self.mockItem = [BXTWMockListItem new];

    
    NSBundle* bunlde = [NSBundle bundleForClass:[self class]];
    NSString* path  = [bunlde pathForResource:@"tripItem" ofType:@"json"];
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    self.json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAutoKVCBinding
{
    [self.listItem autoKVCBinding:self.json];
    
    //父类是否绑定成功
//    XCTAssertNotNil(self.listItem.serviceAddress,@"父类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.sid,@"父类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.serviceName,@"父类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.headPic,@"父类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.userNick,@"父类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.servicePicUrl,@"父类数据绑定失败!");
//    
//    //自身object类型数据是否绑定成功
//    XCTAssertNotNil(self.listItem.serviceInfo,@"子类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.serviceSiteList,@"子类数据绑定失败!");
//    XCTAssertNotNil(self.listItem.serviceCount,@"子类绑定数据失败");
//    XCTAssertFalse(self.listItem.isAvailable,@"类型绑定错误!");
//    XCTAssertNil(self.listItem.maxCount,@"类型绑定错误!");
    
}

- (void)testAutoMapTo
{
    [self testAutoKVCBinding];
    
    [self.mockItem autoMapTo:self.listItem];
    
    //object类型的映射
    XCTAssertNotNil(self.mockItem.serviceInfo,@"autoMap失败");
    XCTAssertNotNil(self.mockItem.servicePicUrl,@"autoMap失败");
    XCTAssertNotNil(self.mockItem.serviceSiteList,@"autoMap失败");
    XCTAssertNotNil(self.mockItem.headPic,@"autoMap失败");
    XCTAssertNotNil(self.mockItem.userNick,@"autoMap失败");
    
    //非object类型
    XCTAssertEqual(self.mockItem.sid, 0,@"类型绑定错误");
    XCTAssertNil(self.mockItem.mockId, @"autoMap绑定失败");

}


@end
