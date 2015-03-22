//
//  VizzleConfig.h
//  Vizzle
//
//  Created by Jayson Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#ifndef Vizzle_VizzleConfig_h
#define Vizzle_VizzleConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


#import "VZListViewDelegate.h"
#import "VZListViewDataSource.h"
#import "VZViewController.h"
#import "VZListViewController.h"
#import "VZHTTPRequest.h"
#import "VZModel.h"
#import "VZHTTPModel.h"
#import "VZHTTPListModel.h"
#import "VZListCell.h"
#import "VZListDefaultTextCell.h"
#import "VZListDefaultErrorCell.h"
#import "VZListDefaultLoadingCell.h"
#import "VZItem.h"
#import "VZListItem.h"
#import "VZListDefaultTextItem.h"
#import "VZFooterViewFactory.h"


////////////////////////////////
#import "VZSignal.h"
#import "VZSignalDisposal.h"
#import "VZSignalDisposalProxy.h"
#import "VZSignalSubscriber.h"
#import "VZDummyBindingObject.h"
#import "VZSignalScheduler.h"
#import "VZTuple.h"

#import "VZViewModel.h"
#import "VZTemplate.h"

#import "VZKVOCenter.h"
#import "VZObserveInfo.h"
#import "VZObserverProxy.h"
#import "NSObject+VZOberveProxy.h"


#import "VZChannel.h"
#import "NSObject+VZChannel.h"
#import "VZSignal+VZChannel.h"

#import "NSObject+VZSignal.h"
#import "NSNotificationCenter+VZSignal.h"

#import "VZEXT.h"
#import "VZEXT_API.h"

#import "UIControl+VZSignal.h"
#import "NSObject+Deallocation.h"

////////////////////////////////

#ifdef _AFNETWORKING_
#import "VZAFRequest.h"
#endif



#undef	VZLog
#define VZLog(fmt,...)\
NSLog(@"[VZ]-->" fmt, ## __VA_ARGS__); \

#define VZErrorDomain @"TVZErrorDomain"

#define kMethodNameError 999
#define kParseJSONError 998
#define kLoginError 997
#define kRequestTimeout 996
#define kAFNetworkingError 995

#endif
