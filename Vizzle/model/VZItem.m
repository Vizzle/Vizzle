//
//  VZItem.m
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZItem.h"
#import "NSDictionary+VZItem.h"
#import "VZValueTransformer.h"
#include <objc/runtime.h>

//cached property keys
static void *VZItemCachedPropertyInfos = &VZItemCachedPropertyInfos;

static id VZValueFromInvocation(id object, SEL selector) {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
    invocation.target = object;
    invocation.selector = selector;
    [invocation invoke];
    
    //http://stackoverflow.com/questions/22018272/nsinvocation-returns-value-but-makes-app-crash-with-exc-bad-access
    __unsafe_unretained id result = nil;
    [invocation getReturnValue:&result];
    
    return result;
}

//weak check
static id VZTransformNormalValueForClass(id val, NSString *className) {
    id ret = val;
    
    Class valClass = [val class];
    Class kls = nil;
    if (className.length > 0) {
        kls = NSClassFromString(className);
    }
    
    if (!kls || !valClass) {
        ret = nil;
    } else if (![kls isSubclassOfClass:[val class]] &&
               ![valClass isSubclassOfClass:kls]) {
        ret = nil;
    }
    
    return ret;
}

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

@implementation VZItem

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

+ (NSDictionary *)propertyInfos
{
    return [self propertyInfosInternal:self];
}

+ (NSSet* )propertyNames
{
    return [self propertyNamesInternal:[self class]];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary dictionaryWithObjects:[[self propertyNames] allObjects]
                                       forKeys:[[self propertyNames] allObjects]];
}

+ (VZItemProperty *)propertyInfoByPropertyKey:(NSString *)propertyKey
{
    return [[self propertyInfos] vz_valueForJSONKeyPath:propertyKey];
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public  API

+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary {
    VZItem *item = [[self class] new];
    [item autoKVCBinding:dictionary];
    
    return item;
}

+ (NSArray *)itemsWithArray:(NSArray *)array {
    NSMutableArray *items = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [items addObject:[self itemWithDictionary:obj]];
    }];
    
    return [NSArray arrayWithArray:items];
}

- (void)autoKVCBinding:(NSDictionary* )dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *properties = [self.class propertyInfos];
    
    NSDictionary *JSONKeyPathsByPropertyKey = [self.class JSONKeyPathsByPropertyKey];
    
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        VZItemProperty *property = (VZItemProperty *)obj;
        
        NSString *propertyName = property.propertyName;
        NSString *propKeyPath = propertyName;
        
        if ([JSONKeyPathsByPropertyKey objectForKey:propertyName]) {
            propKeyPath = [JSONKeyPathsByPropertyKey objectForKey:propertyName];
        }
        
        //get value from dictionary
        id val = [dictionary vz_valueForJSONKeyPath:propKeyPath];
        
        if (val == nil || val == [NSNull null]) {
            return;
        }
        
        NSValueTransformer *transformer = [self.class transformerForPropertyName:propertyName];
        
        if (transformer) {
            val = [transformer transformedValue:val];
        }
        
        val = [self.class transformValue:val
                             forProperty:property];
        
        if (val != nil &&
            val != [NSNull null]) {
            //the NSNumber will unbox here
            [self setValue:val forKey:propertyName];
        }
        
    }];
}

