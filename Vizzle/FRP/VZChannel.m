//
//  VZChannel.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZChannel.h"
#import <libkern/OSAtomic.h>

@interface VZChannelListener:NSObject

@property(nonatomic,copy) VZChannelCallback block;
@property(nonatomic,weak) id object;

@end


@implementation VZChannelListener

@end


@implementation VZChannel
{
    NSMutableDictionary* _channels;
    OSSpinLock _lock;
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
        _lock = OS_SPINLOCK_INIT;
        
    }
    
    return self;
}

- (NSString* )description
{
    return [NSString stringWithFormat:@"<[%@] ==> %@>",self.class,_channels];
}

- (void)vz_listenOn:(NSString* )cname Object:(id)obj Callback:(VZChannelCallback)block
{
   
    NSMutableSet* listeners = _channels[cname];
    
    OSSpinLockLock(&_lock);
    
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
    OSSpinLockUnlock(&_lock);
}



- (void)vz_post:(id)data To:(NSString* )cname From:(id)obj
{
    NSMutableSet* listeners = _channels[cname];
    
    OSSpinLockLock(&_lock);
    
    [listeners enumerateObjectsUsingBlock:^(VZChannelListener* listener, BOOL *stop) {
       
        if (listener.object && listener.object != obj) {
            
            if (listener.block) {
                
                listener.block(obj,data);
            }
        }
    
    }];
    
    OSSpinLockUnlock(&_lock);

}

- (void)vz_removeListener:(id)obj From:(NSString* )cname
{
    
    NSMutableSet* listeners = _channels[cname];
    __block VZChannelListener*  taregetListener = nil;
    
    OSSpinLockLock(&_lock);
    
    [listeners enumerateObjectsUsingBlock:^(VZChannelListener* listener, BOOL *stop) {
        
        if (obj == listener.object || listener.object == nil) {
            taregetListener = listener;
            *stop = YES;
        }
    }];
    
    if (taregetListener) {
    
        [listeners removeObject:taregetListener];
        
        if (listeners.count == 0) {
            [_channels removeObjectForKey:cname];
        }
    }
    
    OSSpinLockUnlock(&_lock);

    
}

- (void)vz_removeListener:(id)obj
{
    __block NSString*   channelName = @"";
    __block VZChannelListener*  taregetListener = nil;
    
    OSSpinLockLock(&_lock);
    
    [_channels enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
       
        NSMutableSet* listeners = (NSMutableSet* )value;
        
        [listeners enumerateObjectsUsingBlock:^(VZChannelListener* listener, BOOL *stop) {
           
            //listener is dead or equal to the obj
            if (obj == listener.object || !listener.object) {
                channelName = key;
                taregetListener = listener;
                *stop = YES;
            }
        }];
        
        if (channelName.length > 0) {
            
            if (taregetListener) {
                
                NSMutableSet* set = _channels[channelName];
                taregetListener.object = nil;
                taregetListener.block = nil;
                [set removeObject:taregetListener];
                
                if (set.count == 0) {
                    [_channels removeObjectForKey:channelName];
                }
            }
        }
    }];
    
    
    OSSpinLockUnlock(&_lock);


}


@end
