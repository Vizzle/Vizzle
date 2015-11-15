//
//  VZCollectionViewController.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZViewController.h"

@class VZCollectionViewDataSource;
@class VZCollectionViewDelegate;
@class VZCollectionViewLayout;
@interface VZCollectionViewController : VZViewController

@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) VZCollectionViewDataSource* dataSource;
@property(nonatomic,strong) VZCollectionViewDelegate* delegate;
@property(nonatomic,strong) VZCollectionViewLayout* layout;

- (void)changeLayout:(VZCollectionViewLayout* ) layout Animate:(BOOL)aAnimate withCompletionBlock:(BOOL(^)(void))aBlock;

@end



@interface VZCollectionViewController(SupplymentaryView)

- (void)registerHeaderViewClass:(Class)cls WithKey:(NSString*)key ForSection:(NSInteger)section;
- (void)registerFooterViewClass:(Class)cls WithKey:(NSString*)key ForSection:(NSInteger)section;

@end

@interface VZCollectionViewController(UICollectionView)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end