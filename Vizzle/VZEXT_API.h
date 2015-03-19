//
//  VZEXT_API.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-30.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#ifndef VZAsyncTemplate_VZEXT_API_h
#define VZAsyncTemplate_VZEXT_API_h

//语法糖(high level):

#import "VZEXT.h"

#define VZObserve(TARGET, KEYPATH) \
({ \
__weak id target_ = (TARGET); \
id keypath = @vz_ext_keypath(TARGET,KEYPATH);\
[target_ vz_observeKeypath:keypath]; \
})

#define VZChannel(NAME, KEYPATH) \
({ \
id name = (NAME); \
id keypath = (KEYPATH); \
[self vz_observeChannel:name KeyPath:keypath]; \
})


/// Do not use this directly
#define VZBind(TARGET, KEYPATH) \
        [[VZDummyBindingObject alloc] initWithTarget:(TARGET)][@vz_ext_keypath(TARGET, KEYPATH)]



#endif
