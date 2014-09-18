  
//
//  VLKOFListCell.m
//  KOF97
//
//  Created by Jayson Xu on 2014-09-18 22:48:47 +0800.
//  Copyright (c) 2014年 VizLab: http://vizlab.com. All rights reserved.
//



#import "VLKOFListCell.h"
#import "VLKOFListItem.h"

@interface VLKOFListCell()

@end

@implementation VLKOFListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //todo: add some UI code
    
        
    }
    return self;
}

+ (CGFloat) tableView:(UITableView *)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)setItem:(VLKOFListItem *)item
{
    [super setItem:item];
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
  
  
}
@end
  
