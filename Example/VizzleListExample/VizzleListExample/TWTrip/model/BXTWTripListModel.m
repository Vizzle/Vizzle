
//
//  BXTWTripListModel.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXTWTripListModel.h"
#import "BXTWTripListItem.h"
#import "BXTWTripConfig.h"

@interface BXTWTripListModel()
{
}

@end

/**
 *  "xbAllowCache": 4,
	"clientVersion": "1.4.0",
	"sort": "sort",
	"order": "desc",
	"client": "iOS",
	"start": "0",
	"size": "20"
 */
@implementation BXTWTripListModel

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods
- (NSDictionary *)dataParams {
    
    return @{
             @"keyWord": @"历史",
             @"sort": @"service_default_rank",
             @"start": [NSString stringWithFormat:@"%ld",(long)self.currentPageIndex*self.pageSize],
             @"cityAbbr": @"",
             @"from": @"app_hotsearch",
             @"showCurrency": @"CNY",
             @"size": @"10",
             @"uid": @"17",
             @"xbAllowCache": @"4",
             @"clientVersion": @"1.4.0",
             @"client": @"iOS"
             };
    
}

- (NSInteger)pageSize
{
    return 10;
}

- (VZHTTPRequestConfig)requestConfig
{
    VZHTTPRequestConfig config = vz_defaultHTTPRequestConfig();
    config.requestMethod = VZHTTPMethodPOST;
    //    config.cachePolicy = VZHTTPNetworkURLCachePolicyDefault;
    return config;
}

- (NSString* )cacheKey
{
    return [[[self methodName] stringByAppendingString:@"/"]stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.currentPageIndex]];
}

- (NSString *)methodName {
    
    // return @"http://api.cuitrip.com/baseservice/getHomeCardList";
    return @"http://api.cuitrip.com/baseservice/serviceSearch";
}


- (NSMutableArray* )responseObjects:(id)JSON
{
    
    NSMutableArray* list = [NSMutableArray new];
    NSArray* result = JSON[@"result"][@"lists"];
    
    if (![result isEqual:[NSNull null]]) {
        
        for (NSDictionary* dict in result) {
            
            BXTWTripListItem* item =  [BXTWTripListItem new];
            [item autoKVCBinding:dict];
            [list addObject:item];
            
        }
    }
    
    return list;
}




@end

