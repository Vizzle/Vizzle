  
//
//  VZTimelineListViewController.m
//  VizzleListExample
//
//  Created by Jayson Xu on 2014-09-29 13:48:38 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZTimelineListViewController.h"
#import "VZTimelineListModel.h" 
#import "VZTimelineListViewDataSource.h"
#import "VZTimelineListViewDelegate.h"

@interface VZTimelineListViewController()

 
@property(nonatomic,strong)VZTimelineListModel *timelineListModel; 
@property(nonatomic,strong)VZTimelineListViewDataSource *ds;
@property(nonatomic,strong)VZTimelineListViewDelegate *dl;

@end

@implementation VZTimelineListViewController

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

   
- (VZTimelineListModel *)timelineListModel
{
    if (!_timelineListModel) {
        _timelineListModel = [VZTimelineListModel new];
        _timelineListModel.key = @"__VZTimelineListModel__";
    }
    return _timelineListModel;
}


- (VZTimelineListViewDataSource *)ds{

  if (!_ds) {
      _ds = [VZTimelineListViewDataSource new];
   }
   return _ds;
}

- (VZTimelineListViewDelegate *)dl{

  if (!_dl) {
      _dl = [VZTimelineListViewDelegate new];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"Timeline"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.needLoadMore = YES;
    //self.needLoadAll = YES;
    self.needPullRefresh = YES;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    self.keyModel = self.timelineListModel;
    
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

- (void)showModel:(VZHTTPListModel *)model
{
    [super showModel:model];
    
    NSLog(@"!!!Model:FromCache:%d!!!",model.isResponseObjectFromCache);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZListViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //todo...
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 





//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



@end
 
