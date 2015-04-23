  
//
//  BXFriendsListModel.h
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-04-23 10:39:37 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//


  
#import "VZHTTPListModel.h"

@interface BXFriendsListModel : VZHTTPListModel


@property(nonatomic,strong) NSString* owneruid;
@property(nonatomic,strong) NSString* page;
@property(nonatomic,strong) NSString* status;
@property(nonatomic,strong) NSString* accesstoken;

@end

