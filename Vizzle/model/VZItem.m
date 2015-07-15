//
//  VZItem.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZItem.h"
#include <objc/runtime.h>
#import "VZListItem.h"

//cached property keys
static void *VZItemCachedPropertyKeysKey = &VZItemCachedPropertyKeysKey;

typedef NS_ENUM(int , ENCODE_TYPE)
{
    KUnknown = -1,
    kValue=0,
    kStruct,
    kUnion,
    kPointer,//^
    kObject, //@
    kVoid, //v
    kClass, //#
    kSEL, //:
    KCharacterString //*
};

@implementation VZItem
{
    enum ENCODE_TYPE _encodeType;
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - nscoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - nscopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[self class]allocWithZone:zone];
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class API
/**
 *  VZMV* => 1.2
 *
 *  @return 所有property的名称
 */
+ (NSSet* )propertyNames
{
    return [self propertyNamesInternal:[self class]];
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public  API

static inline ENCODE_TYPE getEncodeType(const char* typeStr);
- (void)autoKVCBinding:(NSDictionary* )dictionary
{
    Class clz = [self class];
    
    while (clz != [VZItem class])
    {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([clz class], &outCount);
        
        for(i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            
            //get property name
            const char *propName = property_getName(property);
            
            //heap allocation
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            
            //get propertyClass
            Class propertyClass = nil;
            const char* attr = property_getAttributes(property);

            size_t attr_len = strlen(attr);
            char attrWithoutT[attr_len];
            memset(attrWithoutT, 0, sizeof(attrWithoutT));
            attrWithoutT[attr_len-1] = '\0';
            strncpy(attrWithoutT, attr+1, attr_len-1);

            //faster than using NSString
            char* firstAttr = strtok(attrWithoutT, ",");

            ENCODE_TYPE encodeType = getEncodeType(firstAttr);
            
            //只处理object类型
            if (encodeType == kObject) {

                size_t l = strlen(firstAttr);
                l -= 3;
                char classStr[l+1];
                memset(classStr, 0, l);
                classStr[l]='\0';
                strncpy(classStr, firstAttr+2, l);

                //heap allocation
                NSString* tmp = [NSString stringWithCString:classStr encoding:NSUTF8StringEncoding];
                propertyClass = NSClassFromString(tmp);
                
                if (!propertyClass) {
                    continue;
                }
                else
                {
                    //get value from dictionary
                    id val = dictionary[propertyName];
                    
                    if (val && [val isKindOfClass:propertyClass]) {
                        
                        [self setValue:val forKey:propertyName];
                        
                    }
                    else
                    {
                        [self setValue:nil forKey:propertyName];
                    }
                }
            }
            else
            {
                [self setValue:nil forKey:propertyName];
            }
            
            
        }
        free(properties);
        
        //递归父类
        clz = [clz superclass];
    }
}

- (void)autoMapTo:(id)object
{
    NSSet* itemProperties = [[self class] propertyNamesInternal:[self class]];
    NSSet* objectProperties = [[ self class] propertyNamesInternal:[object class]];
    
    for (NSString* propertyName in itemProperties) {
        
        if ([objectProperties containsObject:propertyName]) {
            
            id val = [object valueForKey:propertyName];
            [self setValue:val forKey:propertyName];
        }
        else
            [self setValue:nil forKey:propertyName];
    }
}

- (NSDictionary* )toDictionary
{
    return [self dictionaryWithValuesForKeys:self.class.propertyNames.allObjects];
}

- (NSString* )description
{
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.toDictionary];
}




////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private tool  API

/**
 *  确定@encode的类型
 *
 *  VZMV* => 1.2
 *
 *  @return @encode的返回值
 */
static inline ENCODE_TYPE getEncodeType(const char* typeStr)
{
    ENCODE_TYPE ret = KUnknown;
    char type = typeStr[0];
    
    //values
    if (type == 'c' || type == 'C' ||
        type == 'd' ||
        type == 'l' || type == 'L' ||
        type == 's' || type == 'S' ||
        type == 'b' || type == 'B' ||
        type == 'i' || type == 'I' ||
        type == 'q' || type == 'Q' ||
        type == 'f'
        )
    {
        ret = kValue;
    }
    
    //struct
    if (type == '{') {
        ret = kStruct;
    }
    
    //union
    else if (type == '('){
        ret = kUnion;
    }
    
    //pointer
    else if (type == '^'){
        ret = kPointer;
    }
    //object
    else if (type == '@')
    {
        ret = kObject;
    }
    else if(type == '#')
    {
        ret = kClass;
    }
    else if (type == 'v')
    {
        ret = kVoid;
    }
    else if (type == ':')
    {
        ret = kSEL;
    }
    else if (type == '*')
    {
        ret =  KCharacterString;
    }
    else
        ret = KUnknown;
    
    return ret;
    
}

+ (NSSet* )propertyNamesInternal:(Class) class
{
    NSSet *cachedKeys = objc_getAssociatedObject(class, VZItemCachedPropertyKeysKey);
    if (cachedKeys.count > 0 )
        return cachedKeys;
    
    NSMutableSet* set = [NSMutableSet new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([class class], &outCount);
    
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        
        //get property name
        const char *propName = property_getName(property);
        
        //chect value for key is not nil!!
        NSString *propertyName = @(propName);
        
        [set addObject:propertyName];
        
    }
    
    //cache sets
    objc_setAssociatedObject(class, VZItemCachedPropertyKeysKey, set, OBJC_ASSOCIATION_COPY);
    
    
    free(properties);
    
    return set;
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KVC hooks

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   
}

- (void)setNilValueForKey:(NSString *)key
{

}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
@end
