//
//  VZHTTPNetworkSecurity.h
//  ETLibSDK
//
//  Created by moxin.xt on 12-12-18.
//  Copyright (c) 2013年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZHTTPNetworkSecurity : NSObject

- (BOOL) serverCanBeTrust:(SecTrustRef)aTrust;


@end
