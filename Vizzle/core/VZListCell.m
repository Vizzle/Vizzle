//
//  VZListCell.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZListCell.h"
#import "VZListItem.h"
#import "VZAssert.h"

/**
 *  calling sequence:
 *  - prepareForReuse:
 *  - setItem:
 *  - sizeThatFits:
 *  - layoutSubView
 */
@implementation VZListCell

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

+ (CGFloat)tableView:(UITableView*)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath*)indexPath
{
    return 44;
}

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)dealloc{
    
    _item = nil;
    _delegate = nil;
}


@end
