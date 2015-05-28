//
//  NSString+VZHTTPNVZworkUtil.m
//  VZLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import "NSString+VZHTTPNetworkUtil.h"

@implementation NSString (VZHTTPNVZworkUtil)

- (NSString*)VZHTTP_base64Encoding
{
    NSData *data = [NSData dataWithBytes:[self UTF8String] length:[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];


}
- (NSString*)VZHTTP_escapedQueryStringKeyFromStringWithEncoding:(NSStringEncoding)encoding
{
    NSString *  escapedString = @":/?&=;+!@#$()',*";
    NSString *  pairKey = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, (__bridge CFStringRef)pairKey, (__bridge CFStringRef)escapedString, CFStringConvertNSStringEncodingToEncoding(encoding));
}
- (NSString*)VZHTTP_escapedQueryStringValueFromStringWithEncoding:(NSStringEncoding)encoding
{
    NSString *  escapedString = @":/?&=;+!@#$()',*";
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)escapedString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
