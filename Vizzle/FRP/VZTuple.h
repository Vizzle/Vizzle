//
//  VZTuple.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZTuple : NSObject<NSCoding,NSCopying,NSFastEnumeration>

@property (nonatomic, readonly) NSUInteger count;

@property (nonatomic, readonly) id first;
@property (nonatomic, readonly) id second;
@property (nonatomic, readonly) id third;
@property (nonatomic, readonly) id fourth;
@property (nonatomic, readonly) id fifth;
@property (nonatomic, readonly) id last;

+ (instancetype) tupleWithArray:(NSArray* ) array;

+ (instancetype) tupleWithObjects:(id)obj,... NS_REQUIRES_NIL_TERMINATION;

- (id)objectAtIndex:(NSUInteger)index;

- (NSArray *)allObjects;

@end

@interface VZTuple (ObjectSubscripting)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
