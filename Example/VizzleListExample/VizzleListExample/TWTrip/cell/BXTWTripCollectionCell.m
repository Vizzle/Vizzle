//
//  BXTWTripCollectionCell.m
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripCollectionCell.h"
#import "BXTWTripListItem.h"

@interface BXTWTripCollectionCell()

@property(nonatomic,strong) UIView* containerView;
@property(nonatomic,strong) UIImageView* poster;
@property(nonatomic,strong) UIImageView* icon;
@property(nonatomic,strong) UILabel* posterNameLabel;
@property(nonatomic,strong) UILabel* userNameLabel;
@property(nonatomic,strong) CAGradientLayer* gradientLayer;

@end

@implementation BXTWTripCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.icon.layer.cornerRadius = 15;
        self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
        self.icon.layer.borderWidth = 1.0f;
        self.icon.layer.masksToBounds=  true;
        self.icon.userInteractionEnabled = true;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.userInteractionEnabled = true;
        
        self.posterNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.posterNameLabel.backgroundColor = [UIColor clearColor];
        self.posterNameLabel.font = [UIFont systemFontOfSize:14.0f];
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
    
    BXTWTripListItem* item = (BXTWTripListItem* )self.item;
    CGRect parentRect = CGRectMake(0, 0, item.itemWidth, item.itemHeight);
    
  
    self.containerView.frame    = CGRectInset(parentRect, 10, 10);
    self.poster.frame           = CGRectMake(0, 0,CGRectGetWidth(parentRect),CGRectGetHeight(parentRect));
    self.icon.frame             = CGRectMake(10, CGRectGetHeight(self.containerView.frame)-36, 30, 30);
    self.gradientLayer.frame    = CGRectMake(0, CGRectGetHeight(self.containerView.frame)-40, CGRectGetWidth(self.containerView.frame),40);
    
    NSInteger r = self.icon.frame.origin.x+self.icon.frame.size.width;
    self.posterNameLabel.frame  = CGRectMake(r+10, self.icon.frame.origin.y, self.frame.size.width-r-40, 14);
    self.userNameLabel.frame    = CGRectMake(r+10, self.posterNameLabel.frame.origin.y+self.posterNameLabel.frame.size.height+5, self.posterNameLabel.frame.size.width, 10);
    
    
}

@end
