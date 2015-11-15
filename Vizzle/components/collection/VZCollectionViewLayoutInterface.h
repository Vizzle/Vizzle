//
//  VZCollectionViewLayoutInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZUICollectionViewController;
@protocol VZCollectionViewLayoutInterface <NSObject>

@property (nonatomic,weak)VZUICollectionViewController* controller;

@optional
- (CGSize)scrollViewContentSize;


@end
