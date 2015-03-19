//
//  VZTuple.m
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZTuple.h"

@interface VZTuple()

@property(nonatomic,strong) NSArray* backingArray;

@end

@implementation VZTuple


+ (instancetype) tupleWithArray:(NSArray* ) array
{
    VZTuple* tuple = [VZTuple new];
    tuple.backingArray = [array copy];
    return tuple;
    
}

+ (instancetype) tupleWithObjects:(id)obj,... NS_REQUIRES_NIL_TERMINATION
{
    VZTuple* tuple = [VZTuple new];
    
    va_list args;
    va_start(args, obj);
    
    NSMutableArray* objects = [NSMutableArray new];
    
    for(id currentObject = obj; currentObject != nil; currentObject = va_arg(args, id))
    {
        [objects addObject:currentObject];
    }
    
    va_end(args);
    
    if(objects.count == 0)
        tuple.backingArray = @[];
    else
        tuple.backingArray = [objects copy];
    
    return tuple;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.allObjects];
}

- (NSUInteger)count
{
    return self.backingArray.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if (index < self.backingArray.count) {
        
        id obj = self.backingArray[index];
        
        return obj;
    }
    else
        return nil;

}

- (NSArray *)allObjects
{
    return [self.backingArray copy];
}

////////////////////////////////////////////////////////////////////////
#pragma  mark - Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
{
    return [self.backingArray countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)first
{
    return [self objectAtIndex:0];
}

- (id)second
{
    return [self objectAtIndex:1];
}

- (id)third
{
    return [self objectAtIndex:2];
}

- (id)fourth
{
    return [self objectAtIndex:3];
}

- (id)fifth
{
    return [self objectAtIndex:4];
}

- (id)last
{
    return [self objectAtIndex:self.count-1];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self objectAtIndex:idx];
}

////////////////////////////////////////////////////////////////////////
#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    //That's classic ->  we're immutable, bitches!
    return self;
}


////////////////////////////////////////////////////////////////////////
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;
    
    self.backingArray = [coder decodeObjectForKey:@"self.backingArray"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.backingArray != nil) [coder encodeObject:self.backingArray forKey:@"self.backingArray"];
}

- (BOOL)isEqual:(VZTuple *)object {
    
    if (object == self)
        return YES;
   
    if (![object isKindOfClass:self.class])
        return NO;
    
    return [self.backingArray isEqual:object.backingArray];
}

- (NSUInteger)hash {
    return self.backingArray.hash;
}


@end
