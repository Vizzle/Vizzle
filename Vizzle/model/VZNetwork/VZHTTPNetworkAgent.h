//
//  VZHTTPNetworkAgent.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "VZHTTPNetworkConfig.h"

@class VZHTTPConnectionOperation;
@class VZHTTPURLResponseCache;
@class VZHTTPRequestGenerator;
@class VZHTTPResponseParser;

@interface VZHTTPNetworkAgent : NSObject
@property (nonatomic, strong,readonly) NSThread* runloopThread;
@property (nonatomic, strong,readonly) NSOperationQueue *operationQueue;

/**
 *  单例对象
 *
 *  @return VZHTTPNetworkAgent单例对象
 */
+ (instancetype)sharedInstance;

- (VZHTTPConnectionOperation* )HTTP:(NSString*)aURlString
                  completionHandler:(void(^)(VZHTTPConnectionOperation* connection, NSString* responseString,id responseObj, NSError* error))aCallback;

- (VZHTTPConnectionOperation* )HTTP:(NSString*)aURlString
                             params:(NSDictionary*)aParams
                  completionHandler:(void(^)(VZHTTPConnectionOperation* connection, NSString* responseString, id responseObj, NSError* error))aCallback;


- (VZHTTPConnectionOperation* )HTTP:(NSString*)aURlString
                      requestConfig:(VZHTTPRequestConfig) requestConfig
                     responseConfig:(VZHTTPResponseConfig) responseConfig
                             params:(NSDictionary*)aParams
                  completionHandler:(void(^)(VZHTTPConnectionOperation* connection,NSString* responseString,id responseObj, NSError* error))aCallback;

- (void)cancelByTagString:(NSString* )tagString;

- (void)cancelAll;

@end

