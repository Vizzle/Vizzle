//
//  VizzleConfig.h
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#ifndef Vizzle_VizzleConfig_h
#define Vizzle_VizzleConfig_h

#undef	VZLog
#define VZLog(fmt,...)\
NSLog(@"[VZ]-->" fmt, ## __VA_ARGS__); \

#define VZErrorDomain @"TVZErrorDomain"

#define kMethodNameError 999
#define kParseJSONError 998
#define kLoginError 997
#define kRequestTimeout 996

#endif
