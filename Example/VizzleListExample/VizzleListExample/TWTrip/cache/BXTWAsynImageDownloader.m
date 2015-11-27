//
//  BXTWAsynImageDownloader.m
//  VizzleListExample
//
//  Created by moxin on 15/11/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWAsynImageDownloader.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageDownloader.h>

@implementation BXTWAsynImageDownloader

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static BXTWAsynImageDownloader* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [BXTWAsynImageDownloader new];
    });
    return instance;
}

- (id)downloadImageWithURL:(NSURL *)URL
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat progress))downloadProgressBlock
                completion:(void (^)(CGImageRef image, NSError *error))completion
{
    
   return [[SDWebImageManager sharedManager] downloadImageWithURL:URL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       
       if (!finished) {
           return;
       }
       dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
           completion(image.CGImage, error);
       });
    }];
}

/**
 @abstract Cancels an image download.
 @param downloadIdentifier The opaque download identifier object returned from
 `downloadImageWithURL:callbackQueue:downloadProgressBlock:completion:`.
 @discussion This method has no effect if `downloadIdentifier` is nil.
 */
- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier
{
    //noop
    id <SDWebImageOperation> op = (id <SDWebImageOperation>)downloadIdentifier;
    [op cancel];

}
@end
