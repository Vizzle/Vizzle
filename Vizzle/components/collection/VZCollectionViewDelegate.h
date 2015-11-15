//
//  VZCollectionViewDelegate.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VZCollectionViewController;
@interface VZCollectionViewDelegate : NSObject<UICollectionViewDelegate>

@property(nonatomic,weak)VZCollectionViewController* controller;

@end
