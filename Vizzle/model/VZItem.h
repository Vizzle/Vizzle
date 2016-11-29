//
//  VZItem.h
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZItemProperty.h"

#define VZ_ARRAY_TYPE(VAL) \
        @protocol VAL <NSObject> \
        @end

@interface VZItem : NSObject<NSCoding,NSCopying>


/**
 使用字典初始化

 @param dictionary 需要实例化的dictionary
 @return 实例对象
 */
+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary;


/**
 初始化实例数组

 @param array 需要初始化的dictionary数组
 @return 初始化后的实例数组
 */
+ (NSArray *)itemsWithArray:(NSArray *)array;

/**
 *  自动进行KVC绑定,对象为dictionary
 *
 *  VZMV* => 1.1
 *
 *  @param dictionary
 */
- (void)autoKVCBinding:(NSDictionary* )dictionary;

/**
 *  自动进行KVC绑定,对象为object
 *
 *  VZMV* => 1.1
 *
 *  @param dictionary
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

/**
 *  属性集合
 *
 *  @return 属性集合
 */
+ (NSDictionary *)propertyInfos;

/**
 *  接口返回字段映射，参考Mantle
 *
 *  @return 所有字段映射
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey;

/**
 *  获取对应属性名encodeType
 *
 *  @return 获取对应属性名encodeType
 */
+ (VZItemProperty *)propertyInfoByPropertyKey:(NSString *)propertyKey;

@end
