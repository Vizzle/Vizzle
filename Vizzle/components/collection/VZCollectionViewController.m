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
#import "VZCollectionViewLayoutInterface.h"

@interface VZCollectionViewController()


@end

@implementation VZCollectionViewController
{
    //state,bad
    NSInteger _loadMoreSection;
}

@synthesize dataSource = _dataSource;
@synthesize delegate   = _delegate;
@synthesize layout     = _layout;
@synthesize footerViewLoading  = _footerViewLoading;
@synthesize footerViewComplete = _footerViewComplete;
@synthesize footerViewNoResult = _footerViewNoResult;
@synthesize footerViewError    = _footerViewError;


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

- (void)setLayout:(id<VZCollectionViewLayoutInterface> )layout
{
    _layout = layout;
    self.collectionView.collectionViewLayout = (UICollectionViewLayout* )layout;
    _layout.controller = self;
}

- (void)setKeyModel:(VZHTTPListModel *)keyModel
{
    NSAssert([keyModel isKindOfClass:[VZHTTPListModel class]],@"wrong type!");
    _keyModel = keyModel;
    _loadMoreSection = keyModel.sectionNumber;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:(UICollectionViewLayout* )self.layout];
        _collectionView.opaque  = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = nil;
        _collectionView.delegate = nil;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (VZCollectionViewDataSource* )dataSource
{
    if(!_dataSource)
    {
        _dataSource = [[VZCollectionViewDataSource alloc]init];
        _dataSource.controller = self;
        
    }
    return _dataSource;
}

- (VZCollectionViewDelegate* )delegate
{
    if(!_delegate)
    {
        _delegate = [[VZCollectionViewDelegate alloc]init];
        _delegate.controller = self;
    }
    
    return _delegate;
}

- (id<VZCollectionViewLayoutInterface> )layout
{
    if (!_layout) {
        
        //默认为普通layout
        _layout = [VZCollectionViewLayout new];
        _layout.controller = self;
    }
    return _layout;
}

//- (NSMutableDictionary* )headerViewKeyForSection
//{
//    if (!_headerViewKeyForSection) {
//        _headerViewKeyForSection = [NSMutableDictionary new];
//    }
//    return _headerViewKeyForSection;
//}
//
//- (NSMutableDictionary* )footerViewKeyForSection
//{
//    if (!_footerViewKeyForSection) {
//        _footerViewKeyForSection = [NSMutableDictionary new];
//    }
//    return _footerViewKeyForSection;
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self clearState];
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self clearState];
    }
    return self;
}


- (void)clearState
{
    _clearItemsWhenModelReload = NO;
    _loadmoreAutomatically = YES;
    _needPullRefresh      = NO;
    _needLoadMore         = NO;
}


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _collectionView            = nil;
    _collectionView.delegate   = nil;
    _collectionView.dataSource = nil;
    _delegate             = nil;
    _dataSource           = nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidUnload
{
    _collectionView.delegate  =nil;
    _collectionView.dataSource = nil;
    _collectionView = nil;
    
    [super viewDidUnload];
    
    
}

////////////////////////////////////////////////////////////////////
#pragma mark - VZViewController

- (void)registerModel:(VZModel *)model
{
    NSAssert([model isKindOfClass:[VZHTTPListModel class]], @"model类型不正确");
    return [super registerModel:model];
}

- (void)load
{
    NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
    [super load];
}

