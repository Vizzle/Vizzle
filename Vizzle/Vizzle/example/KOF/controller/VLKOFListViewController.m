  
//
//  VLKOFListViewController.m
//  KOF97
//
//  Created by Jayson Xu on 2014-09-18 22:48:47 +0800.
//  Copyright (c) 2014年 VizLab: http://vizlab.com. All rights reserved.
//



#import "VLKOFListViewController.h"
#import "VLKOFLogic.h"
 
#import "VLKOFListModel.h" 
#import "VLKOFListViewDataSource.h"
#import "VLKOFListViewDelegate.h"

@interface VLKOFListViewController()

 
@property(nonatomic,strong)VLKOFListModel *kofListModel; 
@property(nonatomic,strong)VLKOFListViewDataSource *ds;
@property(nonatomic,strong)VLKOFListViewDelegate *dl;
@property(nonatomic,strong)VLKOFLogic *kofLogic;

@end

@implementation VLKOFListViewController

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

   
- (VLKOFListModel *)kofListModel
{
    if (!_kofListModel) {
        _kofListModel = [VLKOFListModel new];
        _kofListModel.key = @"__VLKOFListModel__";
    }
    return _kofListModel;
}


- (VLKOFListViewDataSource *)ds{

  if (!_ds) {
      _ds = [VLKOFListViewDataSource new];
   }
   return _ds;
}

- (VLKOFListViewDelegate *)dl{

  if (!_dl) {
      _dl = [VLKOFListViewDelegate new];
   }
   return _dl;
}

- (VLKOFLogic *)kofLogic
{
    if(!_kofLogic){
        _kofLogic = [VLKOFLogic new];
    }

    return _kofLogic;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (id)init
{
    self = [super init];
    
    if (self) {
        self.logic = self.kofLogic;
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.bNeedLoadMore = NO;
    self.bNeedPullRefresh = NO;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    //self.keyModel = self.model;
    
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
 
