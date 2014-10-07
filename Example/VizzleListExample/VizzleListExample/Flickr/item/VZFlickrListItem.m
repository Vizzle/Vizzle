  
//
//  VZFlickrListItem.m
//  VizzleListExample
//
//  Created by moxinxt on 2014-10-01 22:14:53 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZFlickrListItem.h"

@interface VZFlickrListItem()

@end

@implementation VZFlickrListItem

- (void)autoKVCBinding:(NSDictionary *)dictionary
{
    [super autoKVCBinding:dictionary];
    
    //todo...
    self.identifier = dictionary[@"id"];
}

@end

