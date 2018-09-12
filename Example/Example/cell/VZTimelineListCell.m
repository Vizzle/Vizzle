  
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
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.numberOfLines = 0;
    
        
    }
    return self;
}

- (void)setItem:(VZTimelineListItem *)item
{
    [super setItem:item];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.textLabel.text = item.userName;
    self.detailTextLabel.text = item.text;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.avatarURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    VZTimelineListItem* item = (VZTimelineListItem* )self.item;
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = item.textHeight;
    self.detailTextLabel.frame = detailTextLabelFrame;
  
  
}
@end
  
