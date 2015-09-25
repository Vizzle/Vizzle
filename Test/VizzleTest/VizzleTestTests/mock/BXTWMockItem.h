//
//  BXTWMockItem.h
//  VizzleTest
//
//  Created by moxin on 15/7/21.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZListItem.h"

@interface BXTWMockItem : VZListItem

@property(nonatomic,strong)NSArray* serviceSiteList;
@property(nonatomic,strong)NSDictionary* serviceInfo;
@property(nonatomic,assign)NSUInteger sid;
@property(nonatomic,strong)NSString* mockId;

@end
