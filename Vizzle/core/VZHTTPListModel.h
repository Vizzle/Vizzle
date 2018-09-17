//
//  VZHTTPListModel.h
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZHTTPModel.h"

/**
 *  列表model的翻页模式
 */
typedef NS_OPTIONS(NSUInteger, VZPageMode) {
    /**
     *  有数据回来就自动翻页，否则停止翻页
     */
    VZPageModePageDefault        = 0,
    /**
     *  有数据回来，如果数量小于pagesize，则停止翻页
     *  有数据回来，且数量等于pagesize，则自动翻页
     *  没有数据回来，则停止翻页
     */
    VZPageModePageReturnCount    = 1,
    /**
     *  翻页依据自定义的totalCount，不依赖pagesize
     */
    VZPageModePageCustomize      = 2
};

@protocol VZHTTPListModel <VZHTTPModel>

@optional

/**
 *  根据返回的response，生成list数据
 */
- (NSArray* )responseObjects:(id)response;

/**
 *  当model loadmore前会调用这个方法。
 *  对某些特殊场景，这个方法应该返回False，比如当cache策略为default时，
 *  返回页数据来自缓存在某些场景会有问题。
 *  默认返回 YES
 */
- (BOOL)canLoadMore;

/**
 *  处理当前model中的数据
 *
 *  @notice:这个方法在model请求完成时调用，并且在异步线程执行
 *
 */
- (void)processCurrentObjects;


@end

@interface VZHTTPListModel : VZHTTPModel<VZHTTPListModel>

/**
 *  列表是否可以翻页
 */
@property(nonatomic,assign,readonly) BOOL hasMore;
/**
 *  分页模式，默认是 default
 */
@property (nonatomic, assign) VZPageMode pageMode;

/**
 * 分页当前页数
 */
@property(nonatomic, assign) NSInteger currentPageIndex;

/**
 * 列表总条数，根据 pageMode
 */
@property(nonatomic, assign) NSInteger totalCount;

/**
 *  分页个数，默认0
 */
@property(nonatomic, assign) NSInteger pageSize;
/**
 *  对应的section
 */
@property(nonatomic, assign) NSInteger sectionNumber;
/**
 *  数据
 */
@property(nonatomic,strong) NSMutableArray* objects;
/**
 * 加载完所有数据
 */
@property(nonatomic,assign) BOOL needLoadAll;


/**
 *  model加载更多的请求，如果当前也面是缓存数据，
 *  则会根据canLoadMore方法的返回值来判断是否可以翻页
 *
 *  @return loadMore是否被允许执行
 */
- (BOOL)loadMore;

/**
 *  model加载更多的请求，如果当前也面是缓存数据，
 *  则会根据canLoadMore方法的返回值来判断是否可以翻页
 *
 *  @param callBack 回调
 *
 *  @return loadMore是否被允许执行
 */
- (BOOL)loadMoreWithCompletion:(VZModelCallback)callBack;

/**
 * 翻页数据持续加载完成
 *  model加载更多的请求，如果当前也面是缓存数据，
 *  则会根据canLoadMore方法的返回值来判断是否可以翻页
 */
- (void)loadAll;

/**
 * 翻页数据持续加载完成，使用block做回调
 *  model加载更多的请求，如果当前也面是缓存数据，
 *  则会根据canLoadMore方法的返回值来判断是否可以翻页
 */
- (void)loadAllWithCompletion:(VZModelCallback)callBack;

@end
