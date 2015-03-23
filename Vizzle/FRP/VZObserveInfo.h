//
//  VZObserveInfo.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-1.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VZObserverProxy;
@interface VZObserveInfo : NSObject

@property(nonatomic,weak) VZObserverProxy* proxy;
@property(nonatomic,copy) NSString* keyPath;
@property(nonatomic,assign)NSKeyValueObservingOptions options;
@property(nonatomic,assign)SEL action;
@property(nonatomic,copy) void (^observeCallback)(id observer, NSDictionary *change);
@property(nonatomic,strong) id context;

- (instancetype)initWithProxy:(VZObserverProxy *)proxy keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void(^)(id,NSDictionary*))callback action:(SEL)action context:(void *)context;

@end
