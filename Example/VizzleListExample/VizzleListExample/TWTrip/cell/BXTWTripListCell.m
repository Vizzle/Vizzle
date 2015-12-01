  
//
//  BXTWTripListCell.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXTWTripListCell.h"
#import "BXTWTripListItem.h"

@interface BXTWTripListCell()

@property(nonatomic,strong) UIView* containerView;
@property(nonatomic,strong) UIImageView* poster;
@property(nonatomic,strong) UIImageView* icon;
@property(nonatomic,strong) UILabel* posterNameLabel;
@property(nonatomic,strong) UILabel* userNameLabel;
@property(nonatomic,strong) CAGradientLayer* gradientLayer;

@end

@implementation BXTWTripListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:247/255.0 blue:251/255.0 alpha:1];;
        //todo: add some UI code
        self.containerView = [[UIView alloc]initWithFrame:CGRectZero];
        self.containerView.layer.cornerRadius = 5.0f;
        self.containerView.layer.masksToBounds = true;
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.containerView];
        
        self.poster = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.poster.contentMode = UIViewContentModeScaleAspectFill;
        self.poster.clipsToBounds = true;

        self.icon = [[UIImageView alloc]initWithFrame:(CGRect){0,0,CGSizeMake(46, 46)}];
        self.icon.layer.cornerRadius = 0.5*46;
        self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
        self.icon.layer.borderWidth = 1.0f;
        self.icon.layer.masksToBounds=  true;
        self.icon.userInteractionEnabled = true;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.userInteractionEnabled = true;
        
        self.posterNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.posterNameLabel.backgroundColor = [UIColor clearColor];
        self.posterNameLabel.font = [UIFont systemFontOfSize:18.0f];
        self.posterNameLabel.textColor = [UIColor whiteColor];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont systemFontOfSize:10.0f ];
        self.userNameLabel.textColor = [UIColor lightGrayColor];

        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.8 alpha:0.0].CGColor,(id)[UIColor colorWithWhite:0.0 alpha:0.8].CGColor,nil];
        
        [self.containerView addSubview:self.poster];
        [self.containerView.layer addSublayer:self.gradientLayer];
        [self.containerView addSubview:self.icon];
        [self.containerView addSubview:self.posterNameLabel];
        [self.containerView addSubview:self.userNameLabel];
        
    }
    return self;
}

+ (CGFloat) tableView:(UITableView *)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath *)indexPath
{
    return 215;
}

- (void)setItem:(BXTWTripListItem *)item
{
    [super setItem:item];
    
    [self.poster setImageWithURL:[NSURL URLWithString:item.servicePicUrl] placeholderImage:[UIImage imageNamed:@"default_list.jpg"]];
    [self.icon setImageWithURL:[NSURL URLWithString:item.headPic] placeholderImage:[UIImage imageNamed:@"default_icon.jpg"]];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ @%@",item.userNick,item.serviceAddress];
    self.posterNameLabel.text = item.serviceName;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame    = CGRectMake(10, 10, self.frame.size.width-20, 205);
    self.poster.frame           = CGRectMake(0, 0, self.contentView.frame.size.width, 175);
    self.icon.frame             = CGRectMake(10, self.poster.frame.size.height-23, 45, 45);
    
    [CATransaction begin];
        [CATransaction setAnimationDuration:0];
    self.gradientLayer.frame    = CGRectMake(0, self.icon.frame.origin.y-20, self.frame.size.width-20, 43);

    [CATransaction commit];
    
    NSInteger r = self.icon.frame.origin.x+self.icon.frame.size.width;
    self.posterNameLabel.frame  = CGRectMake(r+10, self.icon.frame.origin.y, self.frame.size.width-r-40, 20);
    self.userNameLabel.frame    = CGRectMake(r+10, self.posterNameLabel.frame.origin.y+self.posterNameLabel.frame.size.height+13, self.posterNameLabel.frame.size.width, 10);
    
    
}
@end
  
