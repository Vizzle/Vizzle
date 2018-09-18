//
//  vzViewControllerTests.m
//  vzViewControllerTests
//
//  Created by moxin.xt on 14-5-14.
//  Copyright (c) 2014年 taobao.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VZModel.h"
#import <libkern/OSAtomic.h>


#define kTest_1_1 @"kTest_1_1"
#define kTest_1_2 @"kTest_1_2"
#define kTest_1_3 @"kTest_1_3"
#define kTest_2_1 @"kTest_2_1"
#define kTest_2_2 @"kTest_2_2"
#define kTest_2_3 @"kTest_2_3"
#define kTest_2_4 @"kTest_2_4"
#define kTest_2_5 @"kTest_2_5"
#define kTest_2_6 @"kTest_2_6"
#define kTest_2_7 @"kTest_2_7"



@interface vzViewControllerTests : XCTestCase
{
    //VZMV* => 1.4 Internal states of viewcontroller
    NSMutableDictionary* _states; //<key:model's key, value>
    
    //lock here
    OSSpinLock _lock;
    
    //model dictionary
    NSMutableDictionary* _modelDictInternal;
    
    //test no:
    NSString* _testNO;
    
}

@property(nonatomic,strong) VZModel* vzModel1;
@property(nonatomic,strong) VZModel* vzModel2;
@property(nonatomic,strong) VZModel* vzMdoel3;

@end

@implementation vzViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _states = [NSMutableDictionary new];
    _modelDictInternal = [NSMutableDictionary new];
    
    _lock = OS_SPINLOCK_INIT;
    
    self.vzModel1 = [VZModel new];
    self.vzModel2 = [VZModel new];
    self.vzMdoel3 = [VZModel new];
 
    

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [_modelDictInternal removeAllObjects];
    _modelDictInternal = nil;
    
    _vzModel1 = nil;
    _vzModel2 = nil;
    _vzMdoel3 = nil;
}

/**
 *  测试单个model:loading -> finish -> canShow(yes) -> showModel
 */
- (void)testCase_1_1
{
    _testNO = kTest_1_1;
    self.vzModel1.key = @"1_1";
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    
    [self mock_modelDidStart:self.vzModel1];
    
    [self runDelay:1.0f];
 
    [self mock_modelDidFinish:self.vzModel1];

}
/**
 *  测试单个model:loading -> finish -> canShow(no) -> showEmpty
 */
- (void)testCase_1_2
{
    _testNO = kTest_1_2;
    self.vzModel1.key = @"1_2";
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    
    [self mock_modelDidStart:self.vzModel1];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel1];
    
}
/**
 *  测试单个model：loading -> error -> showError
 */
- (void)testCase_1_3
{
    _testNO = kTest_1_3;
    self.vzModel1.key = @"1_3";
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    
    [self mock_modelDidStart:self.vzModel1];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFail:self.vzModel1 withError:[NSError new]];
}

/**
 *  测试两个model：
 * 
 *  model1 : loading -> finished -> canshow(yes) --> showmodel
 *
 *  model2 : loading -> finished -> canshow(yes) --> showmodel
 *
 */
- (void)testCase_2_1
{
    _testNO = kTest_2_1;
    self.vzModel1.key = @"2_1_1";
    self.vzModel2.key = @"2_1_2";
    
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    [_modelDictInternal setObject:self.vzModel2 forKey:self.vzModel2.key];
    
    [self mock_modelDidStart:self.vzModel1];
    [self mock_modelDidStart:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel1];
    
}

/**
 *  测试两个model：
 *
 *  model1 : loading -> finished -> canshow(NO) --> showempty
 *
 *  model2 : loading -> finished -> canshow(yes) --> showmodel
 *
 */
