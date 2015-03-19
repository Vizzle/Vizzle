//
//  VZObserver.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-15.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VZObserverCallback)(id observer, NSDictionary *change);

@interface VZObserverProxy : NSObject

@property(atomic,weak,readonly) id observer;

- (id)initWithObserver:(id)observer;

- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(VZObserverCallback)block;

- (void)observe:(id)object keyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options block:(VZObserverCallback)block;

- (void)unObserve:(id)observer;

- (void)unObserveAll;


@end
