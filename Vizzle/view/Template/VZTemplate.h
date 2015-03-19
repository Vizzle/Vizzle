//
//  VZTemplate.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-14.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VZTemplate : NSObject
{

}

@property(nonatomic,copy) NSString* identifier;
@property(nonatomic,strong,readonly) UIView* contentView;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame Identifier:(NSString* )identifier;
- (void)createSubViews;
- (void)createBindings;
@end


@interface VZTemplate(SubClassing)

- (void)fire:(id)data id:(NSString* )identifier;

@end