- (void)autoMapTo:(id)object
{
   
    NSMutableSet *sets = [NSMutableSet new];
    NSSet *objectPropertyNames = [[self class] propertyNamesInternal:[object class]];
    [sets addObjectsFromArray:[objectPropertyNames allObjects]];

    NSDictionary *properties = [self.class propertyInfos];
    
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        VZItemProperty *property = (VZItemProperty *)obj;
        NSString *propertyName = property.propertyName;
        
        id val = nil;
        if ([sets containsObject:propertyName]) {
            val = [object valueForKey:propertyName];
        }
        
        if (val == nil ||
            val == [NSNull null]) {
            return;
        }
        
        NSValueTransformer *transformer = [self.class transformerForPropertyName:propertyName];
        
        if (transformer) {
            val = [transformer transformedValue:val];
        }
        
        val = [self.class transformValue:val
                             forProperty:property];
        
        if (val != nil &&
            val != [NSNull null]) {
            [self setValue:val forKey:propertyName];
        }
        
    }];
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
+ (id)transformValue:(id)val
         forProperty:(VZItemProperty *)property
{
    VZItemPropertyType propertyType = property.propertyType;
    NSString *propertyClassName = property.propertyClass;
    Class propertyClass = nil;
    
    if (property.propertyClass.length > 0) {
        propertyClass = NSClassFromString(propertyClassName);
    }
    
    switch (propertyType) {
        case VZItemPropertyTypeInt:
        case VZItemPropertyTypeFloat:
        case VZItemPropertyTypeDouble:
        case VZItemPropertyTypeBool:
        {
            if ([val isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                val = [numberFormatter numberFromString:val];
            } else {
                val = VZTransformNormalValueForClass(val, NSStringFromClass([NSNumber class]));
            }
            break;
        }
        case VZItemPropertyTypeChar:
        {
            if ([val isKindOfClass:[NSString class]]) {
                char firstCharacter = [val characterAtIndex:0];
                val = [NSNumber numberWithChar:firstCharacter];
            } else {
                val = VZTransformNormalValueForClass(val, NSStringFromClass([NSNumber class]));
            }
            break;
        }
        case VZItemPropertyTypeString:
        {
            if ([val isKindOfClass:[NSNumber class]]) {
                val = [val stringValue];
            } else {
                val = VZTransformNormalValueForClass(val, NSStringFromClass([NSString class]));
            }
            break;
        }
        case VZItemPropertyTypeNumber:
        {
            if ([val isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                val = [numberFormatter numberFromString:val];
            } else {
                val = VZTransformNormalValueForClass(val, NSStringFromClass([NSNumber class]));
            }
            break;
        }
        case VZItemPropertyTypeData:
        {
            val = VZTransformNormalValueForClass(val, NSStringFromClass([NSData class]));
            break;
        }
        case VZItemPropertyTypeAny:
            break;
        case VZItemPropertyTypeDate:
        {
            val = VZTransformNormalValueForClass(val, NSStringFromClass([NSDate class]));
            break;
        }
        case VZItemPropertyTypeDictionary:
        {
            val = VZTransformNormalValueForClass(val, NSStringFromClass([NSDictionary class]));
            break;
        }
        case VZItemPropertyTypeArray:
        {
            if (propertyClass && [propertyClass isSubclassOfClass:[VZItem class]]) {
                val = [propertyClass itemsWithArray:val];
            } else {
                val = VZTransformNormalValueForClass(val, NSStringFromClass([NSArray class]));
            }
            break;
        }
        case VZItemPropertyTypeObject:
        case VZItemPropertyTypeItem:
        {
            if (propertyClass) {
                if ([propertyClass isSubclassOfClass:[VZItem class]] &&
                    [val isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *oldVal = val;
                    val = [propertyClass new];
                    [val autoKVCBinding:oldVal];
                } else {
                    val = VZTransformNormalValueForClass(val, propertyClassName);
                }
            }
            break;
        }
        default:
            break;
    }
    
    return val;
}

+ (NSDictionary *)propertyInfosInternal:(Class)class {
    NSDictionary *cachedInfos = objc_getAssociatedObject(class, VZItemCachedPropertyInfos);
    
    if (cachedInfos != nil) {
        return cachedInfos;
    }
    
    NSMutableDictionary *ret = [@{} mutableCopy];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([class class], &propertyCount);
    Class superClass = class_getSuperclass([class class]);
    
    if (superClass &&
        ![NSStringFromClass(superClass) isEqualToString:@"VZItem"]) {
        NSDictionary *superProperties = [superClass propertyInfos];
        [ret addEntriesFromDictionary:superProperties];
    }
    
    for(int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        //get property name
        const char *propName = property_getName(property);
        //chect value for key is not nil!!
        NSString *propertyName = @(propName);
        
        VZItemProperty *propertyInfo = [[VZItemProperty alloc] initWithPropertyName:propertyName objcProperty:property];
        [ret setValue:propertyInfo forKey:propertyName];
    }
    
    free(properties);
    
    objc_setAssociatedObject(class, VZItemCachedPropertyInfos, ret, OBJC_ASSOCIATION_COPY);
    
    return ret;
}

+ (NSSet *)propertyNamesInternal:(Class)class
{
    NSDictionary *ret = [self propertyInfosInternal:class];
    return [NSSet setWithArray:[ret allKeys]];
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

+ (NSValueTransformer *)transformerForPropertyName:(NSString *)propertyName
{
    SEL selector = NSSelectorFromString([propertyName stringByAppendingString:@"JSONTransformer"]);
    
    NSValueTransformer *transformer = nil;
    if ([self respondsToSelector:selector]) {
        transformer = VZValueFromInvocation(self, selector);
    }
    
    return transformer;
}

@end
