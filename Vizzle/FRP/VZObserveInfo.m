//
//  VZObserveInfo.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-1.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZObserveInfo.h"

@implementation VZObserveInfo

- (instancetype)initWithProxy:(VZObserverProxy *)proxy keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void(^)(id,NSDictionary*))callback action:(SEL)action context:(void *)context
{
    self = [super init];
    if (nil != self) {
        self.proxy             =  proxy;
        self.observeCallback   =  callback;
        self.keyPath =  keyPath;
        self.options = options;
        self.action  = action;
        self.context = (__bridge id)(context);
    }
    return self;
}



- (NSUInteger)hash
{
    return [_keyPath hash];
}

- (BOOL)isEqual:(VZObserveInfo* )object
{
    if (nil == object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [_keyPath isEqualToString:object->_keyPath];
}

- (NSString *)description
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p keyPath:%@", NSStringFromClass([self class]), self, _keyPath];
    if (0 != _options) {
        [s appendFormat:@" options:%lu", _options];
    }
    if (NULL != _action) {
        [s appendFormat:@" action:%@", NSStringFromSelector(_action)];
    }
    if (NULL != _context) {
        [s appendFormat:@" context:%p", _context];
    }
    if (NULL != _observeCallback) {
        [s appendFormat:@" block:%p", _observeCallback];
    }
    [s appendString:@">"];
    return s;
}

@end
