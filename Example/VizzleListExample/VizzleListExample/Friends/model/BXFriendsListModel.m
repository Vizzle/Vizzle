
//
//  BXFriendsListModel.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-04-02 16:51:17 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXFriendsListModel.h"
#import "BXFriendsListItem.h"


@interface BXFriendsListModel()

@end

@implementation BXFriendsListModel

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods

- (NSDictionary *)dataParams {
    
 
    return @{@"owneruid":@"21",
             @"page":@(self.currentPageIndex+1).stringValue,
             @"status":@"1",
             @"accesstoken":@"201504231048033116352"};
}

- (NSString *)methodName {
    
    return [@"http://121.40.184.9/beixinmei/appapi/" stringByAppendingString:@"ListFriend"];
}

- (BOOL)isPost
{
    return true;
}

- (NSString* )customRequestClassName
{
    return @"BXHTTPRequest";
}

- (NSMutableArray* )responseObjects:(id)JSON
{
    if(!JSON || JSON == [NSNull null])
        return nil;
    
    NSMutableArray* ret = [NSMutableArray new];
    
    NSArray* list = JSON;
    
    for (NSDictionary* json in list) {
        
        BXFriendsListItem* item = [BXFriendsListItem new];
        [item autoKVCBinding:json];
        
        if ([item.usergroup isEqualToString:@"2"]) {
            item.nickname = [item.nickname stringByAppendingString:@"(老师)"];
        }
        
        if ([item.usergroup isEqualToString:@"3"]) {
            item.nickname = [item.nickname stringByAppendingString:@"(园长)"];
        }
        [ret addObject:item];
    }
    
    return ret;
    
}

@end