- (void)testCase_2_2
{
    _testNO = kTest_2_2;
    self.vzModel1.key = @"2_2_1";
    self.vzModel2.key = @"2_2_2";
    
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    [_modelDictInternal setObject:self.vzModel2 forKey:self.vzModel2.key];
    
    [self mock_modelDidStart:self.vzModel1];
    [self mock_modelDidStart:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel1];
    
}

/**
 *  测试两个model：
 *
 *  model1 : loading -> finished -> canshow(no) --> showempty
 *
 *  model2 : loading -> finished -> canshow(no) --> showempty
 *
 */
- (void)testCase_2_3
{
    _testNO = kTest_2_3;
    self.vzModel1.key = @"2_3_1";
    self.vzModel2.key = @"2_3_2";
    
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    [_modelDictInternal setObject:self.vzModel2 forKey:self.vzModel2.key];
    
    [self mock_modelDidStart:self.vzModel1];
    [self mock_modelDidStart:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel1];
    
}

/**
 *  测试两个model：
 *
 *  model1 : loading -> error -> showerror
 *
 *  model2 : loading -> finished -> canshow(yes) --> showmodel
 *
 */
- (void)testCase_2_4
{
    _testNO = kTest_2_4;
    self.vzModel1.key = @"2_4_1";
    self.vzModel2.key = @"2_4_2";
    
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    [_modelDictInternal setObject:self.vzModel2 forKey:self.vzModel2.key];
    
    [self mock_modelDidStart:self.vzModel1];
    [self mock_modelDidStart:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFinish:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFail:self.vzModel1 withError:[NSError new]];
    
}

/**
 *  测试两个model：
 *
 *  model1 : loading -> error -> showerror
 *
 *  model2 : loading -> error -> showerror
 *
 */
- (void)testCase_2_5
{
    _testNO = kTest_2_5;
    self.vzModel1.key = @"2_5_1";
    self.vzModel2.key = @"2_5_2";
    
    [_modelDictInternal setObject:self.vzModel1 forKey:self.vzModel1.key];
    [_modelDictInternal setObject:self.vzModel2 forKey:self.vzModel2.key];
    
    [self mock_modelDidStart:self.vzModel1];
    [self mock_modelDidStart:self.vzModel2];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFail:self.vzModel1 withError:[NSError new]];
    
    [self runDelay:1.0f];
    
    [self mock_modelDidFail:self.vzModel1 withError:[NSError new]];
    
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - helper methods


- (void)runDelay:(NSInteger)delaySec
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:delaySec];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }

}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - mock model state

- (void)mock_modelDidStart:(VZModel *)model {
    
    [self showLoading:model];
    [self updateState:@"loading" withKey:model.key];
}

- (void)mock_modelDidFinish:(VZModel *)model {
    
    [self didLoadModel:model];
    
    //vzMVC 1.1 => 修改了showEmpty逻辑
    if ([self canShowModel:model])
    {
        [self showModel:model];
        [self updateState:@"model" withKey:model.key];
    }
    else
    {
        [self showEmpty:model];
        [self updateState:@"empty" withKey:model.key];
    }
}

- (void)mock_modelDidFail:(VZModel *)model withError:(NSError *)error {
    
    [self showError:error withModel:model];
    [self updateState:@"error" withKey:model.key];
}

