//
//  VZListViewController.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZListViewController.h"
#import "VZHTTPListModel.h"
#import "VZListDefaultTextItem.h"
#import "VZListViewDataSource.h"
#import "VZListViewDelegate.h"
#import "VZListCell.h"
#import "VZListItem.h"
#import "VZFooterViewFactory.h"
#import "VZAssert.h"

@interface VZListViewController ()
{
    //state,bad
    NSInteger _loadMoreSection;
}

@end

@implementation VZListViewController

@synthesize dataSource = _dataSource;
@synthesize delegate   = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setDataSource:(VZListViewDataSource*)dataSource
{
    _dataSource = dataSource;
    _dataSource.controller = self;
    self.tableView.dataSource = dataSource;
}

- (void)setDelegate:(VZListViewDelegate*)delegate
{
    _delegate = delegate;
    _delegate.controller = self;
    self.tableView.delegate = delegate;
}


- (void)setKeyModel:(VZHTTPListModel *)keyModel
{
    NSAssert([keyModel isKindOfClass:[VZHTTPListModel class]],@"keyModel type error");
    _keyModel = keyModel;
    _loadMoreSection = keyModel.sectionNumber;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.opaque  = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = NO;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        
    }
    return _tableView;
}


- (VZListViewDataSource* )dataSource
{
    if(!_dataSource)
    {
        _dataSource = [[VZListViewDataSource alloc]init];
        _dataSource.controller = self;
    }
    
    return _dataSource;
}

- (VZListViewDelegate* )delegate
{
    if(!_delegate)
    {
        _delegate = [[VZListViewDelegate alloc]init];
        _delegate.controller = self;
    }
    
    return _delegate;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self loadDefaultConfig];
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self loadDefaultConfig];
    }
    return self;
}

- (void)loadDefaultConfig {
    _clearItemsWhenModelReload = NO;
    _loadmoreAutomatically = YES;
    _needPullRefresh      = NO;
    _needLoadMore         = NO;
    _preventUserInteractionWhenPullRefreshing = NO;
}


- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _delegate = nil;
    _dataSource = nil;
}

- (void)loadView
{
    [super loadView];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////////////////////////////////////////////////////////////////////
#pragma mark - VZViewController

- (void)registerModel:(VZModel *)model
{
    NSAssert([model isKindOfClass:[VZHTTPListModel class]], @"model type incorrect");
    return [super registerModel:model];
}

- (void)load
{
    NSAssert(_keyModel != nil, @"A key model is required");
    [super load];
}

- (void)reload{
    
    NSAssert(_keyModel != nil, @"A key model is required");
    if (self.clearItemsWhenModelReload) {
        [self.dataSource removeAllItems];
        [self reloadTableView];
    }
    [super reload];
}

- (void)loadMore
{
    NSAssert(_keyModel != nil, @"A key model is required");
    if (self.needLoadMore) {
        
        //如果当前页是缓存数据，则不进行翻页
        if (self.keyModel.isResponseObjectFromCache) {
            return;
        }
        else
        {
            if ([self.keyModel hasMore]) {
                
                if (self.loadmoreAutomatically) {
                    [self.keyModel loadMore];
                }
                else
                [self showLoadMoreFooterView];
                
            }
        }
        
        
    }
}

- (void)didLoadModel:(VZHTTPListModel *)model
{
    //VZMV* => 1.1 : 多个model注册同一个section，只有keymodel才能被加载
    NSInteger section = self.keyModel.sectionNumber;
    
    if (model.sectionNumber == section) {
        
        //只处理key model带回来的数据
        if (model == self.keyModel ) {
            [self.dataSource tableViewControllerDidLoadModel:model];
        }
        
    }
    else
    [self.dataSource tableViewControllerDidLoadModel:model];
    
    
}

- (BOOL)canShowModel:(VZHTTPListModel *)model
{
    if (![super canShowModel:model]) {
        return NO;
    }
    
    NSInteger numberOfRows = 0;
    NSInteger numberOfSections = 0;
    
    numberOfSections = [self.dataSource numberOfSectionsInTableView:self.tableView];
    
    if (!numberOfSections) {
        return NO;
    }
    
    numberOfRows = 0;
    
    for (int i=0; i<numberOfSections; i++) {
        numberOfRows =  [self.dataSource tableView:self.tableView numberOfRowsInSection:i];
        if (numberOfRows > 0) {
            break;
        }
    }
    
    if (!numberOfRows) {
        return NO;
    }
    else
    {
        //VZMV* => 1.1 : 多个model注册同一个section，只有keymodel才能被show出来
        if (numberOfSections == 1) {
            
            if (model == _keyModel) {
                return YES;
            }
            else
            return NO;
        }
    }
    return YES;
}


- (void)showEmpty:(VZHTTPListModel *)model
{
    VZLog(@"{key:%@,section:%ld}",model.key,(long)model.sectionNumber);
    
    [super showEmpty:model];
    
    [self endRefreshing];
    [self showNoResult:model];
}

//默认loading 样式
- (void)showLoading:(VZHTTPListModel *)model
{
    VZLog(@"{key:%@,section:%ld}",model.key,(long)model.sectionNumber);
    
    if (model == _keyModel) {
        //如果下拉刷新在转菊花，不显示loading的footerView
        if (!self.delegate.isRefreshing) {
            
            if (model.sectionNumber == [self.tableView.dataSource numberOfSectionsInTableView:self.tableView]-1) {
                
                self.tableView.tableFooterView = [self footerViewLoading:@"loading..."];
            }
            else {
                
                self.tableView.tableFooterView = [VZFooterViewFactory emptyFooterView];
            }
        }
        else {
            self.tableView.tableFooterView = [VZFooterViewFactory emptyFooterView];
        }
    }
    else
    {
        //VZMV* => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber) {
            
            //show loading for seciton
            NSInteger section = model.sectionNumber;
            //创建一个loading item
            VZListItem* item = [VZListItem new];
            item.itemType = kItem_Loading;
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
        
    }
}

- (void)showModel:(VZHTTPListModel *)model
{
    VZLog(@"{key:%@,section:%ld}",model.key,(long)model.sectionNumber);
    
    [super showModel:model];
    
    //VZMV* => 1.1:
    [self reloadTableView];
    
    //VZMV* => 1.1 : reset footer view
    [self showComplete:model];
    
    [self endRefreshing];
    
}

- (void)showError:(NSError *)error withModel:(VZHTTPListModel *)model
{
    VZLog(@"{key:%@,section:%ld}",[self class], model.key,(long)model.sectionNumber);
    
    [self endRefreshing];
    
    if (model == _keyModel) {
        
        
        //VZMV* => 1.1 : 翻页出错的时候底部展示错误内容
        self.tableView.tableFooterView = [self footerViewError:error DefaultText:@"Error"];
        // 尝试修复footerview遮盖section header的问题
        [self.tableView sendSubviewToBack:self.tableView.tableFooterView];
        
        
    }
    else
    {
        //VZMV => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber)
        {
            //show loading for seciton
            NSInteger section = model.sectionNumber;
            //创建一个error item
            VZListDefaultTextItem* item = [VZListDefaultTextItem new];
            item.itemType = kItem_Error;
            item.text = error.localizedDescription;
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
    }
    
}
////////////////////////////////////////////////////////////////////
#pragma mark - private

- (void)reloadTableView
{
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate   = self.delegate;
    [self.tableView reloadData];
    
}


////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)loadModelForSection:(NSInteger)section
{
    VZAssertMainThread();
    //load model
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        VZHTTPListModel* model = (VZHTTPListModel*)obj;
        
        if (section == model.sectionNumber) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [model load];
            });
        }
    }];
}

