  
//
//  VZTimelineListModel.m
//  VizzleListExample
//
//  Created by Tao Xu on 2014-09-29 13:48:38 +0800.
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
    
    return @"https://jsonplaceholder.typicode.com/posts/";
}

- (NSArray* )responseObjects:(id)JSON
{
    NSMutableArray* ret = [NSMutableArray new];
    for (NSDictionary* dict in JSON) {
        
        VZTimelineListItem* item = [VZTimelineListItem new];
        [item autoKVCBinding:dict];
        
        //item.textheight:
        
        CGSize textSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width-24, CGFLOAT_MAX);
        CGRect bodySize = [item.body  boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor darkGrayColor]} context:nil];
        CGRect titleSize = [item.title boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//#pragma clang diagnostic pop
//        item.textHeight = sizeToFit.height;
        item.titleHeight = titleSize.size.height;
        item.bodyHeight = bodySize.size.height;
        item.itemHeight = item.titleHeight + item.bodyHeight + 30.0f;
        [ret addObject:item];
    }
  
    
    return [ret copy];
}

- (VZHTTPRequestConfig)requestConfig
{
    VZHTTPRequestConfig config = vz_defaultHTTPRequestConfig();
    config.cachePolicy=VZHTTPNetworkURLCachePolicyDefault;
    return config;
}

- (NSString* )customRequestClassName{
    return @"VZAFRequest";
}

- (NSString* )cacheKey
{
    return [[[self methodName] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld",self.currentPageIndex]];
}

@end

