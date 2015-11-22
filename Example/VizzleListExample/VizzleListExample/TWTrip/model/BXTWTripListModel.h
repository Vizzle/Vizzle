  
//
//  BXTWTripListModel.h
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//


  
#import "VZHTTPListModel.h"
#import "BXTWTripConfig.h"

@interface BXTWTripListModel : VZHTTPListModel

@property(nonatomic,assign,readonly)CGFloat contentHeight;
@property(nonatomic,assign)LAYOUT layoutType;

@end

