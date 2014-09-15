//
//  TBCitySBMTOPRequest.m
//  iCoupon
//
//  Created by moxin.xt on 14-5-5.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBMTOPRequest.h"
#import "TBCityServiceContext.h"
#import "TBCityService.h"
#import <TBSDK_Framework/TBSDK_Framework.h>


@interface TBCitySBMTOPRequest()
{
 
}

//重登
@property(nonatomic,strong) TBCityService* service;
@property(nonatomic,strong) MTOPRequest* mtopRequest;

@end

@implementation TBCitySBMTOPRequest

@synthesize useCache = _useCache;
@synthesize useAuth = _useAuth;
@synthesize usePost = _usePost;
@synthesize showLogin = _showLogin;
@synthesize apiCacheTimeOutSeconds = _apiCacheTimeOutSeconds;
@synthesize delegate = _delegate;
@synthesize responseString = _responseString;
@synthesize responseObject = _responseObject;

- (void)dealloc {
    
    NSLog(@"[%@]-->dealloc",self.class);
    [[TBCityAuthenticationCenter sharedCenter] cancelAuthenticationsWithService:self.service];
    [self cancel];
}

- (void)addParams:(NSDictionary* )aParams forKey:(NSString*)key
{
    if ([key isEqualToString:@"data"]) {
        
        [aParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            [self.mtopRequest addParam:obj forKey:key];
            
        }];
    }
    
    
    if ([key isEqualToString:@"business"]) {
        
        [aParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            [self.mtopRequest addTopParam:obj forKey:key];
            
        }];
    }
    
}

- (void)addBodyData:(NSDictionary* )aData forKey:(NSString* )key
{
    [aData enumerateKeysAndObjectsUsingBlock:^(id name, id obj, BOOL *stop) {

        NSAssert([obj isKindOfClass:[NSData class]], @"POST Data must be NSData class");
        
        [self.mtopRequest addData:obj withFileName:name forKey:key];
        
        
    }];
}


- (void)initRequestWithBaseURL:(NSString *)url
{
    self.mtopRequest = nil;
    self.mtopRequest.delegate = nil;

    if (!self.service) {
        self.service = [TBCityService new];
    }

    //SBMVC => 1.1 : SAVE THE CONTEXT
    if (self.useAuth && self.showLogin) {
        
        __block __weak typeof(self) blockSelf = self;
        
        //create context
        void (^serviceBlock)(NSString* ,TBCityServiceContext* ) = ^(NSString* actionIdentifier, TBCityServiceContext* serviceContext){
            if (serviceContext) {
                [blockSelf.actionIdentifiers addObject:actionIdentifier];
            }
            //send request
            [blockSelf.mtopRequest sendRequest];
            
        };
        TBCityServiceContext *serviceContext = [[TBCityServiceContext alloc] init];
        serviceContext.serviceActionBlock =serviceBlock;
        
        [[TBCityAuthenticationCenter sharedCenter] authenticateWithService:blockSelf.service serviceContext:serviceContext];
    
    }
    //create mtop request
    self.mtopRequest = [[MTOPRequest alloc]initWithMethod:url];
    self.mtopRequest.delegate = self;
    self.mtopRequest.usePOST = self.usePost;
    self.mtopRequest.needEcodeSign = self.useAuth;
    self.mtopRequest.useApiCache = self.useCache;
    
    /**
     *  SBMVC : v=> 1.2 POST 超时时间为15s
     */
    if (self.usePost) {
        self.mtopRequest.timeOutSeconds = 20.0f;
    }
    else
        self.mtopRequest.timeOutSeconds = 8.0f;

    
    [self setTOPRequestSelectors:self.mtopRequest];
  

 
}
- (void)load
{
    [self.mtopRequest sendRequest];
    
    //for debug
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBRequestLog" object:nil userInfo:@{@"url": self.mtopRequest.mtopService.tbsdkRequest.url?:[NSNull null]}];
}
- (void)cancel
{
    [self.mtopRequest cancel];
    self.mtopRequest.delegate = nil;
    self.delegate = nil;
}


- (void)requestDidStartLoad:(id)request {
    
    [super requestDidStartLoad:request];
    
    [self requestDidChangeWithNotificationName:kTBCityServiceActionWillStartNotification error:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
        [_delegate requestDidStartLoad:self];
    }
}

- (void)requestDidFinishLoad:(MTOPRequest *)request {
    [super requestDidFinishLoad:request];
    
    /**
     *  SBMVC => 1.2:
     */
    _responseObject = request.responseJSON;
    _responseString = request.responseString;
    
    [self requestDidChangeWithNotificationName:kTBCityServiceActionDidFinishNotification error:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [_delegate requestDidFinish:request.responseJSON];
    }
    
    //for debug
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBResponseLog" object:nil userInfo:@{@"json": request.responseString ?:@"responseString为空"}];
}

- (void)requestDidLoadFailed:(MTOPRequest *)request{
    
    [super requestDidLoadFailed:request];
    
    /**
     *  SBMVC => 1.2:
     */
    _responseObject = request.responseJSON;
    _responseString = request.responseString;
    
    
    /**
     *  SBMVC => 1.2:超时错误
     */
    NSError* err = request.responseError;
    if (!err) {
        
        TBErrorResponse *error = [[TBErrorResponse alloc] init];
        error.code = @"FAIL";
        error.msg = @"小二很忙，系统很累，请稍后重试";
        request.responseError = error;
    }
    
    
    
    [self requestDidChangeWithNotificationName:kTBCityServiceActionDidFinishNotification error:err];
    
    /**
     * SBMVC => 1.1 : 
     *
     * @Discussion :
     * 如果是sid失效的error，那么如果useAuth = yes && showlogin = yes 那么不回调
     *
     */
//    if ([request.responseError.msg isEqualToString:@"对不起，您的登录信息已经过期"]) {
//        return;
//    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
        [_delegate requestDidFailWithError:err];
    }
    
    //for debug
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBResponseLog" object:nil userInfo:@{@"json": request.responseString ?:@"responseString为空",@"error":request.responseError}];
}


- (void)requestDidChangeWithNotificationName:(NSString *)notificationName error:(NSError *)error {
    if (self.actionIdentifiers.count > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                            object:nil
                                                          userInfo:@{@"_action_identifier": [self.actionIdentifiers lastObject], @"_response_error": error ?: @""}];
    }
}



@end
