  
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


typedef NS_ENUM(NSUInteger,LAYOUT)
{
    kList = 0,
    kWaterflow = 1
    
};


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


- (void)calculateLayoutContentSize
{
    int i=0;
    int topl = 0;
    int topr = 0;
    int w = CGRectGetWidth(self.collectionView.frame);
    int h = 0;
    NSArray* items = [self.ds itemsForSection:0];
    
    for (BXTWTripListItem* item in items) {
    
        if (item.itemHeight == 0)
        {
            item.itemHeight = arc4random() % 100 + 160;
        }
        
        if (self.layoutType == kList)
        {
            item.itemWidth = w;
        }
        else
        {
            item.itemWidth = 0.5*w;
            item.x = i%2 * w*0.5 ;
            
            //left
            if (i%2 == 0)
            {
                item.y = topl;
                topl += item.itemHeight;
            }
            //right
            else
            {
                item.y = topr;
                topr += item.itemHeight;
            }
        }
        
        h += item.itemHeight;
        i++;
        
        NSLog(@"{x:%.1f,y:%.1f,w:%.1f,h:%.1f}",item.x,item.y,item.itemWidth,item.itemHeight);
    }
    
    if (self.layoutType == kWaterflow) {
        
        self.layout.scrollViewContentSize = CGSizeMake(w, MAX(topl, topr));
    }
    else
    {
        self.layout.scrollViewContentSize = CGSizeMake(w, h);
    
    }
}


//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 

- (void)onLayoutChanged:(id)sender
{
    if (self.layoutType == kWaterflow) {
        
        self.layoutType = kList;
        [self changeLayout:self.listViewLayout];
       
    }
    else{
    
        self.layoutType = kWaterflow;
        [self changeLayout:self.waterFlowLayout];
    }
}


@end
 
