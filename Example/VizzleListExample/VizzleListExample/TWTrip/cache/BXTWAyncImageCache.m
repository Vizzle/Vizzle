//
//  BXTWAyncImageCache.m
//  VizzleListExample
//
//  Created by moxin on 15/11/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWAyncImageCache.h"
#import <AsyncDisplayKit/ASNetworkImageNode.h>
#import <SDWebImage/SDImageCache.h>

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



//only fetch from memory
- (void)fetchCachedImageWithURL:(NSURL *)URL
                  callbackQueue:(dispatch_queue_t)callbackQueue
                     completion:(void (^)(CGImageRef imageFromCache))completion
{
    NSString* cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
    [[SDWebImageManager sharedManager].imageCache queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
       
        dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
            completion(image.CGImage);
        });
        
    }];
}

@end
