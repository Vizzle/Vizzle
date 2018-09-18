//
//  VZHTTPURLResponseCache.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "VZHTTPResponseDataCache.h"
#import "VZHTTPRequestInterface.h"
#import <CommonCrypto/CommonCrypto.h>

@interface VZHTTPURLResponseItem : NSObject<NSCoding>

@property(nonatomic,strong) NSDate*        triggerDate;
@property(nonatomic,assign) NSTimeInterval expireInterval;
@property(nonatomic,strong) NSString*      identifier;
@property(nonatomic,strong) id             response;
@property(nonatomic,strong) NSString*      responseStr;

@end

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

@interface VZHTTPResponseDataCache() <NSCacheDelegate>
{
    dispatch_queue_t _cacheQueue;
}

@property(nonatomic,strong) NSString* cachePath;
@property(nonatomic,strong) NSCache* memCache;
@property(nonatomic,strong) NSMutableArray* keys;
@property(nonatomic,strong) NSMutableDictionary* cachePlist;

@end

@implementation VZHTTPResponseDataCache

+ (instancetype) sharedInstance
{
    static VZHTTPResponseDataCache* urlCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        urlCache = [VZHTTPResponseDataCache new];
    });
    return urlCache;
}


- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        _cacheQueue = dispatch_queue_create("com.VZHTTPURLResponseCache.www", DISPATCH_QUEUE_CONCURRENT);
        _memCache = [NSCache new];
        _memCache.name = @"VZHTTPURLResponseCache";
        _memCache.delegate = self;
        
        //create file cache
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VZHTTPURLCache"];
        
        // hashmap of the ".plist"
        // key is the url's hash
        // value is the date
		NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[_cachePath stringByAppendingPathComponent:@"VZUrlCache.plist"]];
		
        //if the plist exist
		if([dict isKindOfClass:[NSDictionary class]])
        {
            _cachePlist = [dict mutableCopy];
            
            __block NSMutableArray *removeList = [NSMutableArray array];
            
            //clean expired url
            [_cachePlist enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                NSDate* date = [self->_cachePlist objectForKey:key];
                
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

- (void)cachedResponseForKey:(NSString*)identifier completion:(void(^)(id object))aCallback
{

    [self fetchCachedDataForUrlString:identifier completion:^(id object) {

        if (object)
        {
            
            id response = nil;
            
            VZHTTPURLResponseItem* cacheUrlItem = (VZHTTPURLResponseItem*)object;

            if(cacheUrlItem)
            {
                //校验时间，如果cache的时间策略为none，则不校验
                
                if (cacheUrlItem.expireInterval == 0) {
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
                        response =  cacheUrlItem.response;
                    }
                }
                
                if (aCallback) {
                    aCallback(response);
                }
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
                aCallback(nil);
            }
        }
        
    }];
}

- (void)saveResponse:(id)data ForKey:(NSString *)identifier ExpireTime:(NSTimeInterval)timeInterval Completion:(void (^)(BOOL))completion
{
    //save cache item
    VZHTTPURLResponseItem* cacheItem = [[VZHTTPURLResponseItem alloc]init];
    cacheItem.expireInterval = timeInterval;
    cacheItem.identifier     = identifier;
    cacheItem.response       = data;
    cacheItem.triggerDate    = [NSDate date];
    
    //序列化
    [self cacheData:cacheItem forUrlString:identifier completion:completion];
}


- (BOOL)hasCache:(NSString* )identifier
{
    NSString* key = [self keyForURLString:identifier];
    if ([_memCache objectForKey:key]) {
        return true;
    }
    else if ([_cachePlist objectForKey:key])
    {
        return true;
    }
    else
        return false;
}

- (NSString* )cachedKeyForVZHTTPRequest:(id<VZHTTPRequestInterface>)request
{
    NSString* urlString = request.requestURL;
    NSDictionary* queries = request.queries;
    return [[urlString stringByAppendingString:@"/"] stringByAppendingString:queries?[queries description]:@""];
}

- (void)deleteCachedResponseForKey:(NSString *)key Completion:(void (^)(BOOL bSucceed))completion
{
    if (key.length > 0) {
        
        if ([self hasCache:key]) {
            
            [self removeCachedDataForKey:key completion:completion];

        }
        else
        {
            if (completion) {
                completion(false);
            }
        }
    }
    else
    {
        if (completion) {
            completion(false);
        }
    }
}


- (void)cleanAllCachedResponse
{
    [self cleanCachedDataInMemory];
    [self cleanCachedDataOnDisk];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private file method


- (void)cacheData:(id)data forUrlString:(NSString*)identifier completion:(void(^)(BOOL b))callback
{
    NSString* key = [self keyForURLString : identifier];
   
    [_memCache setObject:data forKey:key];

    [self saveResponse:data forKey:key completion:callback];

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
            dispatch_async(_cacheQueue, ^{
                
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

- (void)removeCachedDataForKey:(NSString*)identifier completion:(void(^)(BOOL b))callback
{
    if (identifier == nil)
        return ;
    
    NSString* key = [self keyForURLString : identifier];
    
    dispatch_async(_cacheQueue, ^{
        if ([self->_cachePlist objectForKey:key]) {
            [self removeCachedResponseForKey:key completion:callback];
        }
    });
}

- (void)cleanCachedDataInMemory
{
    [_memCache removeAllObjects];
}

- (void)cleanCachedDataOnDisk
{
    dispatch_async(_cacheQueue, ^{
        for (NSString* key in self->_cachePlist) {
            [self removeCachedResponseForKey:key completion:nil];
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
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    
    return output;

}


//thread safe
- (void)saveResponse:(NSData *)data forKey:(NSString *)key completion:(void(^)(BOOL b))completion
{

    dispatch_barrier_async(_cacheQueue, ^{
        
        NSData* rawUrlList = [NSKeyedArchiver archivedDataWithRootObject:data];
        
        //wirte to file
        NSString *filePath = [self->_cachePath stringByAppendingPathComponent:key];
        
        BOOL ret = [rawUrlList writeToFile:filePath atomically:YES];
        
        if (ret) {
            
            //update plist
            [self->_cachePlist setObject:[NSDate date] forKey:key];
            ret = [self->_cachePlist writeToFile:[self cachePathForKey:@"VZUrlCache.plist"] atomically:YES];
            if (completion) {
                completion(ret);
            }
        }
        else
        {
            if (completion) {
                completion(NO);
            }
        }

        
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
- (void)removeCachedResponseForKey:(NSString *)key completion:(void (^)(BOOL))aCallback{
    dispatch_barrier_async(_cacheQueue, ^{
        [self->_cachePlist removeObjectForKey:key];
        BOOL ret = [self->_cachePlist writeToFile:[self cachePathForKey:@"VZUrlCache.plist"] atomically:YES];
        if (ret){
            ret = [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
            if (aCallback) {
                aCallback(ret);
            }
        }
        else{
            if (aCallback) {
                aCallback(false);
            }
        }
   
    });
}

@end
