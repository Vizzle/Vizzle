//
//  VZHTTPResponseCache.m
//  VZNetworkTest
//
//  Created by moxin on 15/5/28.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZHTTPResponseCache.h"


@interface VZHTTPResponseCache()

@end
@implementation VZHTTPResponseCache

+ (void)install
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VZHTTPURLResponseCache"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        // create a cache directory
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
        
        VZHTTPResponseCache* sharedCache = [[VZHTTPResponseCache alloc]initWithMemoryCapacity:kVZDefaultHTTPResponseMemoryCacheSize diskCapacity:kVZDefaultHTTPResponseFileCacheSize diskPath:cachePath];
        
        [NSURLCache setSharedURLCache:sharedCache];
    });
   
}

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    return [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
}

- (NSCachedURLResponse* )cachedResponseForRequest:(NSURLRequest *)request
{
    return nil;

}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{


}

@end
