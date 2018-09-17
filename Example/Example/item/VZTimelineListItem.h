  
//
//  VZTimelineListItem.h
//  VizzleListExample
//
//  Created by Tao Xu on 2014-09-29 13:48:38 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



@class VZListItem;
@interface VZTimelineListItem : VZListItem

@property(nonatomic,strong) NSNumber* userId;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* body;
@property(nonatomic,assign) float titleHeight;
@property(nonatomic,assign) float bodyHeight;

@end

  
