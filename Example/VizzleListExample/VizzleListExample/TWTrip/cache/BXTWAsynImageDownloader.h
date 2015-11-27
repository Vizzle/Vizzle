//
//  BXTWAsynImageDownloader.h
//  VizzleListExample
//
//  Created by moxin on 15/11/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/ASImageProtocols.h>

@interface BXTWAsynImageDownloader : NSObject<ASImageDownloaderProtocol>

+ (instancetype)sharedInstance;

@end
