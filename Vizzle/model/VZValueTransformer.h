//
//  VZValueTransformer.h
//  VizzleListExample
//
//  Created by Yulin Ding on 30/11/2016.
//  Copyright © 2016 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^VZValueTransformerBlock)(id value);

@interface VZValueTransformer : NSValueTransformer

+ (instancetype)transformerUsingForwardBlock:(VZValueTransformerBlock)transformation;
+ (instancetype)transformerUsingReversibleBlock:(VZValueTransformerBlock)transformation;
+ (instancetype)transformerUsingForwardBlock:(VZValueTransformerBlock)forwardTransformation
                                reverseBlock:(VZValueTransformerBlock)reverseTransformation;

@end
