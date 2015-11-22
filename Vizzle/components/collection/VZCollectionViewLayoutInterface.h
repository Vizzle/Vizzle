//
//  VZCollectionViewLayoutInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZCollectionViewController;

@protocol VZCollectionViewLayoutInterface <NSObject>

@property(nonatomic,weak)VZCollectionViewController* controller;

- (CGSize)calculateScrollViewContentSize;

@end
