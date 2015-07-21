  
//
//  BXTWTripListViewController.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXTWTripListViewController.h"
 
#import "BXTWTripListModel.h" 
#import "BXTWTripListViewDataSource.h"
#import "BXTWTripListViewDelegate.h"

@interface BXTWTripListViewController()

 
@property(nonatomic,strong)BXTWTripListModel *tWTripListModel; 
@property(nonatomic,strong)BXTWTripListViewDataSource *ds;
@property(nonatomic,strong)BXTWTripListViewDelegate *dl;

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
    
    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:247/255.0 blue:251/255.0 alpha:1];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.needLoadMore = YES;
    self.needPullRefresh = YES;

    
    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;
    

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    self.keyModel = self.tWTripListModel;
    
    //5,REQUIRED:register model to parent view controller
    [self registerModel:self.keyModel];

    //6,Load Data
    [self load];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //todo..
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //todo..
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //todo..
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //todo..
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {
    
    //todo..
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //todo...
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



@end
 
