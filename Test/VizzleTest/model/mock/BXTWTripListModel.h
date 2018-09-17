  
//
//  BXTWTripListModel.h
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//


  
#import "VZHTTPListModel.h"

@interface BXTWTripListModel : VZHTTPListModel

//mock：
@property(nonatomic,assign)VZHTTPNetworkURLCachePolicy cachePolicy;
@property(nonatomic,assign)VZHTTPNetworkURLCacheTime cacheTime;

@end

