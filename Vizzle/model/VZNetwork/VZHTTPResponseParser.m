//
//  VZHTTPResponseParser.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import "VZHTTPResponseParser.h"
#import "VZHTTPNetworkConfig.h"
@implementation VZHTTPResponseParser


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

+ (instancetype) parserWithConfig:(VZHTTPResponseConfig)config
{
    if (config.responseType == VZHTTPNetworkResponseTypeJSON)
    {
        return [VZHTTPJSONResponseParser new];
    }
    else if(config.responseType == VZHTTPNetworkResponseTypeXML)
    {
        return [VZHTTPXMLResponseParser new];
    }
    else
        return [[self class] new];
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        self.stringEncoding = NSUTF8StringEncoding;
        self.validStatusCode = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        self.validContentTypes = nil;
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (BOOL)isResponseValid:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        return NO;
    }
    
    bool bStatusCode = false;
    bool bContentType = false;
    
    //验证statuscode
    NSUInteger statusCode = [response statusCode];
    if (self.validStatusCode &&  [self.validStatusCode containsIndex:statusCode]) {
        bStatusCode = true;
    }
    else
    {
        bStatusCode = false;
        if (error) {
            * error = [NSError errorWithDomain:@"VZHTTPNetworkingErrorDomain" code:NSURLErrorBadServerResponse userInfo:nil];
        }
    }
    
    
    //验证MIME type
    NSString* MIME = [response MIMEType];
    if (self.validContentTypes && [self.validContentTypes containsObject:MIME]) {
        bContentType = true;
    }
    else
    {
        bContentType = false;
        if (error) {
            * error = [NSError errorWithDomain:@"VZHTTPNetworkingErrorDomain" code:NSURLErrorCannotDecodeContentData userInfo:nil];
        }
    }
    
    return bStatusCode && bContentType;
    
}

- (id)parseResponse:(NSHTTPURLResponse* )aResponse data:(NSData*)aData error:(NSError *__autoreleasing *)aError
{
    return nil;
}

@end


@implementation VZHTTPJSONResponseParser

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.readingOptions = 0;
        self.validContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

- (id)parseResponse:(NSHTTPURLResponse* )aResponse data:(NSData*)aData error:(NSError *__autoreleasing *)aError
{
    if (![self isResponseValid:aResponse data:aData error:aError]) {
        return nil;
    }

    NSString *responseString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    if (responseString && ![responseString isEqualToString:@" "]) {

        aData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (aData)
        {
            if ([aData length] > 0) {
                return [NSJSONSerialization JSONObjectWithData:aData options:self.readingOptions error:aError];
            }
            else {
                return nil;
            }
        }
        else
        {
            if (aError) {
                *aError = [[NSError alloc] initWithDomain:@"VZHTTPNetworkingErrorDomain" code:NSURLErrorCannotDecodeContentData userInfo:nil];
            }
        }
    }
    
    return nil;
}

@end

@implementation VZHTTPXMLResponseParser



@end