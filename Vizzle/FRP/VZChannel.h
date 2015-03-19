//
//  VZChannel.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VZChannelCallback)(id sender,id data);

@interface VZChannel : NSObject

+ (instancetype)sharedInstance;

- (void)vz_listenOn:(NSString* )cname Object:(id)obj Callback:(VZChannelCallback)block;

- (void)vz_post:(id)data To:(NSString* )cname From:(id)obj;

- (void)vz_removeListener:(id)obj From:(NSString* )cname;

- (void)vz_removeListener:(id)obj;

@end
