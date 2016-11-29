//
//  VZValueTransformer.m
//  VizzleListExample
//
//  Created by Yulin Ding on 30/11/2016.
//  Copyright © 2016 VizLab. All rights reserved.
//

#import "VZValueTransformer.h"

@interface SBReversibleValueTransformer : VZValueTransformer

@end

@interface VZValueTransformer()

@property (nonatomic, copy) VZValueTransformerBlock forwardBlock;
@property (nonatomic, copy) VZValueTransformerBlock reverseBlock;

@end

@implementation VZValueTransformer

+ (instancetype)transformerUsingForwardBlock:(VZValueTransformerBlock)forwardBlock {
	return [[self alloc] initWithForwardBlock:forwardBlock reverseBlock:nil];
}

+ (instancetype)transformerUsingReversibleBlock:(VZValueTransformerBlock)reversibleBlock {
	return [self transformerUsingForwardBlock:reversibleBlock reverseBlock:reversibleBlock];
}

+ (instancetype)transformerUsingForwardBlock:(VZValueTransformerBlock)forwardBlock
                                reverseBlock:(VZValueTransformerBlock)reverseBlock {
	return [[SBReversibleValueTransformer alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

- (id)initWithForwardBlock:(VZValueTransformerBlock)forwardBlock
              reverseBlock:(VZValueTransformerBlock)reverseBlock {
    NSParameterAssert(forwardBlock != nil);
    
    self = [super init];
    if (self == nil) return nil;
    
    _forwardBlock = [forwardBlock copy];
    _reverseBlock = [reverseBlock copy];
    
    return self;
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

+ (Class)transformedValueClass {
    return [NSObject class];
}

- (id)transformedValue:(id)value {
	return self.forwardBlock(value);
}

@end

@implementation SBReversibleValueTransformer

- (id)initWithForwardBlock:(VZValueTransformerBlock)forwardBlock
              reverseBlock:(VZValueTransformerBlock)reverseBlock {
    NSParameterAssert(reverseBlock != nil);
    return [super initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)reverseTransformedValue:(id)value {
    return self.reverseBlock(value);
}

@end
