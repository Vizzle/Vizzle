//
//  BXTWAyncImageCache.m
//  VizzleListExample
//
//  Created by moxin on 15/11/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWAyncImageCache.h"
#import <AsyncDisplayKit/ASNetworkImageNode.h>

@interface BXTWAyncImageCache()

@end

@implementation BXTWAyncImageCache

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static BXTWAyncImageCache* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [BXTWAyncImageCache new];
    });
    return instance;
}
- (void)fetchCachedImageWithURL:(NSURL *)URL
                  callbackQueue:(dispatch_queue_t)callbackQueue
                     completion:(void (^)(CGImageRef imageFromCache))completion
{
    
}

@end
