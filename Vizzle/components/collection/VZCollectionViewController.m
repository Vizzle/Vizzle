//
//  VZCollectionViewController.m
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionViewController.h"
#import "VZCollectionViewDataSource.h"
#import "VZCollectionViewDelegate.h"
#import "VZCollectionViewLayout.h"

@implementation VZCollectionViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setDataSource:(VZCollectionViewDataSource*)dataSource
{
    _dataSource = dataSource;
    self.collectionView.dataSource = dataSource;
    _dataSource.controller = self;
}

- (void)setDelegate:(VZCollectionViewDelegate*)delegate
{
    _delegate = delegate;
    self.collectionView.delegate = delegate;
    _delegate.controller = self;
}

- (void)setLayout:(VZCollectionViewLayout* )layout
{
    _layout = layout;
    self.collectionView.collectionViewLayout = (UICollectionViewLayout* )layout;
    _layout.controller = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


@end
