//
//  NSObject+Deallocation.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-2-26.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VZSignalDisposalProxy;
@interface NSObject (Deallocation)

@property(atomic,strong,readonly) VZSignalDisposalProxy* vz_deallocDisposalProxy;

@end
