// VZViewController.m 
// iCoupon 
//created by Jayson Xu on 2014-09-15 15:35:19 +0800. 
// Copyright (c) @VizLab. All rights reserved.
// 

#import "VZViewController.h"
#import "VZViewControllerLogic.h"
#import "VizzleConfig.h"
#import "VZHTTPModel.h"

@interface VZViewController ()<VZViewControllerLogicInterface>
{
    //VZMV* => 1.1 Internal status of viewcontroller
    enum ModelStatus{bEmpty,bLoading,bModel,bError} _status;
    
    //VZMV* => 1.1 Internal state of viewcontroller
    struct InternalState { enum ModelStatus status; char* key;}_state __unused;
}

@end

@implementation VZViewController
@synthesize logic = _logic;


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setLogic:(VZViewControllerLogic *)logic
{
    _logic = logic;
    _logic.viewController = self;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)modelDictionary
{
    return [_modelDictInternal copy];
}
- (VZViewControllerLogic* )logic
{
    if (!_logic) {
        _logic = [VZViewControllerLogic new];
        _logic.viewController = self;
    }
    return _logic;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self = [self init];
        
        
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _modelDictInternal = [NSMutableDictionary new];
        _status = bEmpty;
        
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
    
    [self.logic logic_view_did_load];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.logic logic_view_will_appear];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.logic logic_view_did_appear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.logic logic_view_will_disappear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.logic logic_view_did_disappear];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {
    
    VZLog(@"[%@]-->dealloc",self.class);
    
    [self.logic logic_dealloc];
    
    [_modelDictInternal removeAllObjects];
    _modelDictInternal    = nil;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)registerModel:(VZModel *)model{
    model.delegate = self;
    [_modelDictInternal setObject:model forKey:model.key];
}

- (void)unRegisterModel:(VZModel *)model{
    
    [_modelDictInternal removeObjectForKey:model.key];
    
    
}

- (void)load {
    
    //解决遍历dictionary的时候，调用方调用unregister方法
    [_modelDictInternal  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        VZHTTPModel *model = (VZHTTPModel*)obj;
        
        //to the next runloop
        dispatch_async(dispatch_get_main_queue(), ^{
            [model load];
        });
    }];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - model callback

- (void)modelDidStart:(VZModel *)model {
    
    _status = bLoading;
    VZLog(@"[%@]-->{status : loading}",self.class);
    [self showLoading:model];
}

- (void)modelDidFinish:(VZModel *)model {
    
    [self didLoadModel:model];
    
    //VZMV* 1.1 => 修改了showEmpty逻辑
    if ([self canShowModel:model])
    {
        _status = bModel;
        VZLog(@"[%@]-->{status : model}",self.class);
        [self showModel:model];
    }
    else
    {
        if (_status != bModel
            && _status != bError
            && _status != bEmpty) {
            
            _status = bEmpty;
            VZLog(@"[%@]-->{status : empty}",self.class);
            [self showEmpty:model];
        }
        else
        {
            //noop;
            VZLog(@"[%@]-->{status : invalid}",self.class);
        }
    }
}

- (void)modelDidFail:(VZModel *)model withError:(NSError *)error {
    
    _status = bError;
    VZLog(@"[%@]-->{status : error}",self.class);
    [self showError:error withModel:model];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - logic action callback

- (void)onControllerShouldPerformAction:(int)type args:(NSDictionary* )dict
{
    
}

@end 


////////////////////////////////////////////////////////////////////////
@implementation VZViewController(Subclassing)

- (void)didLoadModel:(VZModel*)model{
}

- (BOOL)canShowModel:(VZModel*)model
{
    if ([_modelDictInternal.allKeys containsObject:model.key]) {
        return YES;
    }
    else
        return NO;
    
}

- (void)showModel:(VZModel *)model{
    
}



- (void)showEmpty:(VZModel *)model {
    
}


- (void)showLoading:(VZModel*)model{

    
}

- (void)showError:(NSError *)error withModel:(VZModel*)model{

}

@end

@implementation VZViewController(MemoryWarning)

- (BOOL)shouldHandleMemoryWarning
{
    return YES;
}

@end