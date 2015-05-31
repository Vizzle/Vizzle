//
//  VZHTTPURLResponseCache.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "VZHTTPURLResponseDataCache.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation VZHTTPURLResponseItem

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.triggerDate forKey:@"triggerDate"];
    [aCoder encodeObject:@(self.expireInterval) forKey:@"expireInterval"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.response forKey:@"response"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        self.triggerDate    = [aDecoder decodeObjectForKey:@"triggerDate"];
        self.expireInterval = ((NSNumber*)[aDecoder decodeObjectForKey:@"expireInterval"]).doubleValue;
        self.identifier     = [aDecoder decodeObjectForKey:@"identifier"];
        self.response       = [aDecoder decodeObjectForKey:@"response"];
    }
    
    return self;
}

- (NSString*)description
{
    return self.identifier;
}


@end


const  NSTimeInterval kVZHTTPNetworkURLCacheTimeOutValue = 259200.0;

@interface VZHTTPURLResponseDataCache() <NSCacheDelegate>
{
    dispatch_queue_t _barrierQueue;
}

@property(nonatomic,strong) NSString* cachePath;
@property(nonatomic,strong) NSCache* memCache;
@property(nonatomic,strong) NSMutableArray* keys;
@property(nonatomic,strong) NSMutableDictionary* cachePlist;

@end

@implementation VZHTTPURLResponseDataCache

+ (instancetype) sharedInstance
{
    static VZHTTPURLResponseDataCache* urlCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        urlCache = [VZHTTPURLResponseDataCache new];
    });
    return urlCache;
}


- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        _barrierQueue = dispatch_queue_create("com.VZHTTPURLResponseCache.www", DISPATCH_QUEUE_CONCURRENT);
        
        _memCache = [NSCache new];
        _memCache.name = @"VZHTTPURLResponseCache";
        _memCache.delegate = self;
        
        //create file cache
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VZHTTPURLCache"];
        
        // hashmap of the ".plist"
        // key is the url's hash
        // value is the date
		NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[_cachePath stringByAppendingPathComponent:@"ETUrlCache.plist"]];
		
        //if the plist exist
		if([dict isKindOfClass:[NSDictionary class]])
        {
            _cachePlist = [dict mutableCopy];
            
            __block NSMutableArray *removeList = [NSMutableArray array];
            
            //clean expired url
            [_cachePlist enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                NSDate* date = [_cachePlist objectForKey:key];
                
                if(fabs([date timeIntervalSinceNow]) > kVZHTTPNetworkURLCacheTimeOutValue)
                {
                    [removeList addObject:key];
                    
                    //remove the cache image
                    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:NULL];
                }
                
            }];
            
            //clear the plist
            if ([removeList count] > 0)
            {
                [_cachePlist removeObjectsForKeys:removeList];
                
            }
		}
        
        else
        {
            //create an empty new one
			_cachePlist = [NSMutableDictionary new];
            
            // create a cache directory
            [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
    }

    return self;
}


- (void)dealloc
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_0
    dispatch_release(_barrierQueue);
    
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public file method

- (void)cachedResponseForUrlString:(NSString*)identifier completion:(void(^)(NSError* err, id object))aCallback
{

    [self fetchCachedDataForUrlString:identifier completion:^(id object) {

        if (object)
        {
            
            id response = nil;
            
            VZHTTPURLResponseItem* cacheUrlItem = (VZHTTPURLResponseItem*)object;
            
            // check if the timeout
            if(cacheUrlItem)
            {
                //校验时间，如果cache的时间策略为none，则不校验
                
                if (cacheUrlItem.expireInterval == 0) {
                    
                    NSLog(@"read from cache:%@",identifier);
                    
                    response =  cacheUrlItem.response;
                }
                else
                {
                    //get current date
                    NSDate* currdate = [NSDate dateWithTimeIntervalSinceNow:0];
                    
                    //last date in seconds
                    NSTimeInterval last =[cacheUrlItem.triggerDate timeIntervalSince1970]*1;
                    
                    // now date in seconds
                    NSTimeInterval now=[currdate timeIntervalSince1970]*1;
                    
                    NSTimeInterval cha=now-last;
                    
                    
                    //not timeout
                    if(cha < cacheUrlItem.expireInterval)
                    {
                        NSLog(@"[%@]-->read from cache:%@",[self class],identifier);
                        response =  cacheUrlItem.response;
                    }
                }
                
                if (aCallback) {
                    aCallback(nil,response);
                }
            }
            else
            {
                if (aCallback) {
                    aCallback([NSError errorWithDomain:@"VZHTTPNetworkingErrorDomain" code:700 userInfo:nil],nil);
                }
            }
        }
        else
        {
            if (aCallback) {
                aCallback([NSError errorWithDomain:@"VZHTTPNetworkingErrorDomain" code:-1 userInfo:nil],nil);
            }
        }
        
    }];
}

