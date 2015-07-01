//
//  VZListViewControllerPrivate.h
//  VizzleListExample
//
//  Created by moxin on 15/7/2.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

@protocol  VZListViewFooterView<NSObject>

@property(nonatomic,strong)UIView* footerViewLoading;
@property(nonatomic,strong)UIView* footerViewComplete;
@property(nonatomic,strong)UIView* footerViewError;
@property(nonatomic,strong)UIView* footerViewNoResult;

@end


