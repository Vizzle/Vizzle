//
//  BXTWTripListDataSource.h
//  VizzleTest
//
//  Created by moxin on 15/9/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZListViewDataSource.h"

@interface BXTWTripListDataSource : VZListViewDataSource

//数据作为一个section返回
@property(nonatomic,assign)BOOL singleSection;
@property(nonatomic,assign)NSInteger sectionIndex;

//数据拆成多个section
@property(nonatomic,assign)NSInteger numberOfSection;


@end