- (void)saveResponse:(id)data WithUrlString:(NSString *)identifier ExpireTime:(NSTimeInterval)timeInterval
{
    NSLog(@"[%@]-->enter cache:%@",[self class],identifier);
    
    //save cache item
    VZHTTPURLResponseItem* cacheItem = [[VZHTTPURLResponseItem alloc]init];
    cacheItem.expireInterval = timeInterval;
    cacheItem.identifier     = identifier;
    cacheItem.response       = data;
    cacheItem.triggerDate    = [NSDate date];
    
    //序列化
    [self cacheData:cacheItem forUrlString:identifier];
}




///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private file method


- (void)cacheData:(id)data forUrlString:(NSString*)identifier
{
    NSString* key = [self keyForURLString : identifier];
   
    [_memCache setObject:data forKey:identifier];

    [self saveResponse:data forKey:key];

}

- (void)fetchCachedDataForUrlString:(NSString*)identifier completion:(void(^)(id object))aCallback
{
    NSString* key = [self keyForURLString : identifier];
    
    __block VZHTTPURLResponseItem* response = [_memCache objectForKey:key];
    
    //miss memory
    if (!response)
    {
        //check plist
        if ([_cachePlist objectForKey:key])
        {
            dispatch_async(_barrierQueue, ^{
                
                response = [self responseForKey:key];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (aCallback) {
                        aCallback(response);
                    }
                });
            });
            
        }
        else
        {
            if (aCallback) {
                aCallback(nil);
            }
        }
        
    }
    else
    {
        if (aCallback) {
            aCallback(response);
        }
    }
}

- (void)removeCachedDataForKey:(NSString*)identifier
{
    if (identifier == nil)
        return ;
    
    NSString* key = [self keyForURLString : identifier];
    
    dispatch_async(_barrierQueue, ^{
        
        if ([_cachePlist objectForKey:key]) {
                
                [self deleteResponseForKey:key];
        }
    });
}

- (void)cleanCachedDataInMemory
{
    [_memCache removeAllObjects];
}

- (void)cleanCachedDataOnDisk
{
    dispatch_async(_barrierQueue, ^{
        
        for (NSString* key in _cachePlist) {
            
            [self deleteResponseForKey:key];
        }
    });
    


}


///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private util method

- (NSString*)cachePathForKey:(NSString*)key
{
    NSString* path = [_cachePath stringByAppendingPathComponent:key];
	return path;
}

- (NSString*)keyForURLString:(NSString*) urlStr
{
    
    const char *cStr = [urlStr UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    
    return output;

}


//thread safe
- (void)saveResponse:(NSData *)data forKey:(NSString *)key
{

    dispatch_barrier_async(_barrierQueue, ^{
        
        NSData* rawUrlList = [NSKeyedArchiver archivedDataWithRootObject:data];
        
        //wirte to file
        NSString *filePath = [ _cachePath stringByAppendingPathComponent:key];
        
        if ([rawUrlList writeToFile:filePath atomically:YES]){
            NSLog(@"【cache response succeed】");
        }
        else{
            NSLog(@"【cache response failed】");
        }
        
        //update plist
        [_cachePlist setObject:[NSDate date] forKey:key];
        [_cachePlist writeToFile:[self cachePathForKey:@"ETUrlCache.plist"] atomically:YES];
        
    });

    
}
- (id )responseForKey:(NSString *)key
{
    id response = nil;
    
    NSString *filePath = [ _cachePath stringByAppendingPathComponent:key];
    NSData* data =  [NSData dataWithContentsOfFile:filePath];
    response =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return response;
    
}

- (void)deleteResponseForKey:(NSString*)key
{
    dispatch_barrier_async(_barrierQueue, ^{
        
        [_cachePlist removeObjectForKey:key];
        [_cachePlist writeToFile:[self cachePathForKey:@"ETUrlCache.plist"] atomically:YES];
        
        [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
   
    });
}

@end
