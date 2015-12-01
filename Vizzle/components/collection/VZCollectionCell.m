//
//  VZCollectionCell.m
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionCell.h"

/**
 *  calling sequence:
 *  - prepareForReuse:
 *  - setItem:
 *  - sizeThatFits:
 *  - layoutSubView
 */
@implementation VZCollectionCell

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)setItem:(VZCollectionItem *)item
{
    _item = item;
}


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _item = nil;
    _delegate = nil;
}

@end
