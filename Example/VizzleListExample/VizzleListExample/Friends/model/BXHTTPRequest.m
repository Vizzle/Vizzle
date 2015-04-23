//
//  BXHTTPRequest.m
//  BX
//
//  Created by moxin on 15/3/30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "BXHTTPRequest.h"

@implementation BXHTTPRequest

- (void)requestDidFinish:(id)JSON
{
    NSNumber* code = JSON[@"code"];
    NSString* err  = JSON[@"errmsg"];
   
    if (code.integerValue == 0) {
        
        id result = JSON[@"result"];
        
        if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [self.delegate requestDidFinish:result];
        }
    }
    else
    {
        //token失效
        if ([code integerValue] == -100) {
            //[self vz_postToChannel:__kChannel_token_invalid__ withObject:nil Data:nil];
        }
        else
        {
            NSError* error = [NSError errorWithDomain:@"BXHTTPError" code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:err}];
            
            if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
                [self.delegate requestDidFailWithError:error];
            }
        }

    }
}




@end
