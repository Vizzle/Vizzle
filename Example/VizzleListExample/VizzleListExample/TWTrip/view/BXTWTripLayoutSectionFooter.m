//
//  BXTWTripLayoutSectionFooter.m
//  VizzleListExample
//
//  Created by moxin on 15/11/30.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripLayoutSectionFooter.h"

@implementation BXTWTripLayoutSectionFooter

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.frame = CGRectMake(layoutAttributes.frame.origin.x, layoutAttributes.frame.origin.y, layoutAttributes.frame.size.width, layoutAttributes.size.height);
    self.backgroundColor = [UIColor yellowColor];
}


@end