- (void)loadMore
{
    NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
    if (self.needLoadMore) {
        
        //如果当前页是缓存数据，则不进行翻页
        if (self.keyModel.isResponseObjectFromCache) {
            return;
        }
        else
        {
            if ([self.keyModel hasMore])
            {
                if (self.loadmoreAutomatically) {
                    [self.keyModel loadMore];
                }
                else
                {
                    [self showLoadMoreFooterView];
                }
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
            [self.dataSource collectionViewControllerDidLoadModel:model];
        }
        
    }
    else
        [self.dataSource collectionViewControllerDidLoadModel:model];
    
    
}

- (BOOL)canShowModel:(VZHTTPListModel *)model
{
    if (![super canShowModel:model]) {
        return NO;
    }
    
    NSInteger numberOfItems = 0;
    NSInteger numberOfSections = 0;
    
    numberOfSections = [self.dataSource numberOfSectionsInCollectionView:self.collectionView];
    
    if (!numberOfSections) {
        return NO;
    }
    
    numberOfItems = 0;
    
    for (int i=0; i<numberOfSections; i++) {
        numberOfItems =  [self.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        if (numberOfItems > 0) {
            break;
        }
    }
    
    if (!numberOfItems) {
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
    NSLog(@"[%@]-->showEmpty:{key:%@,section:%ld}",[self class],model.key,(long)model.sectionNumber);
    
    [super showEmpty:model];
    
    [self endRefreshing];
    [self showNoResult:model];
}

//默认loading 样式
- (void)showLoading:(VZHTTPListModel *)model
{
    NSLog(@"[%@]-->showLoading:{key:%@,section:%ld}",[self class],model.key,(long)model.sectionNumber);
    
    if (model == _keyModel) {
        
        //如果下拉刷新在转菊花，不显示loading的footerView
        if (!self.delegate.isRefreshing) {
            
            if (model.sectionNumber == [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]-1) {
                
                if (self.footerViewLoading) {
                   // self.collectionView. = self.footerViewLoading;
                }
                else
                {
                    //self.tableView.tableFooterView =  [VZFooterViewFactory loadingFooterView:CGRectMake(0, 0,CGRectGetWidth(self.tableView.bounds), 44) Text:@"努力加载中..."];
                }
            }
            else{
                
                //self.tableView.tableFooterView = [VZFooterViewFactory emptyFooterView];
            }
        }
        else
        {
            //self.tableView.tableFooterView = [VZFooterViewFactory emptyFooterView];
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
    NSLog(@"[%@]-->showModel:{key:%@,section:%ld}",[self class],model.key,(long)model.sectionNumber);
    
    [super showModel:model];
    
    //VZMV* => 1.1:
    [self reloadTableView];
    
    //VZMV* => 1.1 : reset footer view
    [self showComplete:model];
    
    [self endRefreshing];
    
}

- (void)showError:(NSError *)error withModel:(VZHTTPListModel *)model
{
    NSLog(@"[%@]-->showError:{key:%@,section:%ld}",[self class], model.key,(long)model.sectionNumber);
    
    [self endRefreshing];
    
    if (model == _keyModel) {
        
        //VZMV* => 1.1 : 翻页出错的时候底部展示错误内容
        if(self.footerViewError)
        {
           // self.tableView.tableFooterView = self.footerViewError;
        }
        else
        {
           // self.tableView.tableFooterView =  [VZFooterViewFactory errorFooterView:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 44) Text:@"加载失败"];
        }
        
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
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate   = self.delegate;
    self.collectionView.collectionViewLayout = self.layout;
    [self.collectionView reloadData];
    
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
            [model load];
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
                [self.collectionView reloadData];
            }
            [model reload];
        }
    }];
}

- (void)loadModelByKey:(NSString* )targetKey
{
    VZAssertMainThread();
    
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        VZHTTPListModel* model = (VZHTTPListModel*)obj;
        
        if ([key isEqualToString : targetKey]) {
            [model load];
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
            [model reload];
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
    [self.delegate endRefreshing];
}
/**
 下拉刷新通知
 */
- (void)pullRefreshDidTrigger
{
    if (self.clearItemsWhenModelReload) {
        [self.dataSource removeAllItems];
        [self reloadTableView];
    }
    [self reload];
}



/////////////////////////////////////
#pragma mark - layout 

- (void)changeLayout:(VZCollectionViewLayout* ) layout Animate:(BOOL)aAnimate withCompletionBlock:(BOOL(^)(void))aBlock
{
    _layout = layout;
    _layout.controller = self;
    
    // __weak typeof (self) weakSelf = self;
    [self.collectionView setCollectionViewLayout:(UICollectionViewLayout* )layout animated:aAnimate completion:^(BOOL finished) {
        
        //weakSelf.collectionView.collectionViewLayout = (UICollectionViewLayout* )layout;
        
        if (aBlock) {
            aBlock();
        }
        
    }];
    
}


@end

@implementation VZCollectionViewController(Subclassing)

- (void)showNoResult:(VZHTTPListModel *)model
{
    NSLog(@"[%@]-->showNoResult:{key:%@,section:%ld}",[self class],model.key,(long)model.sectionNumber);
    
    [self endRefreshing];
    
    
    if (model == _keyModel) {
        
        if (self.footerViewNoResult)
        {
          //  self.tableView.tableFooterView = self.footerViewNoResult;
        }
        else
        {
         //   self.tableView.tableFooterView = [VZFooterViewFactory emptyFooterView];
        }
    }
    else
    {
        //VZ => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber) {
            
            NSInteger section = model.sectionNumber;
            //创建一个customized item
            VZListDefaultTextItem* item = [VZListDefaultTextItem new];
            item.itemType = kItem_Customize;
            item.text = @"没有结果";
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
    }
    
}
- (void)showComplete:(VZHTTPListModel *)model
{
    NSLog(@"[%@]-->showComplete:{section:%ld}",[self class],(long)model.sectionNumber);
    
    if (model == _keyModel) {
        
        if(self.footerViewComplete)
        {
           // self.tableView.tableFooterView = self.footerViewComplete;
        }
        else
        {
           // self.tableView.tableFooterView = [VZFooterViewFactory emptyFooterView];
        }
    }
    else
    {
        //todo:
    }
}
- (void)showLoadMoreFooterView
{
    NSLog(@"[%@]-->showLoadMoreFooterView",self.class);
    
//    self.tableView.tableFooterView = [VZFooterViewFactory clickableFooterView:CGRectMake(0, 0, self.tableView.frame.size.width, 44)Text:@"点一下加载更多" Target:self Action:@selector(onLoadMoreClicked:) ];
}

- (void)onLoadMoreClicked:(id)sender
{
    [self.keyModel loadMore];
}

@end

@implementation VZCollectionViewController(UIScrollView)


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

@end