- (void)reloadModelForSection:(NSInteger)section
{
    VZAssertMainThread();
    
    //reload model
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        VZHTTPListModel* model = (VZHTTPListModel*)obj;
        
        if (section == model.sectionNumber) {
            
            if (self.clearItemsWhenModelReload) {
                [self.dataSource removeAllItems];
                [self reloadTableView];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [model reload];
            });
        }
    }];
}

- (void)loadModelByKey:(NSString* )targetKey
{
    VZAssertMainThread();
    
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        VZHTTPListModel* model = (VZHTTPListModel*)obj;
        
        if ([key isEqualToString : targetKey]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [model load];
            });
        }
    }];
}

- (void)reloadModelByKey:(NSString *)key
{
    VZAssertMainThread();
    
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        VZHTTPListModel* model = (VZHTTPListModel*)obj;
        
        if ([key isEqualToString : key]) {
            
            if (self.clearItemsWhenModelReload) {
                [self.dataSource removeAllItems];
                [self reloadTableView];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [model reload];
            });
        }
    }];
}
/**
 * 显示下拉刷新
 */
- (void)beginRefreshing
{
    [self.delegate beginRefreshing];
}
/**
 * 隐藏下拉刷新
 */
- (void)endRefreshing
{
    self.tableView.userInteractionEnabled = YES;
    [self.delegate endRefreshing];
}
/**
 下拉刷新通知
 */
- (void)pullRefreshDidTrigger
{
    if (self.preventUserInteractionWhenPullRefreshing) {
        self.tableView.userInteractionEnabled = NO;
    }
    [self reload];
}

@end

@implementation VZListViewController(Subclassing)

- (void)showNoResult:(VZHTTPListModel *)model
{
    VZLog(@"{key:%@,section:%ld}",model.key,(long)model.sectionNumber);
    
    [self endRefreshing];
    
    
    if (model == _keyModel) {
        
        self.tableView.tableFooterView = [self footerViewNoResult:@""];
        
    }
    else
    {
        //VZ => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber) {
            
            NSInteger section = model.sectionNumber;
            //创建一个customized item
            VZListDefaultTextItem* item = [VZListDefaultTextItem new];
            item.itemType = kItem_Customize;
            item.text = @"No Result";
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
    }
    
}
- (void)showComplete:(VZHTTPListModel *)model
{
    VZLog(@"{section:%ld}",(long)model.sectionNumber);
    if (model == _keyModel) {
        self.tableView.tableFooterView = [self footerViewComplete:@""];
    }
}
- (void)showLoadMoreFooterView
{
    self.tableView.tableFooterView = [self footerViewLoadMore:@"Tap to reload"];
}

- (void)onLoadMoreClicked:(id)sender
{
    [self.keyModel loadMore];
}
- (UIView *)footerViewLoading:(NSString* )text
{
    return [VZFooterViewFactory loadingFooterView:CGRectMake(0, 0,CGRectGetWidth(self.tableView.bounds), 44) Text:text];
}

- (UIView *)footerViewError:(NSError *)error DefaultText:(NSString* )text
{
    return [VZFooterViewFactory errorFooterView:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 44) Text:error.localizedDescription ? : text];
}

- (UIView *)footerViewComplete:(NSString* )text
{
    return [VZFooterViewFactory emptyFooterView];
}

- (UIView *)footerViewNoResult:(NSString* )text
{
    return [VZFooterViewFactory emptyFooterView];
}
- (UIView *)footerViewLoadMore:(NSString* )text{
    return [VZFooterViewFactory clickableFooterView:CGRectMake(0, 0, self.tableView.frame.size.width, 44) Text: text Target:self Action:@selector(onLoadMoreClicked:) ];
}
@end

@implementation VZListViewController(UITableView)
/*
 * tableView的相关操作
 */
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary*)bundle
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

@end
