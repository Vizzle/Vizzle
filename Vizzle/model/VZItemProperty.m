//
//  VZItemProperty.m
//  VizzleListExample
//
//  Created by Yulin Ding on 30/11/2016.
//  Copyright © 2016 VizLab. All rights reserved.
//

#import "VZItemProperty.h"

@implementation VZItemProperty

- (instancetype)initWithPropertyName:(NSString *)propertyName
                        objcProperty:(objc_property_t)objcProperty {
    if (self = [super init]) {
        _propertyName = propertyName;
        
        const char* attr = property_getAttributes(objcProperty);
        NSString *propAttr = [NSString stringWithUTF8String:attr];
        
        //remove "T"
        propAttr = [propAttr substringFromIndex:1];
        
        //get @encode(),@property,V_
        NSArray *attributes = [propAttr componentsSeparatedByString:@","];
        
        //get @encode()
        NSString *typeAttr = attributes[0];
        const char *typeAttrChar = [typeAttr UTF8String];
        
        NSString *encodeCodeStr = [typeAttr substringToIndex:1];
        const char *encodeCode = [encodeCodeStr UTF8String];
        char typeEncoding = *encodeCode;
        
        switch (typeEncoding) {
            case '@': //object
            {
                static const char arrayPrefix[] = "@\"NSArray<";
                static const int arrayPrefixLen = sizeof(arrayPrefix) - 1;
                
                if (typeAttrChar[1] == '\0') {
                    // string is "@"
                    _propertyType = VZItemPropertyTypeAny;
                } else if (strncmp(typeAttrChar, arrayPrefix, arrayPrefixLen) == 0) {
                    _propertyType = VZItemPropertyTypeArray;
                    NSString *className = [[NSString alloc] initWithBytes:typeAttrChar + arrayPrefixLen
                                                                length:strlen(typeAttrChar + arrayPrefixLen) - 2 // drop trailing >"
                                                              encoding:NSUTF8StringEncoding];
                    
                    Class propertyClass = NSClassFromString(className);
                    if (propertyClass) {
                        _propertyClass = NSStringFromClass(propertyClass);
                    }
                } else if (strcmp(typeAttrChar, "@\"NSString\"") == 0) {
                    _propertyType = VZItemPropertyTypeString;
                } else if (strcmp(typeAttrChar, "@\"NSNumber\"") == 0) {
                    _propertyType = VZItemPropertyTypeNumber;
                } else if (strcmp(typeAttrChar, "@\"NSDate\"") == 0) {
                    _propertyType = VZItemPropertyTypeDate;
                } else if (strcmp(typeAttrChar, "@\"NSData\"") == 0) {
                    _propertyType = VZItemPropertyTypeData;
                } else if (strcmp(typeAttrChar, "@\"NSDictionary\"") == 0) {
                    _propertyType = VZItemPropertyTypeDictionary;
                } else if (strcmp(typeAttrChar, "@\"NSArray\"") == 0) {
                    _propertyType = VZItemPropertyTypeArray;
                } else {
                    _propertyType = VZItemPropertyTypeObject;
                    
                    Class propertyClass = nil;
                    if (typeAttr.length >= 3) {
                        NSString* className = [typeAttr substringWithRange:NSMakeRange(2, typeAttr.length-3)];
                        propertyClass = NSClassFromString(className);
                    }
                    
                    if (propertyClass) {
                        if ([propertyClass isSubclassOfClass:[VZItem class]]) {
                            _propertyType = VZItemPropertyTypeItem;
                        }
                        _propertyClass = NSStringFromClass(propertyClass);
                    }
                    
                }
                
                break;
            }
            case 'i': // int
            case 's': // short
            case 'l': // long
            case 'q': // long long
            case 'I': // unsigned int
            case 'S': // unsigned short
            case 'L': // unsigned long
            case 'Q': // unsigned long long
                _propertyType = VZItemPropertyTypeInt;
                break;
            case 'f': // float
                _propertyType = VZItemPropertyTypeFloat;
                break;
            case 'd': // double
                _propertyType = VZItemPropertyTypeDouble;
                break;
            case 'B': // BOOL
                _propertyType = VZItemPropertyTypeBool;
                break;
            case 'c': // char
            case 'C': // unsigned char
                _propertyType = VZItemPropertyTypeChar;
                break;
            default:
                break;
        }
    }
    
    return self;
}

@end
