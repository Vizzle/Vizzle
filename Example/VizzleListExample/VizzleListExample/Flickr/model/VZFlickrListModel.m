  
//
//  VZFlickrListModel.m
//  VizzleListExample
//
//  Created by moxinxt on 2014-10-01 22:14:53 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZFlickrListModel.h"
#import "VZFlickrListItem.h"
#import "VZFlickrListConfig.h"


@interface VZFlickrListModel()

@end

@implementation VZFlickrListModel

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods

- (NSDictionary *)dataParams {
    
    //&api_key=%@&text=%@&per_page=5&format=json&nojsoncallback=1
    
    return @{@"api_key" : VZFlickrAppKey ,
             @"text" : self.keyword,
             @"per_page":@"10",
             @"format" : @"json",
             @"nojsoncallback":@"1"};
}

- (NSDictionary* )headerParams{
   
    //todo:
    
    return nil;
}


- (NSString *)methodName {
    
    return @"https://api.flickr.com/services/rest/?method=flickr.photos.search";
}

- (BOOL)parseResponse:(id)JSON
{
    NSString* ret = JSON[@"stat"];
    
    if ([ret isEqualToString:@"ok"]) {
        return [super parseResponse:JSON];
    }
    else
        return NO;
}

- (NSMutableArray* )responseObjects:(id)JSON
{
    NSMutableArray* ret = [NSMutableArray new];
    
    NSArray* photos = JSON[@"photos"][@"photo"];
    for (NSDictionary* dict in photos) {
        
        VZFlickrListItem* item = [VZFlickrListItem new];
        [item autoKVCBinding:dict];
        [ret addObject:item];
    }
    
    return ret;
}

@end

