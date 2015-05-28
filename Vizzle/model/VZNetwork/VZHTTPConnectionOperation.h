//
//  VZHTTPConnectionOperation.h
//  VZLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import "VZHTTPURLConnectionOperation.h"

@class VZHTTPResponseParser;

@interface VZHTTPConnectionOperation : VZHTTPURLConnectionOperation


@property(nonatomic,strong,readwrite) VZHTTPResponseParser* responseParser;
@property(nonatomic,strong,readonly) NSHTTPURLResponse* reponse;
@property(nonatomic,strong,readonly) id responseObj;
@property(nonatomic,assign,readonly) NSTimeInterval startTime;
@property(nonatomic,assign,readonly) NSTimeInterval endTime;
@property(nonatomic,strong)NSString* tagString;

-(void) setCompletionHandler:(void(^)(VZHTTPConnectionOperation* op, NSString* responseString, id responseObj, NSError* error))aCallback;

@end
