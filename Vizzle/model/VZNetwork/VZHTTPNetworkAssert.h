//
//  VZHTTPNetworkAssert.h
//  VZNetworkTest
//
//  Created by moxin on 15/5/28.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#ifndef VZNetworkTest_VZHTTPNetworkAssert_h
#define VZNetworkTest_VZHTTPNetworkAssert_h

typedef NS_ENUM (int, VZHTTPNetworkURLCachePolicy)
{
    VZHTTPNetworkURLCachePolicyNone = 0,
    VZHTTPNetworkURLCachePolicyDefault = 1,
    VZHTTPNetworkURLCachePolicyOnlyReading=2,
    VZHTTPNetworkURLCachePolicyOnlyWriting=3
};

typedef NS_ENUM (int, VZHTTPNetworkURLCacheTime)
{
    VZHTTPNetworkURLCacheTimeNone = 0,
    VZHTTPNetworkURLCacheTime30Sec = 30,
    VZHTTPNetworkURLCacheTimeOneMinite = 60,
    VZHTTPNetworkURLCacheTimeOneHour = 60*60,
    VZHTTPNetworkURLCacheTimeOneDay = 60*60*24,
    VZHTTPNetworkURLCacheTimeThreeDays = 60*60*24*3,
    VZHTTPNetworkURLCacheTimeOneWeek = 60*60*24*7
};

typedef NS_ENUM(int, VZHTTPNetworkResponseType)
{
    VZHTTPNetworkResponseTypeJSON = 0,
    VZHTTPNetworkResponseTypeXML = 1,
};

typedef NS_ENUM(int, VZHTTPRequestMethod)
{
    VZHTTPMethodGET = 0,
    VZHTTPMethodPOST = 1,
    VZHTTPMethodDELETE = 2,
    VZHTTPMethodPUT = 3
};

typedef struct requestConfig
{
    bool isHTTPs;
    NSTimeInterval requestTimeoutSeconds;
    VZHTTPNetworkURLCachePolicy cachePolicy;
    VZHTTPNetworkURLCacheTime cacheTime;
    VZHTTPRequestMethod requestMethod;

    
}VZHTTPRequestConfig;

typedef struct responseConfig
{
    VZHTTPNetworkResponseType responseType;
    
}VZHTTPResponseConfig;

static inline VZHTTPRequestConfig vz_defaultHTTPRequestConfig()
{
    return (VZHTTPRequestConfig)
    {
        .isHTTPs = false,
        .requestTimeoutSeconds = 15,
        .cachePolicy = VZHTTPNetworkURLCachePolicyNone,
        .cacheTime = VZHTTPNetworkURLCacheTimeNone,
        .requestMethod = VZHTTPMethodGET
    };
}

static inline VZHTTPResponseConfig vz_defaultHTTPResponseConfig()
{
    return (VZHTTPResponseConfig)
    {
        .responseType = VZHTTPNetworkResponseTypeJSON
    };
}

static inline NSString* vz_httpMethod(VZHTTPRequestMethod method)
{
    NSString* ret = nil;
    switch (method) {
        case VZHTTPMethodGET:
        {
            ret = @"GET";
            break;
        }
        case VZHTTPMethodPOST:
        {
            ret = @"POST";
            break;
        }
        
        case VZHTTPMethodDELETE:
        {
            ret = @"DELETE";
            break;
        }
            
        case VZHTTPMethodPUT:
        {
            ret = @"PUT";
            break;
        }
            
        default:
            break;
    }
    
    return ret;
}

//dispatch_queue_t vz_dispatch_serialQueue()
//{
//    static dispatch_queue_t s;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        s = dispatch_queue_create("com.vizzle.serialQueue", DISPATCH_QUEUE_SERIAL);
//    });
//    
//    return s;
//}
//
//dispatch_queue_t vz_dispatch_concurrentQueue()
//{
//    static dispatch_queue_t s;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        s = dispatch_queue_create("com.vizzle.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
//    });
//    
//    return s;
//}

#endif
