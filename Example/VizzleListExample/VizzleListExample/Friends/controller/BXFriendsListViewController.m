  
//
//  BXFriendsListViewController.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-04-23 10:39:37 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXFriendsListViewController.h"
#import "BXFriendsListModel.h" 
#import "BXFriendsListViewDataSource.h"
#import "BXFriendsListViewDelegate.h"

@interface BXFriendsListViewController()

 
@property(nonatomic,strong)BXFriendsListModel *friendsListModel; 
@property(nonatomic,strong)BXFriendsListViewDataSource *ds;
@property(nonatomic,strong)BXFriendsListViewDelegate *dl;

@end

@implementation BXFriendsListViewController

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

   
- (BXFriendsListModel *)friendsListModel
{
    if (!_friendsListModel) {
        _friendsListModel = [BXFriendsListModel new];
        _friendsListModel.requestType = VZModelCustom;
        _friendsListModel.key = @"__BXFriendsListModel__";
        _friendsListModel.needLoadAll = true;
    }
    return _friendsListModel;
}


- (BXFriendsListViewDataSource *)ds{

  if (!_ds) {
      _ds = [BXFriendsListViewDataSource new];
   }
   return _ds;
}

 
- (BXFriendsListViewDelegate *)dl{

  if (!_dl) {
      _dl = [BXFriendsListViewDelegate new];
   }
   return _dl;
}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.needPullRefresh = YES;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;
    

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    self.keyModel = self.friendsListModel;
    
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
 
