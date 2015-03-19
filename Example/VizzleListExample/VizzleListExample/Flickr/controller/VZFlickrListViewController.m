  
//
//  VZFlickrListViewController.m
//  VizzleListExample
//
//  Created by moxinxt on 2014-10-01 22:14:53 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZFlickrListViewController.h"
#import "VZFlickrListModel.h"
#import "VZFlickrListViewDataSource.h"
#import "VZFlickrListViewDelegate.h"

@interface VZFlickrListViewController()

 
@property(nonatomic,strong)VZFlickrListModel *flickrListModel; 
@property(nonatomic,strong)VZFlickrListViewDataSource *ds;
@property(nonatomic,strong)VZFlickrListViewDelegate *dl;


@end

@implementation VZFlickrListViewController

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

   
- (VZFlickrListModel *)flickrListModel
{
    if (!_flickrListModel) {
        _flickrListModel = [VZFlickrListModel new];
        _flickrListModel.key = @"__VZFlickrListModel__";
    }
    return _flickrListModel;
}


- (VZFlickrListViewDataSource *)ds{

  if (!_ds) {
      _ds = [VZFlickrListViewDataSource new];
   }
   return _ds;
}

- (VZFlickrListViewDelegate *)dl{

  if (!_dl) {
      _dl = [VZFlickrListViewDelegate new];
   }
   return _dl;
}



////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (id)init
{
    self = [super init];
    
    if (self) {
   

        
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
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
 
