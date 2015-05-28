//
//  VZHTTPURLConnectionOperation.m
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import "VZHTTPURLConnectionOperation.h"
#import "VZHTTPNetworkSecurity.h"




@interface VZHTTPURLConnectionOperation()
{

}
@property (readwrite, nonatomic, strong) NSURLConnection *connection;
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@property (readwrite, nonatomic, strong) NSError* error;
@property (readwrite, nonatomic, strong) NSData *responseData;
@property (readwrite, nonatomic, copy)   NSString *responseString;
@property (readwrite, nonatomic, assign) NSStringEncoding responseStringEncoding;
@property (readwrite, nonatomic, assign) long long totalBytesRead;
@property (nonatomic, strong) VZHTTPNetworkSecurity* sercurity;

@end

@implementation VZHTTPURLConnectionOperation

@synthesize outputStream = _outputStream;


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setter

- (void)setInputStream:(NSInputStream *)inputStream {
   
    [self willChangeValueForKey:@"inputStream"];
    NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
    mutableRequest.HTTPBodyStream = inputStream;
    self.request = mutableRequest;
    [self didChangeValueForKey:@"inputStream"];
}

- (void)setOutputStream:(NSOutputStream *)outputStream {

    if (outputStream != _outputStream) {
        [self willChangeValueForKey:@"outputStream"];
        if (_outputStream) {
            [_outputStream close];
        }
        _outputStream = outputStream;
        [self didChangeValueForKey:@"outputStream"];
    }
}

- (void)setCompletionBlock:(void (^)(void))block
{
    [self.lock lock];
    
    if (!block) {
        [super setCompletionBlock:nil];
    }
    else
    {
        [super setCompletionBlock:^{
            
            block();
            [super setCompletionBlock:nil];
        }];
    }
    
    [self.lock unlock];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getter 


- (NSInputStream *)inputStream {
    return self.request.HTTPBodyStream;
}


- (NSOutputStream *)outputStream {
    if (!_outputStream) {
        _outputStream = [NSOutputStream outputStreamToMemory];
    }
    return _outputStream;
}

- (NSString *)responseString {
   
    [self.lock lock];
    if (!_responseString && self.response && self.responseData) {
        _responseString = [[NSString alloc] initWithData:self.responseData encoding:self.responseStringEncoding];
    }
    [self.lock unlock];
    
    return _responseString;
}

- (NSStringEncoding)responseStringEncoding {
    [self.lock lock];
    if (!_responseStringEncoding && self.response) {
        NSStringEncoding stringEncoding = NSUTF8StringEncoding;
        if (self.response.textEncodingName) {
            CFStringEncoding IANAEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)self.response.textEncodingName);
            if (IANAEncoding != kCFStringEncodingInvalidId) {
                stringEncoding = CFStringConvertEncodingToNSStringEncoding(IANAEncoding);
            }
        }
        
        _responseStringEncoding = stringEncoding;
    }
    [self.lock unlock];
    
    return _responseStringEncoding;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithRequest:(NSURLRequest *)urlRequest
{
    self = [super init];
    
    if (self) {
    
        NSParameterAssert(urlRequest);
    
        self.request = urlRequest;
        self.shouldUseCredentialStorage = YES;
        self.sercurity = [VZHTTPNetworkSecurity new];

        
        return self;

    
    }
    return self;
}


- (void)dealloc {
    
    if (_outputStream) {
        [_outputStream close];
        _outputStream = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public method



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSURLConnection delegate



- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if (self.authenticationChallengeBlock) {
        self.authenticationChallengeBlock(connection, challenge);
        return;
    }
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        //todo://
        if ([self.sercurity serverCanBeTrust:challenge.protectionSpace.serverTrust]) {
            
            NSURLCredential* credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        }
        else
        {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
    else
    {
        if ([challenge previousFailureCount] == 0) {
            if (self.credential) {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection __unused *)connection {
    return self.shouldUseCredentialStorage;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    if (self.redirectResponseBlock) {
        return self.redirectResponseBlock(connection, request, redirectResponse);
    } else {
        return request;
    }
}

/**
 upload body data
 */
- (void)connection:(NSURLConnection __unused *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.uploadProgressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.uploadProgressBlock((NSUInteger)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
}

- (void)connection:(NSURLConnection __unused *)connection
didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"[%@]-->RecvResponse:%@",self.class,[(NSHTTPURLResponse* )response allHeaderFields]);
    
    self.response = response;
    
    [self.outputStream open];
}

/**
 download data
 */

- (void)connection:(NSURLConnection __unused *)connection
    didReceiveData:(NSData *)data
{
    NSUInteger length = [data length];
    while (YES) {
        NSInteger totalNumberOfBytesWritten = 0;
        if ([self.outputStream hasSpaceAvailable]) {
            const uint8_t *dataBuffer = (uint8_t *)[data bytes];
            
            NSInteger numberOfBytesWritten = 0;
            while (totalNumberOfBytesWritten < (NSInteger)length) {
                numberOfBytesWritten = [self.outputStream write:&dataBuffer[0] maxLength:length];
                if (numberOfBytesWritten == -1) {
                    [self.connection cancel];
                    [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:self.outputStream.streamError];
                    return;
                } else {
                    totalNumberOfBytesWritten += numberOfBytesWritten;
                }
            }
            
            break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalBytesRead += length;
        
        if (self.downloadProgressBlock) {
            self.downloadProgressBlock(length, self.totalBytesRead, self.response.expectedContentLength);
        }
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection __unused *)connection {
    self.responseData = [self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    [self.outputStream close];
    
    [self operationDidFinish];
    
    self.connection = nil;
}

- (void)connection:(NSURLConnection __unused *)connection
  didFailWithError:(NSError *)error
{
    self.error = error;
    
    [self.outputStream close];
    
    [self operationDidFinish];
    
    self.connection = nil;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSLog(@"will Cache response:%@",cachedResponse);
    if (self.cacheResponseBlock)
    {
        return self.cacheResponseBlock(connection, cachedResponse);
    }
    else
    {
        if ([self isCancelled]) {
            return nil;
        }
        
        return cachedResponse;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - subclassing  method

- (void)operationDidStart
{
    [super operationDidStart];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    for (NSString *runLoopMode in self.runLoopModes) {
        [self.connection scheduleInRunLoop:runLoop forMode:runLoopMode];
        [self.outputStream scheduleInRunLoop:runLoop forMode:runLoopMode];
    }

    [self.connection start];

}

- (void)operationDidFinish
{
    [super operationDidFinish];
}

- (void)operationDidCancel
{
    [super operationDidCancel];
    
    NSDictionary *userInfo = nil;
    if ([self.request URL]) {
        userInfo = [NSDictionary dictionaryWithObject:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
    }
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
    
    if (![self isFinished] && self.connection) {
        [self.connection cancel];
        
        //this will be called on the secondary thread
        [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:error];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method



@end
