// VZViewController.m 
// iCoupon 
//created by Tao Xu on 2014-09-15 15:35:19 +0800. 
// Copyright (c) @VizLab. All rights reserved.
// 

#import "VZViewController.h"
#import "VZHTTPModel.h"
#import "VZAssert.h"

@interface VZViewController ()
{

    //VZMV* => 1.4 Internal states of viewcontroller
    NSMutableDictionary* _states; //<key:model's key, value>
}

@end

@implementation VZViewController


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters



////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)modelDictionary
{
    return [_modelDictInternal copy];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =  [super initWithCoder:aDecoder];
    
    if (self) {
        
        _modelDictInternal = [NSMutableDictionary new];
        _states = [NSMutableDictionary new];
        _uuid = [[NSUUID UUID] UUIDString];
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _modelDictInternal = [NSMutableDictionary new];
        _states = [NSMutableDictionary new];
        _uuid = [[NSUUID UUID] UUIDString];
    }
    return self;
}

-(void)dealloc {
    
    
    
    VZAssertMainThread();
    [_modelDictInternal removeAllObjects];
    [_states removeAllObjects];
    
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)registerModel:(VZModel *)model{
    
    VZAssertMainThread();
    
    model.delegate = self;
    
    NSAssert(model.key != nil, @"model must have a key");

    [_modelDictInternal setObject:model forKey:model.key];
    [_states setObject:@"ready" forKey:model.key];
}

- (void)unRegisterModel:(VZModel *)model{
    
    VZAssertMainThread();
    
    NSAssert(model.key != nil, @"model must have a key");

    [_modelDictInternal removeObjectForKey:model.key];
    [_states removeObjectForKey:model.key];
}


- (void)load {
    
    VZAssertMainThread();
    [_modelDictInternal  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        VZHTTPModel *model = (VZHTTPModel*)obj;
        
        //解决遍历dictionary的时候，调用方调用unregister方法
        //to the next runloop
        dispatch_async(dispatch_get_main_queue(), ^{
            [model load];
        });
    }];
}

- (void)reload
{
    VZAssertMainThread();

    [_modelDictInternal  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        VZHTTPModel *model = (VZHTTPModel*)obj;
        
        //解决遍历dictionary的时候，调用方调用unregister方法
        //to the next runloop
        dispatch_async(dispatch_get_main_queue(), ^{
            [model reload];
        });
    }];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - model callback

- (void)modelDidStart:(VZModel *)model {
    
    [self showLoading:model];
    [self updateState:@"loading" withKey:model.key];
}

- (void)modelDidFinish:(VZModel *)model {
    
    [self didLoadModel:model];
    
    //VZMV* 1.1 => 修改了showEmpty逻辑
    if ([self canShowModel:model])
    {
        [self showModel:model];
        [self updateState:@"finished" withKey:model.key];
    }
    else
    {
        
        [self showEmpty:model];
        [self updateState:@"empty" withKey:model.key];
    }
}

- (void)modelDidFail:(VZModel *)model withError:(NSError *)error {
    
    if ( error.code == NSURLErrorCancelled) {
        [self updateState:@"finished" withKey:model.key];
    } else {
        [self showError:error withModel:model];
        [self updateState:@"error" withKey:model.key];
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark - private 

- (void)updateState:(id) status withKey:(NSString* )key
{
    VZAssertMainThread();
    
    if (status && key) {
        _states[key] = status;
        VZLog(@"status:%@",_states);
    }
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

- (void)showModel:(VZModel *)model
{
    //todo:
}

- (void)showEmpty:(VZModel *)model
{
    //todo:
}


- (void)showLoading:(VZModel*)model
{
    //todo:
}

- (void)showError:(NSError *)error withModel:(VZModel*)model
{
    //todo:
}

@end

