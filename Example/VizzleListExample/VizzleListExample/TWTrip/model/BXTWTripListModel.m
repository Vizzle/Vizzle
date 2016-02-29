  
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

- (void)processCurrentObjects
{
    int w = [UIScreen mainScreen].bounds.size.width;
    int i=0;
    int topl = kSegmentHeaderHeight;
    int topm = kSegmentHeaderHeight;
    int topr = kSegmentHeaderHeight;
    
    for(BXTWTripListItem* item in self.objects)
    {
        if (item.itemHeight == 0) {
            item.itemHeight = arc4random() % 100 + 160;
        }

        
        if (self.layoutType == kWaterflow) {
            
//            item.itemWidth = 0.5*w;

            item.itemWidth = w / 3.0f;
        }
        else{
            item.itemWidth = w;
        }
        
        item.x = i%3 * (w/3.0) ;
        
        //left
        if (i%3 == 0)
        {
            item.y = topl;
            topl += item.itemHeight;
        }
        else if (i%3 == 1){
            item.y = topm;
            topm += item.itemHeight;
        }
        //right
        else
        {
            item.y = topr;
            topr += item.itemHeight;
        }
        i ++;
    }
}


@end

