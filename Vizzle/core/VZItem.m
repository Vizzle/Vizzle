//
//  VZItem.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZItem.h"
#include <objc/runtime.h>

//cached property keys
static void *VZItemCachedPropertyNamesKey = &VZItemCachedPropertyNamesKey;
static void *VZItemCachedPropertiesKey = &VZItemCachedPropertiesKey;

typedef NS_ENUM(int , ENCODE_TYPE)
{
    KUnknown = -1,
    kValue=0,//
    kStruct,//{
    kUnion,//(
    kPointer,//^
    kObject, //@
    kVoid, //v
    kClass, //#
    kSEL, //:
    KCharacterString //*
};

static inline ENCODE_TYPE getEncodeType(const char* typeStr);
static inline Class getPropertyClass(objc_property_t property);

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

+ (NSSet* )propertyNames
{
    return [self propertyNamesInternal:[self class]];
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public  API

- (void)autoKVCBinding:(NSDictionary* )dictionary
{
    Class clz = [self class];
    while (clz != [VZItem class]){
        NSArray* properties = [[self class] properties:clz];
        for (NSValue* value in properties) {
            objc_property_t property;
            [value getValue:&property];
            
            Class propertyClass = getPropertyClass(property);
            
            if (!propertyClass) {
                continue;
            }
            else
            {
                //get propertyName
                const char* propertyNameStr = property_getName(property);
                NSString* propertyName = [NSString stringWithCString:propertyNameStr  encoding:NSUTF8StringEncoding];
                id val = dictionary[propertyName];
                
                if (val && [val isKindOfClass:propertyClass]) {
                    [self setValue:val forKey:propertyName];
                    
                }
//                else
//                {
//                    [self setValue:nil forKey:propertyName];
//                }

            }
            

        }
        //递归父类
        clz = [clz superclass];
    }
}

- (void)autoMapTo:(id)object
{
   
    NSMutableSet* sets = [NSMutableSet new];
    Class objectClz = [object class];
    while (objectClz != [NSObject class])
    {
        NSSet* objectPropertyNames = [[ self class] propertyNamesInternal:objectClz];
        [sets addObjectsFromArray:[objectPropertyNames allObjects]];
        objectClz = [objectClz superclass];
    }

    
    Class clz = [self class];
    while (clz != [VZItem class])
    {
        NSArray* properties = [[self class] properties:clz];
        
        for (NSValue* value in properties)
        {
            
            objc_property_t property;
            [value getValue:&property];
            
            Class propertyClass = getPropertyClass(property);
            
            if (!propertyClass) {
                continue;
            }
            else
            {
                //get propertyName
                const char* propertyNameStr = property_getName(property);
                NSString* propertyName = [NSString stringWithCString:propertyNameStr  encoding:NSUTF8StringEncoding];
               
                if ([sets containsObject:propertyName]) {
                    
                    id val = [object valueForKey:propertyName];
                    if (val && [val isKindOfClass:propertyClass]) {
                        
                        [self setValue:val forKey:propertyName];
                    }
//                    else
//                    {
//                        [self setValue:nil forKey:propertyName];
//                    }
                    
                }
//                else
//                {
//                    [self setValue:nil forKey:propertyName];
//                }
                
            }
        }
    
        clz = [clz superclass];
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


static inline Class getPropertyClass(objc_property_t property)
{
    Class propertyClass = nil;
    const char* attr = property_getAttributes(property);
    
    size_t attr_len = strlen(attr);
    char attrWithoutT[attr_len];
    memset(attrWithoutT, 0, sizeof(attrWithoutT));
    attrWithoutT[attr_len-1] = '\0';
    strncpy(attrWithoutT, attr+1, attr_len-1);
    
    //faster than using NSString
    char* firstAttr = strtok(attrWithoutT, ",");

    //只处理object类型
    if (getEncodeType(firstAttr) == kObject) {
        
        size_t l = strlen(firstAttr);
        l -= 3;
        char classStr[l+1];
        memset(classStr, 0, l);
        classStr[l]='\0';
        strncpy(classStr, firstAttr+2, l);
        
        //heap allocation
        NSString* tmp = [NSString stringWithCString:classStr encoding:NSUTF8StringEncoding];
        propertyClass = NSClassFromString(tmp);
        return propertyClass;
        
    }
    else
    {
        return nil;
    }
}

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
        ){
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

+ (NSArray* )properties:(Class)class
{
    NSArray* cachedProperties = objc_getAssociatedObject(class,VZItemCachedPropertiesKey);
    if (cachedProperties) {
        return cachedProperties;
    }
    
    NSMutableArray* mutableList = [NSMutableArray new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([class class], &outCount);
    
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSValue* value = [NSValue value:&property withObjCType:@encode(objc_property_t)];
        [mutableList addObject:value];
    }
    NSArray* list = [mutableList copy];

    objc_setAssociatedObject(class, VZItemCachedPropertiesKey, list, OBJC_ASSOCIATION_COPY);
    
    free(properties);
    
    return list;
}

+ (NSSet* )propertyNamesInternal:(Class) class
{
    NSSet *cachedKeys = objc_getAssociatedObject(class, VZItemCachedPropertyNamesKey);
    if (cachedKeys.count > 0 )
        return cachedKeys;
    
    NSMutableSet* set = [NSMutableSet new];
    
    NSArray* properties = [[self class] properties:class];
    
    for (NSValue* value in properties) {
        
        objc_property_t property;
        [value getValue:&property];
        const char *propName = property_getName(property);
        NSString *propertyName = @(propName);
        [set addObject:propertyName];
        
    }
    //cache sets
    objc_setAssociatedObject(class, VZItemCachedPropertyNamesKey, set, OBJC_ASSOCIATION_COPY);

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
