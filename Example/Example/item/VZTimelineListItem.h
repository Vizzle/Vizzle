  
//
//  VZTimelineListItem.h
//  VizzleListExample
//
//  Created by Jayson Xu on 2014-09-29 13:48:38 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



@class VZListItem;
@interface VZTimelineListItem : VZListItem

@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* userName;
@property(nonatomic,strong) NSString* avatarURL;

@property(nonatomic,assign) float textHeight;

@end

  
