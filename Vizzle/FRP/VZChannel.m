//
//  VZChannel.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZChannel.h"


@interface VZChannelListener:NSObject

@property(nonatomic,copy) VZChannelCallback block;
@property(nonatomic,weak) id object;

@end


@implementation VZChannelListener

@end


@implementation VZChannel
{
    NSMutableDictionary* _channels;
}

+ (instancetype)sharedInstance
{
    static VZChannel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VZChannel alloc] init];
    });
    return instance;
    
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _channels = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)vz_listenOn:(NSString* )cname Object:(id)obj Callback:(VZChannelCallback)block
{
   
    NSMutableSet* listeners = _channels[cname];
    
    if (!listeners) {
        listeners = [NSMutableSet new];
        _channels[cname] = listeners;
    }

    BOOL hasObject = false;
    
    for (VZChannelListener* listener in listeners) {
        
        if (listener.object == obj) {
            hasObject = true;
            break;
        }
    }

    if ( hasObject ) {
        
        // already here
    }
    else
    {
        VZChannelListener* listener = [VZChannelListener new];
        listener.object = obj;
        listener.block = block;
        [listeners addObject:listener];
    }
    
}



- (void)vz_post:(id)data To:(NSString* )cname From:(id)obj
{
    NSMutableSet* listeners = _channels[cname];
    
    [listeners enumerateObjectsUsingBlock:^(VZChannelListener* listener, BOOL *stop) {
       
        if (listener.object && listener.object != obj) {
            
            if (listener.block) {
                
                listener.block(obj,data);
            }
        }
    
    }];

}

- (void)vz_removeListener:(id)obj From:(NSString* )cname
{
    NSMutableSet* listeners = _channels[cname];
    __block VZChannelListener*  taregetListener = nil;
    
    [listeners enumerateObjectsUsingBlock:^(VZChannelListener* listener, BOOL *stop) {
        
        if (obj == listener.object) {
            taregetListener = listener;
            *stop = YES;
        }
    }];
    
    if (taregetListener) {
        
        NSMutableSet* set = _channels[cname];
        [set removeObject:taregetListener];
    }
    
}

- (void)vz_removeListener:(id)obj
{
    __block NSString*   channelName = @"";
    __block VZChannelListener*  taregetListener = nil;
    
    [_channels enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        NSMutableSet* listeners = (NSMutableSet* )obj;
        
        [listeners enumerateObjectsUsingBlock:^(VZChannelListener* listener, BOOL *stop) {
           
            if (obj == listener.object) {
                channelName = key;
                taregetListener = listener;
                *stop = YES;
            }
        }];
    }];
    
    if (channelName.length > 0) {
        
        if (taregetListener) {
            
            NSMutableSet* set = _channels[channelName];
            [set removeObject:taregetListener];
        }
    }

}


@end
