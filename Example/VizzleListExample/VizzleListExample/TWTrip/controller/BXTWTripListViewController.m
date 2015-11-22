  
//
//  BXTWTripListViewController.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXTWTripListViewController.h"
#import "BXTWTripListModel.h" 
#import "BXTWTripCollectionViewLayout.h"
#import "BXTWTripListViewLayout.h"
#import "BXTWTripListViewDataSource.h"
#import "BXTWTripListViewDelegate.h"
#import "BXTWTripListItem.h"
#import "BXTWTripConfig.h"



@interface BXTWTripListViewController()

@property(nonatomic,assign)LAYOUT layoutType;
@property(nonatomic,strong)BXTWTripListModel *tWTripListModel; 
@property(nonatomic,strong)BXTWTripListViewDataSource *ds;
@property(nonatomic,strong)BXTWTripListViewDelegate *dl;
@property(nonatomic,strong)BXTWTripCollectionViewLayout* waterFlowLayout;
@property(nonatomic,strong)BXTWTripListViewLayout* listViewLayout;

@end

@implementation BXTWTripListViewController

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

   
- (BXTWTripListModel *)tWTripListModel
{
    if (!_tWTripListModel) {
        _tWTripListModel = [BXTWTripListModel new];
        _tWTripListModel.key = @"__BXTWTripListModel__";
        _tWTripListModel.layoutType = self.layoutType;
    }
    return _tWTripListModel;
}


- (BXTWTripListViewDataSource *)ds{

  if (!_ds) {
      _ds = [BXTWTripListViewDataSource new];
   }
   return _ds;
}

 
- (BXTWTripListViewDelegate *)dl{

  if (!_dl) {
      _dl = [BXTWTripListViewDelegate new];
   }
   return _dl;
}

- (BXTWTripCollectionViewLayout* )waterFlowLayout
{
    if (!_waterFlowLayout) {
        _waterFlowLayout = [BXTWTripCollectionViewLayout new];
    }
    return _waterFlowLayout;
}

- (BXTWTripListViewLayout* )listViewLayout
{
    if (!_listViewLayout) {
        _listViewLayout = [BXTWTripListViewLayout new];
    }
    return _listViewLayout;
}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (void)loadView
{
    [super loadView];
    
    [self setTitle:@"台北旅游"];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.layoutType = kWaterflow;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onLayoutChanged:)];
    
    //1,config your tableview
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.collectionView.showsVerticalScrollIndicator = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.needLoadMore = YES;
    self.needPullRefresh = YES;

    
    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;
    self.layout = self.waterFlowLayout;
    

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    self.keyModel = self.tWTripListModel;
    
    //5,REQUIRED:register model to parent view controller
    [self registerModel:self.keyModel];

    //6,Load Data
    [self load];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZViewController


- (void)showModel:(BXTWTripListModel *)model
{
    [super showModel:model];
    
    //如果第一页是缓存数据，那么重新加载
    if (model.isResponseObjectFromCache && model.currentPageIndex == 0) {
        [self reload];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZListViewController


- (void)reload
{
    self.tWTripListModel.layoutType = self.layoutType;
    [super reload];
}

- (void)loadMore
{
    self.tWTripListModel.layoutType = self.layoutType;
    [super loadMore];
}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 

- (void)onLayoutChanged:(id)sender
{
    if (self.layoutType == kWaterflow) {
        
        self.layoutType = kList;
        [self.ds fitLayout:self.layoutType];
        [self changeLayout:self.listViewLayout];
       
    }
    else{
    
        self.layoutType = kWaterflow;
        [self.ds fitLayout:self.layoutType];
        [self changeLayout:self.waterFlowLayout];
    }
}




@end
 
