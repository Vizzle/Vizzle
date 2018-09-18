//
//  VZItem.h
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZItem : NSObject<NSCoding,NSCopying>

/**
 *  自动进行KVC绑定,对象为dictionary
 */
- (void)autoKVCBinding:(NSDictionary* )dictionary;

/**
 *  自动进行KVC绑定,对象为object
 */
- (void)autoMapTo:(id)object;
/**
 *  VZMV* => 1.2
 *
 *  @return 序列化为dictionary
 */
- (NSDictionary* )toDictionary;

/**
 *  VZMV* => 1.2
 *
 *  @return 所有property的名称
 */
+ (NSSet* )propertyNames;

@end
