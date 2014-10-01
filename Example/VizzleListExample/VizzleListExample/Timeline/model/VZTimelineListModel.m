  
//
//  VZTimelineListModel.m
//  VizzleListExample
//
//  Created by Jayson Xu on 2014-09-29 13:48:38 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZTimelineListModel.h"
#import "VZTimelineListItem.h"


@interface VZTimelineListModel()

@end

@implementation VZTimelineListModel

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods


- (NSString *)methodName {
    
    return @"https://api.app.net/stream/0/posts/stream/global";
}

- (NSMutableArray* )responseObjects:(id)JSON
{
    NSMutableArray* ret = [NSMutableArray new];
  
    //todo:
    NSArray* list = JSON[@"data"];
    
    for (NSDictionary* dict in list) {
        
        VZTimelineListItem* item = [VZTimelineListItem new];
        item.text = dict[@"text"];
        item.userName = dict[@"user"][@"username"];
        item.avatarURL = dict[@"user"][@"avatar_image"][@"url"];
        
        //item.textheight:
        NSString* text = item.text;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        item.textHeight = sizeToFit.height;
        item.itemHeight = fmaxf(70.0f, (float)sizeToFit.height + 45.0f);
        
        [ret addObject:item];
    }
  
    
    return ret;
}

@end

