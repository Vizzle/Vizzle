//
//  VZItemProperty.h
//  VizzleListExample
//
//  Created by Yulin Ding on 30/11/2016.
//  Copyright © 2016 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>

typedef NS_ENUM(NSInteger, VZItemPropertyType) {
    
#pragma mark - Primitive Types
    
    VZItemPropertyTypeInt = 0,
//    VZItemPropertyTypeShort = 1,
//    VZItemPropertyTypeLong = 2,
//    VZItemPropertyTypeLongLong = 3,
//    VZItemPropertyTypeUnsignedInt = 4,
//    VZItemPropertyTypeUnsignedLong = 5,
//    VZItemPropertyTypeUnsignedLongLong = 6,
    VZItemPropertyTypeFloat = 7,
    VZItemPropertyTypeDouble = 8,
    VZItemPropertyTypeBool = 9,
    VZItemPropertyTypeChar = 10,
    
#pragma mark - Object Types
    
    VZItemPropertyTypeString = 11,
    VZItemPropertyTypeNumber = 12,
    VZItemPropertyTypeData = 13,
    VZItemPropertyTypeAny = 14,
    VZItemPropertyTypeDate = 15,
    
#pragma mark - Linked Object Types
   
    VZItemPropertyTypeDictionary = 16,
    VZItemPropertyTypeArray = 17,
    VZItemPropertyTypeObject = 18,
    VZItemPropertyTypeItem = 19,
};

@interface VZItemProperty : NSObject

@property (nonatomic, strong, readonly) NSString *propertyName;
@property (nonatomic, assign, readonly) VZItemPropertyType propertyType;
@property (nonatomic, strong, readonly) NSString *propertyClass;

- (instancetype)initWithPropertyName:(NSString *)propertyName
                        objcProperty:(objc_property_t)objcProperty;

@end
