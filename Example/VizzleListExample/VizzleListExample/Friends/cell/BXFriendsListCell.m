  
//
//  BXFriendsListCell.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-04-23 10:39:37 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXFriendsListCell.h"
#import "BXFriendsListItem.h"

@interface BXFriendsListCell()

@property(nonatomic,strong) UILabel* title;
@property(nonatomic,strong) UIImageView* icon;

@end

@implementation BXFriendsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.icon];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectZero];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:16.0f];
        self.title.textColor = [UIColor grayColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.title];
    
        
    }
    return self;
}

+ (CGFloat) tableView:(UITableView *)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)setItem:(BXFriendsListItem *)item
{
    [super setItem:item];
  
    [self.icon setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.icon setUserInteractionEnabled:YES];
    self.title.text = item.nickname;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int w = CGRectGetWidth(self.bounds);
    int h = CGRectGetHeight(self.bounds);
    
    
    self.icon.frame = CGRectMake(8, 8, (h-16), (h-16));
    self.title.frame = CGRectMake(8 + self.icon.frame.size.width + 8, 0, w - 16 - 16, h);
  
    
}

@end
  
