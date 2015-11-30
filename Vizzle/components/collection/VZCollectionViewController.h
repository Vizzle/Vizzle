//
//  VZCollectionViewController.h
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZViewController.h"

@class VZCollectionViewDataSource;
@class VZCollectionViewDelegate;
@class VZCollectionViewLayout;
@class VZHTTPListModel;
@protocol VZCollectionViewLayoutInterface;
@interface VZCollectionViewController : VZViewController

@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) VZCollectionViewDataSource* dataSource;
@property(nonatomic,strong) VZCollectionViewDelegate* delegate;
@property(nonatomic,strong) id<VZCollectionViewLayoutInterface> layout;

/**
 *  自定义collectionview的footerview样式
 *
 *  @discussion: 默认样式来自[VZFooterViewFactory]
 */
@property(nonatomic,strong) UIView* footerViewLoading;
@property(nonatomic,strong) UIView* footerViewError;
@property(nonatomic,strong) UIView* footerViewNoResult;
/**
 *  keyModel:@REQUIRED : 用来翻页的model，必须不为空
 */
@property(nonatomic,strong) VZHTTPListModel* keyModel;
/**
 *  自动翻页的标志位
 */
@property(nonatomic,assign) BOOL loadmoreAutomatically;
/**
 *  是否需要翻页
 */
@property(nonatomic,assign) BOOL needLoadMore;
/**
 *  是否需要下拉刷新
 */
@property(nonatomic,assign) BOOL needPullRefresh;
/**
 *  model reload的时候是否清空当前数据,默认为YES
 */
@property(nonatomic,assign) BOOL clearItemsWhenModelReload;



/**
 *  翻页加载
 *
 *  @discussion：
 *
 *  列表只缓存第一页数据，当第一页数据为缓存时，loadMore不会执行
 *
 */
- (void)loadMore;
/**
 * 加载某个section对应的model，保留cache策略
 */
- (void)loadModelForSection:(NSInteger)section;
/**
 *  reload section对应的model，忽略cache策略
 *
 *  @param section 对应的section
 */
- (void)reloadModelForSection:(NSInteger)section;
/**
 *  根据model的key来加载model，保留cache策略
 *
 *  @param key
 */
- (void)loadModelByKey:(NSString* )key;
/**
 *  根据model的key来加载model，忽略cache策略
 *
 *  @param key
 */
- (void)reloadModelByKey:(NSString* )key;
/**
 * 显示下拉刷新
 */
- (void)beginRefreshing;
/**
 * 隐藏下拉刷新
 */
- (void)endRefreshing;



@end

@interface VZCollectionViewController(layout)

/**
 *  切换collectionView布局
 *
 *  @param layout 布局对象
 *  @param b      是否支持动画
 */
- (void)changeLayout:(id<VZCollectionViewLayoutInterface> ) layout animated:(BOOL)b;

@end



@interface VZCollectionViewController(SupplymentaryView)

/**
 *  设置section header
 *
 *  @param cls     HeaderView类型
 *  @param key     reuseIdentifier
 *  @param section section number
 *  @param block   对HeaderView进行配置的block
 */
- (void)registerHeaderViewClass:(Class)cls WithKey:(NSString*)key ForSection:(NSInteger)section Configuration:(void(^)(UICollectionReusableView* view, id data))block;
/**
 *  设置section footer
 *
 *  @param cls     FooterView类型
 *  @param key     reuseIdentifier
 *  @param section section number
 *  @param block   对HeaderView进行配置的block
 */
- (void)registerFooterViewClass:(Class)cls WithKey:(NSString*)key ForSection:(NSInteger)section Configuration:(void(^)(UICollectionReusableView* view, id data))block;


@end

@interface VZCollectionViewController(UICollectionView)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface VZCollectionViewController(UIScrollView)

/**
 * scrollview的滚动回调
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
/**
 * scrollview拖拽释放后的回调
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/**
 * scrollview拖拽事件回调
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView ;
/**
 * scrollview停止滚动回调
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView ;

@end


@interface VZCollectionViewController(State)

- (void)showEmptyFooterView;
- (void)showLoadingFooterView;
- (void)showErrorFooterView;
- (void)showNoResultFooterView;
- (void)showLoadMoreFooterView;

@end