- (void)updateState:(id) status withKey:(NSString* )key
{
    if (status && key) {
        
        OSSpinLockLock(&_lock);
        
        _states[key] = status;
        NSLog(@"[%@]-->status:%@",self.class,_states);
        
        OSSpinLockUnlock(&_lock);
    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - mock controller state

- (void)didLoadModel:(VZModel*)model{
}

- (BOOL)canShowModel:(VZModel*)model
{
    if ([_modelDictInternal.allKeys containsObject:model.key]) {
        
        //MOCK:
        
        //test 1:
        if ([_testNO isEqualToString:kTest_1_1]) {
            return YES;
        }
        
        //test 2:
        if ([_testNO isEqualToString:kTest_1_2]) {
            return NO;
        }
        
        //test 3
        if ([_testNO isEqualToString:kTest_1_3]) {
            return YES;
        }
        
        //test 4
        if ([_testNO isEqualToString:kTest_2_1]) {
            
            return YES;
        }
        
        //test 5
        if ([_testNO isEqualToString:kTest_2_2]) {
            
            
            if ([model.key isEqualToString:@"2_2_1"]) {
                return NO;
            }
            
            if ([model.key isEqualToString:@"2_2_2"]) {
                return YES;
            }
        }
        
        //test 6
        if ([_testNO isEqualToString:kTest_2_3]) {
            
            return NO;
        }
        
        //test 7
        if ([_testNO isEqualToString:kTest_2_4]) {
            
            return YES;
        }
        
        //test 8
        if ([_testNO isEqualToString:kTest_2_5]) {
            
            return YES;
        }
        
        
        return YES;
    }
    else
        return NO;
    

    
}

- (void)showEmpty:(VZModel *)model {

    NSLog(@"[TEST]-->showEmpty:%@",model.key);
    
    //test 1:
    if ([_testNO isEqualToString:kTest_1_1]) {
        
        XCTFail(@"test 1_1 failed!!");
    }
    
    //test 2:
    if ([_testNO isEqualToString:kTest_1_2]) {
        
        //succeed !
        NSLog(@"[TEST]-->SUCCEED!!");
    }
    
    //test 3
    if ([_testNO isEqualToString:kTest_1_3]) {
       
        XCTFail(@"test 1_3 failed!!");
    }
    
    //test 4
    if ([_testNO isEqualToString:kTest_2_1]) {
        
        if ([model.key isEqualToString:@"2_1_1"]) {
            
            XCTFail(@"test 2_1 failed!!");
        }
        
        if ([model.key isEqualToString:@"2_2_2"]) {
            
            XCTFail(@"test 2_1 failed!!");
        }
    }
    
    //test 5
    if ([_testNO isEqualToString:kTest_2_2]) {
        
        
        if ([model.key isEqualToString:@"2_2_1"]) {
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
        }

    }
    
    //test 6
    if ([_testNO isEqualToString:kTest_2_3]) {
        
        
        if ([model.key isEqualToString:@"2_3_1"]) {
            
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
        }
       
    }
    
    //test 7
    if ([_testNO isEqualToString:kTest_2_4]) {
     
        if ([model.key isEqualToString:@"2_4_1"]) {
            
            XCTFail(@"test 2_2 failed!!");
            
        }
        
        if ([model.key isEqualToString:@"2_4_2"]) {
            
            XCTFail(@"test 2_2 failed!!");
        }
    }
    
    
    //test 8
    if ([_testNO isEqualToString:kTest_2_5]) {
        
        
        if ([model.key isEqualToString:@"2_5_1"]) {
            
            XCTFail(@"test 2_2 failed!!");
            
        }
        
        if ([model.key isEqualToString:@"2_5_2"]) {
            
            XCTFail(@"test 2_2 failed!!");
        }
    }

    

}


- (void)showLoading:(VZModel*)model{
    
    NSLog(@"[TEST]-->showLoading:%@",model.key);
    
    
    
}

- (void)showModel:(VZModel *)model{
    
    NSLog(@"[TEST]-->showModel:%@",model.key);
    
    //test 1:
    if ([_testNO isEqualToString:kTest_1_1]) {
        
        //succeed!
        NSLog(@"[TEST]-->SUCCEED!!");
    }
    
    //test 2:
    if ([_testNO isEqualToString:kTest_1_2]) {
        
        //succeed !
        XCTFail(@"test 1_2 failed!!");
    }
    
    //test 3
    if ([_testNO isEqualToString:kTest_1_3]) {
        
        XCTFail(@"test 1_3 failed!!");
    }
    
    //test 4
    if ([_testNO isEqualToString:kTest_2_1]) {
        
        if ([model.key isEqualToString:@"2_1_1"]) {
            
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
        }
        
        if ([model.key isEqualToString:@"2_1_2"]) {
            
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
        }
    }
    
    //test 5
    if ([_testNO isEqualToString:kTest_2_2]) {
        
        if ([model.key isEqualToString:@"2_2_1"]) {
            
            XCTFail(@"test 2_2 failed!!");
         
        }
        
    }
    
    //test 6
    if ([_testNO isEqualToString:kTest_2_3]) {
        
        if ([model.key isEqualToString:@"2_3_1"]) {
            
            XCTFail(@"test 2_3 failed!!");
            
        }
        
        if ([model.key isEqualToString:@"2_3_2"]) {
            
            XCTFail(@"test 2_3 failed!!");
        }
        
    }
    
    //test7
    if ([_testNO isEqualToString:kTest_2_4]) {
        
        if ([model.key isEqualToString:@"2_4_1"]) {
            
            XCTFail(@"test 2_4 failed!!");
            
        }
        
        if ([model.key isEqualToString:@"2_4_2"]) {
            
            NSLog(@"[TEST]-->SUCCEED!!");
        }
        
    }
    
    //test7
    if ([_testNO isEqualToString:kTest_2_5]) {
        
        if ([model.key isEqualToString:@"2_5_1"]) {
            
            NSLog(@"[TEST]-->SUCCEED!!");
            
        }
        
        if ([model.key isEqualToString:@"2_5_2"]) {
            
            NSLog(@"[TEST]-->SUCCEED!!");
        }
        
    }
}

- (void)showError:(NSError *)error withModel:(VZModel*)model{
    
    NSLog(@"[TEST]-->showError:%@",model.key);
    
    //test 1:
    if ([_testNO isEqualToString:kTest_1_1]) {
        
        XCTFail(@"test 1_1 failed!!");
    }
    
    //test 2:
    if ([_testNO isEqualToString:kTest_1_2]) {

        XCTFail(@"test 1_2 failed!!");
    }
    
    //test 3
    if ([_testNO isEqualToString:kTest_1_3]) {
        
        //succeed!
        NSLog(@"[TEST]-->SUCCEED!!");
    }
    
    //test 4
    if ([_testNO isEqualToString:kTest_2_1]) {
        
        if ([model.key isEqualToString:@"2_1_1"]) {
            
            XCTFail(@"test 2_1 failed!!");
        }
        
        if ([model.key isEqualToString:@"2_2_2"]) {
            
            XCTFail(@"test 2_1 failed!!");
        }
    }
    
    //test 5
    if ([_testNO isEqualToString:kTest_2_2]) {
        
        if ([model.key isEqualToString:@"2_2_1"]) {
            
            XCTFail(@"test 2_2 failed!!");
            
        }
        
        if ([model.key isEqualToString:@"2_2_2"]) {
            
            XCTFail(@"test 2_2 failed!!");
        }
        
    }
    
    //test 6
    if ([_testNO isEqualToString:kTest_2_3]) {
        
        if ([model.key isEqualToString:@"2_3_1"]) {
            
            XCTFail(@"test 2_3 failed!!");
            
        }
        
        if ([model.key isEqualToString:@"2_3_2"]) {
            
            XCTFail(@"test 2_3 failed!!");
        }
    }
    
    //test 7
    if ([_testNO isEqualToString:kTest_2_4]) {
        
        if ([model.key isEqualToString:@"2_4_1"]) {
            
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
            
        }
        
        if ([model.key isEqualToString:@"2_4_2"]) {
            
            XCTFail(@"test 2_4 failed!!");
        }
    }
    
    //test 8
    if ([_testNO isEqualToString:kTest_2_5]) {
        
        if ([model.key isEqualToString:@"2_5_1"]) {
            
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
            
        }
        
        if ([model.key isEqualToString:@"2_5_2"]) {
            
            //succeed!
            NSLog(@"[TEST]-->SUCCEED!!");
        }
    }
}



@end
