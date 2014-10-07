  
//
//  VZFlickrListItem.h
//  VizzleListExample
//
//  Created by moxinxt on 2014-10-01 22:14:53 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



@class VZListItem;
@interface VZFlickrListItem : VZListItem

@property(nonatomic,strong)NSString* identifier;
@property(nonatomic,strong)NSString* owner;
@property(nonatomic,strong)NSString* secret;
@property(nonatomic,strong)NSString* server;
@property(nonatomic,strong)NSString* farm;
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* ispublic;
@property(nonatomic,strong)NSString* isfriend;
@property(nonatomic,strong)NSString* isfamily;



@end

  
