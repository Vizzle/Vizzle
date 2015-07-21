  
//
//  BXTWTripListItem.h
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "VZListItem.h"
#import "BXTWTripItem.h"

@interface BXTWTripListItem : BXTWTripItem

@property(nonatomic,strong)NSArray* serviceSiteList;
@property(nonatomic,strong)NSDictionary* serviceInfo;
@property(nonatomic,assign)BOOL isAvailable;
@property(nonatomic,strong)NSNumber* serviceCount;
@property(nonatomic,assign)NSString* maxCount;


@end

  
