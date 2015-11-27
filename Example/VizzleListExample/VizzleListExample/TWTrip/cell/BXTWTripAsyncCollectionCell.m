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
#import "BXTWAsynImageDownloader.h"
#import "BXTWImageNode.h"
#import "UIImage+ImageEffects.h"
#import <AsyncDisplayKit/ASNetworkImageNode.h>
#import <AsyncDisplayKit/ASBasicImageDownloader.h>
#import <pthread.h>


@interface BXTWTripAsyncCollectionCell()
@property(nonatomic,strong)CALayer* placeholderLayer;
@property(nonatomic,strong)ASDisplayNode* containerNode;
@property(nonatomic,strong)BXTWImageNode* backgroundImageNode;

@end

@implementation BXTWTripAsyncCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.containerNode = [[ASDisplayNode alloc]init];
        self.containerNode.layerBacked = true;
        self.containerNode.shouldRasterizeDescendants = true;
        self.containerNode.borderColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:0.2].CGColor;
        self.containerNode.borderWidth = 1;
        
//        self.placeholderLayer = [CALayer layer];
//        self.placeholderLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"default_list.jpg"].CGImage);
//        self.placeholderLayer.contentsGravity = kCAGravityCenter;
//        self.placeholderLayer.contentsScale = [UIScreen mainScreen].scale;
//        self.placeholderLayer.masksToBounds = true;
//        self.placeholderLayer.cornerRadius = 2.0f;
//        [self.contentView.layer addSublayer:self.placeholderLayer];
        
        self.backgroundImageNode = [[BXTWImageNode alloc]initWithCache:[BXTWAyncImageCache sharedInstance] downloader:[BXTWAsynImageDownloader sharedInstance]];
        self.backgroundImageNode.layerBacked = true;
        self.backgroundImageNode.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageNode.defaultImage = [UIImage imageNamed:@"default_list.jpg"];
        self.backgroundImageNode.layer.masksToBounds = true;
//        __weak typeof(self) weakSelf = self;
//        self.backgroundImageNode.imageModificationBlock = ^UIImage*(UIImage* input)
//        {
//            NSLog(@"%s",__FUNCTION__);
//            BXTWTripListItem* item = (BXTWTripListItem*)weakSelf.item;
//            
////            NSString* cachedKey = [item.servicePicUrl stringByAppendingString:@"_blurred"];
////            UIImage* cachedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cachedKey];
////            if (cachedImage) {
////                return cachedImage;
////            }
////            else
////            {
//                mach_port_t machTID = pthread_mach_thread_np(pthread_self());
//                NSLog(@"bluring image:{index:%ld, url:%@,thread_id:%d}",item.indexPath.item,item.servicePicUrl,machTID);
//                UIImage* image = [input applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:0.5 alpha:0.3] saturationDeltaFactor:1.8 maskImage:nil            ];
//                if (image) {
////                    [[SDImageCache sharedImageCache] storeImage:image forKey:cachedKey];
//                    return image;
//                }
//                else
//                {
//                    return input;
//                }
////            }
//
//        };
       
        [self.containerNode addSubnode:self.backgroundImageNode];
        [self.contentView.layer addSublayer:self.containerNode.layer];

    }
    return self;
}

- (void)setItem:(BXTWTripListItem *)item
{
    [super setItem:item];
    
    NSURL* posterURL = [NSURL URLWithString:item.servicePicUrl];
    NSString* cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:posterURL];
    
    UIImage* image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:cacheKey];
    if (image){
        self.backgroundImageNode.image = image;
    }else{
         [self.backgroundImageNode setURL:posterURL];
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerNode.frame = self.bounds;
    self.backgroundImageNode.frame = self.containerNode.bounds;
    
}

@end
