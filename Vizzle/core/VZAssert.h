//
//  VZAssert.h
//  VizzleListExample
//
//  Created by Tao Xu 15/7/6.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#ifndef VizzleListExample_VZAssert_h
#define VizzleListExample_VZAssert_h

#pragma once

#define VZAssert(condition, description, ...) NSAssert(condition, description, ##__VA_ARGS__)
#define VZCAssert(condition, description, ...) NSCAssert(condition, description, ##__VA_ARGS__)

#define VZConditionalAssert(shouldTestCondition, condition, description, ...) VZAssert((!(shouldTestCondition) || (condition)), nil, (description), ##__VA_ARGS__)
#define VZCConditionalAssert(shouldTestCondition, condition, description, ...) VZCAssert((!(shouldTestCondition) || (condition)), nil, (description), ##__VA_ARGS__)

#define VZAssertNil(condition, description, ...) VZAssert(!(condition), (description), ##__VA_ARGS__)
#define VZCAssertNil(condition, description, ...) VZCAssert(!(condition), (description), ##__VA_ARGS__)

#define VZAssertNotNil(condition, description, ...) VZAssert((condition), (description), ##__VA_ARGS__)
#define VZCAssertNotNil(condition, description, ...) VZCAssert((condition), (description), ##__VA_ARGS__)

#define VZAssertTrue(condition) VZAssert((condition), nil, nil)
#define VZCAssertTrue(condition) VZCAssert((condition), nil, nil)

#define VZAssertFalse(condition) VZAssert(!(condition), nil, nil)
#define VZCAssertFalse(condition) VZCAssert(!(condition), nil, nil)

#define VZAssertMainThread() VZAssert([NSThread isMainThread], nil, @"This method must be called on the main thread")
#define VZCAssertMainThread() VZCAssert([NSThread isMainThread], nil, @"This method must be called on the main thread")

#define VZFailAssert(description, ...) VZAssert(NO, nil, (description), ##__VA_ARGS__)
#define VZCFailAssert(description, ...) VZCAssert(NO, nil, (description), ##__VA_ARGS__)


#endif
