//
//  BXTWTripListViewLayout.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripListLayout.h"
#import "BXTWTripListItem.h"

@implementation BXTWTripListLayout

- (CGSize)sizeForHeaderViewAtSectionIndex:(NSInteger)section{

    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(self.controller.collectionView.bounds), 44);
    }
    else
    {
        return CGSizeZero;
    }
}

- (NSInteger) itemSpaceingForSection:(NSInteger)section
{
    return 10;
}

@end
