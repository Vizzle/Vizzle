//
//  NSString+VZHTTPNetworkUtil.h
//  VZLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VZHTTPNVZworkUtil)

- (NSString*)VZHTTP_base64Encoding;
- (NSString*)VZHTTP_escapedQueryStringKeyFromStringWithEncoding:(NSStringEncoding)encoding;
- (NSString*)VZHTTP_escapedQueryStringValueFromStringWithEncoding:(NSStringEncoding)encoding;

@end
