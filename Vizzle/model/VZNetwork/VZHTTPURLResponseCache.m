//
//  VZHTTPResponseCache.m
//  VZNetworkTest
//
//  Created by moxin on 15/5/28.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZHTTPURLResponseCache.h"
#import <CommonCrypto/CommonCrypto.h>

@interface VZHTTPURLResponseCache()

@property(nonatomic,strong)NSMutableDictionary* plist;

@end

@implementation VZHTTPURLResponseCache

+ (VZHTTPURLResponseCache* )sharedCache
{
    static dispatch_once_t onceToken;
    static VZHTTPURLResponseCache* sharedCache;
    dispatch_once(&onceToken, ^{
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Cache.db"];
        sharedCache = [[VZHTTPURLResponseCache alloc]initWithMemoryCapacity:kVZDefaultHTTPResponseMemoryCacheSize diskCapacity:kVZDefaultHTTPResponseFileCacheSize diskPath:cachePath];
        
        [NSURLCache setSharedURLCache:sharedCache];
    });
    return sharedCache;
   
}

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    return [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
}

- (NSString *)ETagForRequest:(NSURLRequest *)request
{
    NSString *ETag = nil;
    
//    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:[[self class] synthesisRequest:request]];
//    if (cachedResponse) {
//        if ([cachedResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
//            // 使用每次body算出来的etag作为真实的etag
//            return [[self class] CalculateETag:cachedResponse.data];
//        }
//    }
    
    return ETag;
}


- (NSCachedURLResponse* )cachedResponseForRequest:(NSURLRequest *)request
{
    return [super cachedResponseForRequest:request];

}

//缓存带有Etag的请求
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    if ([self hasETag:cachedResponse]) {
        [super storeCachedResponse:cachedResponse forRequest:request];
    }
}

- (BOOL)hasETag:(NSCachedURLResponse *)cachedResponse
{
    NSURLResponse *response = cachedResponse.response;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSString *eTag = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:kVZDefaultHTTPResponseEtag];
        if (eTag && eTag.length > 0 && [eTag isEqualToString:[self calculateEtag:cachedResponse]]) {
            return YES;
        }
    }
    return NO;
}


//真实的etag为body md5后的值
- (NSString* )calculateEtag:(NSCachedURLResponse* )cachedResponse
{
    NSData* data = cachedResponse.data;
    NSString* etag = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString* md5Str = digestString(etag);
    return [NSString stringWithFormat:@"\"%@\"",md5Str];
}

+ (NSURLRequest *)cachedRequest:(NSURLRequest *)request
{
//    NSString *URLString = [@"https://mobilegw.alipay.com/rpcetag.html" stringByAppendingFormat:@"#%@", [ASMD5 calculateDigestFromData:request.HTTPBody]];
//    return [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    return nil;
}

NS_INLINE NSString* digestString(NSString* string)
{
    NSMutableString *outputString = nil;
    
    if (string && string.length > 0) {
        
        const char *cString = [string UTF8String];
        unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cString, (CC_LONG)strlen(cString), outputBuffer);
        
        outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
            [outputString appendFormat:@"%02x",outputBuffer[count]];
        }
    }
    
    return outputString;
}

@end
