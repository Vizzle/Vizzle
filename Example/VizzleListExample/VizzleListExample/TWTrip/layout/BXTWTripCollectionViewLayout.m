//
//  BXTWTripCollectionViewLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripCollectionViewLayout.h"

@implementation BXTWTripCollectionViewLayout


- (NSInteger)lineSpacingForSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)itemSpaceingForSection:(NSInteger)section
{
    return 20;
}

- (UIEdgeInsets)insectForSection:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
