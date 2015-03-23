//
//  VZSignal+VZChannel.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-3-4.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZSignal.h"

@interface VZSignal (VZChannel)

- (void )send:(NSString* )channel;

@end
