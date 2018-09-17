// VZModel.h 
// iCoupon 
//created by Tao Xu on 2014-09-15 15:35:19 +0800. 
// Copyright (c) @VizLab. All rights reserved.
// 


#import <Foundation/Foundation.h>


/**
 * Model的状态
 *
 * v= VZModel=>1.1:增加finished
 */
typedef NS_OPTIONS(NSInteger, VZModelState) {
    VZModelStateError     = -1,
    VZModelStateReady     = 0,
    VZModelStateLoading   = 1,
    VZModelStateFinished  = 2
    
};



@class VZModel;

/**
 *  Model请求结果的回调
 *
 *  @param model 当前model
 *  @param error 错误信息
 */
typedef void(^VZModelCallback) (VZModel* model, NSError* error);

@protocol VZModelDelegate <NSObject>

@optional
/**
 *  model开始请求
 *
 *  @param model 当前model
 */
- (void)modelDidStart:(VZModel *)model;
/**
 *  model结束请求
 *
 *  @param model 当前model
 */
- (void)modelDidFinish:(VZModel *)model;
/**
 *  model请求失败
 *
 *  @param model 当前model
 *  @param error 错误
 */
- (void)modelDidFail:(VZModel *)model withError:(NSError *)error;

@end

@interface VZModel : NSObject

/**
 * Model的状态
 *
 * VZModel=>1.1
 */
@property (nonatomic, assign,readonly) VZModelState state;
/**
 *  Model的delegate，用于发送Model状态
 */
@property(nonatomic, weak) id<VZModelDelegate> delegate;
/**
 *  错误对象，默认为nil
 */
@property(nonatomic, strong,readonly) NSError *error;

/**
 *  Model的key，用于标识Model
 */
@property(nonatomic,strong) NSString* key;
/**
 *  用于第一次model请求，回调使用delegate
 */
- (void)load;
/**
 *  model重新请求数据，会重置model的状态，回调使用delegate
 */
- (void)reload;
/**
 * model的请求操作，回调使用block
 *
 * VZModel=>1.1
 *
 * 使用这个方法需要注意：
 * model的状态不会和controller耦合，对界面的更新放到回调中执行
 * 注意block中使用__weak，避免循环引用！
 *
 */
- (void)loadWithCompletion:(VZModelCallback)aCallback;
/**
 * model的重新请求操作，回调使用block
 *
 * VZModel=>1.1
 *
 * 使用这个方法需要注意：
 * model的状态不会和controller耦合，对界面的更新放到回调中执行
 * 注意block中使用__weak，避免循环引用！
 *
 */
- (void)reloadWithCompletion:(VZModelCallback)aCallback;
/**
 *  取消model请求
 */
- (void)cancel;
/**
 *  清空model数据，重置model的状态
 */
- (void)reset;


@end


@interface VZModel(CallBack)

- (void)didStartLoading;
- (void)didFinishLoading;
- (void)didFailWithError:(NSError* )error;


@end


@interface VZModel(SubclassingHooks)

- (BOOL)shouldLoad;

@end

