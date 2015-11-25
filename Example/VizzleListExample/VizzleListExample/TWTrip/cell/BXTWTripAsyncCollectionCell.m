//
//  BXTWTripAsyncCollectionCell.m
//  VizzleListExample
//
//  Created by moxin on 15/11/24.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripAsyncCollectionCell.h"
#import "BXTWTripListItem.h"
#import "BXTWAyncImageCache.h"
#import <AsyncDisplayKit/ASNetworkImageNode.h>
#import <AsyncDisplayKit/ASBasicImageDownloader.h>

@interface BXTWTripAsyncCollectionCell()
@property(nonatomic,strong)CALayer* placeholderLayer;
@property(nonatomic,strong)ASNetworkImageNode* imageNode;

@end

@implementation BXTWTripAsyncCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:247/255.0 blue:251/255.0 alpha:1];
        self.placeholderLayer = [CALayer layer];
        self.placeholderLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"default_list.jpg"].CGImage);
        self.placeholderLayer.contentsGravity = kCAGravityCenter;
        self.placeholderLayer.contentsScale = [UIScreen mainScreen].scale;
        self.placeholderLayer.masksToBounds = true;
        self.placeholderLayer.cornerRadius = 2.0f;
        [self.contentView.layer addSublayer:self.placeholderLayer];
        
        self.imageNode = [[ASNetworkImageNode alloc]initWithCache:nil downloader:[ASBasicImageDownloader sharedImageDownloader]];
        self.imageNode.layerBacked = true;
        self.imageNode.contentMode = UIViewContentModeScaleAspectFill;
        self.imageNode.defaultImage = [UIImage imageNamed:@"default_list.jpg"];
        self.imageNode.layer.masksToBounds = true;
        [self.contentView.layer addSublayer:self.imageNode.layer];

    }
    return self;
}

- (void)setItem:(BXTWTripListItem *)item
{
    [super setItem:item];
    
    NSURL* posterURL = [NSURL URLWithString:item.servicePicUrl];
    [self.imageNode setURL:posterURL];
//     [self.poster setImageWithURL:[NSURL URLWithString:item.servicePicUrl] placeholderImage:[UIImage imageNamed:@"default_list.jpg"]];
    
}

- (void)prepareForReuse{
    
    [super prepareForReuse];
    self.imageNode.image =  [UIImage imageNamed:@"default_list.jpg"];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BXTWTripListItem* item = (BXTWTripListItem* )self.item;
//    
    [CATransaction begin];
    [CATransaction setValue:@(1) forKey:kCATransactionDisableActions];
    self.placeholderLayer.frame = self.bounds;
    self.imageNode.frame = self.bounds;
    [CATransaction commit];

    
}

@end
