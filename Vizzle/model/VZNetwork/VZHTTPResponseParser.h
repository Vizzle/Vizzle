//
//  VZHTTPResponseParser.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VZHTTPResponseParser : NSObject

@property(nonatomic,assign) NSStringEncoding stringEncoding;


- (BOOL)isResponseValid:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError *__autoreleasing *)error;

- (id)parseResponse:(NSHTTPURLResponse* )aResponse data:(NSData*)aData error:(NSError *__autoreleasing *)aError;

@end

@interface VZHTTPJSONResponseParser : VZHTTPResponseParser

@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

@end

@interface VZHTTPXMLResponseParser : VZHTTPResponseParser


@end
