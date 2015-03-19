// VZViewController.h 
// Vizzle
// created by Jayson Xu on 2014-09-15 15:35:19 +0800.
// Copyright (c) @VizLab. All rights reserved.
// 


#import <UIKit/UIKit.h>

@class VZModel;
@class VZViewModel;
@class VZTemplate;

@protocol VZModelDelegate;

@interface VZViewController : UIViewController<VZModelDelegate>
{
@protected
    NSMutableDictionary* _modelDictInternal;
@protected
    BOOL _receiveMemoryWarning;
}

/**
 *
 * controller的唯一标示
 */
@property(nonatomic,strong,readonly) NSString* uuid;
/**
 *  modelDictionary
 */
@property(nonatomic,strong,readonly) NSDictionary* modelDictionary;
/**
 * 
 * template
 */
@property(nonatomic,strong,readonly) VZTemplate* viewTemplate;
/**
 *
 * viewModel
 */
@property(nonatomic,strong) VZViewModel* viewModel;
/**
 *  recv memory warning
 */
@property(nonatomic,assign) BOOL receiveMemoryWarning;
/**
 *  注册Model，用于Model和ViewController进行数据通讯
 *
 *  @param model 数据Model
 */
- (void)registerModel:(VZModel *)model;

/**
 *  解除已注册的Model
 *
 *  @param model 数据Model
 */
- (void)unRegisterModel:(VZModel *)model;
/*
 *  注册Template
 *
 *  @param clz 数据Template
 */
- (void)registerViewTemplateClass:(Class )clz;
/*
 *  注册ViewModel
 *
 *  @param clz 数据ViewModel
 */
- (void)registerViewModel:(VZViewModel* )viewModel;
/**
 *  加载Model数据
 */
- (void)load;




@end


@interface VZViewController(Subclassing)

- (void)didLoadModel:(VZModel*)model;

- (BOOL)canShowModel:(VZModel*)model;

- (void)showEmpty:(VZModel *)model;

- (void)showModel:(VZModel *)model ;

- (void)showLoading:(VZModel *)model;

- (void)showError:(NSError *)error withModel:(VZModel*)model;


@end

/**
 *  处理memory warning
 */
@interface VZViewController(MemoryWarning)
/**
 *  默认返回为YES，则由基类负责处理MemoryWarning
 *
 *  重载返回NO，则由子类实现MemoryWarning的逻辑
 *
 *  @return BOOL
 */
- (BOOL)shouldHandleMemoryWarning;

@end