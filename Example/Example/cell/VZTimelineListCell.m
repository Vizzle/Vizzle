  
//
//  VZTimelineListCell.m
//  VizzleListExample
//
//  Created by Jayson Xu on 2014-09-29 13:48:38 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//





#import "VZTimelineListCell.h"
#import "VZTimelineListItem.h"

@interface VZTimelineListCell()

@end

@implementation VZTimelineListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //todo: add some UI code
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.textLabel.numberOfLines = 0;
    
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.numberOfLines = 0;
    
        
    }
    return self;
}

- (void)setItem:(VZTimelineListItem *)item
{
    [super setItem:item];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.body;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.avatarURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];  
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.textLabel.frame = CGRectZero;
    self.detailTextLabel.frame = CGRectZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    VZTimelineListItem* item = (VZTimelineListItem* )self.item;
    //    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    float textWidth = CGRectGetWidth(self.frame)-24;
    
    self.textLabel.frame = CGRectMake(12.0f, 10.0f, textWidth , item.titleHeight);
    self.detailTextLabel.frame = CGRectMake(12.0f, item.titleHeight+20, textWidth, item.bodyHeight);
    
}
@end
  
