//
//  VZHTTPResponseParser.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>

struct responseConfig;
typedef struct responseConfig VZHTTPResponseConfig;


@interface VZHTTPResponseParser : NSObject

/**
 Creates and returns a parser with default configuration.
 */
+ (instancetype)parserWithConfig:(VZHTTPResponseConfig)config;

/**
 See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 */
@property (nonatomic, strong) NSIndexSet *validStatusCode;

/**
 The acceptable MIME types for responses.
 */
@property (nonatomic, strong) NSSet *validContentTypes;
/**
 *  encoding type : default is UTF8
 */
@property(nonatomic,assign) NSStringEncoding stringEncoding;


- (BOOL)isResponseValid:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError *__autoreleasing *)error;

- (id)parseResponse:(NSHTTPURLResponse* )aResponse data:(NSData*)aData error:(NSError *__autoreleasing *)aError;

@end

@interface VZHTTPJSONResponseParser : VZHTTPResponseParser
/**
 *  json decoding options
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;


@end

@interface VZHTTPXMLResponseParser : VZHTTPResponseParser


@end
