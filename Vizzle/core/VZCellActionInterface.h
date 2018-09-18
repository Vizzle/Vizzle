//
//  VZCellActionInterface.h
//  VizzleListExample
//
//  Created by moxin on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VZCellActionInterface <NSObject>

@optional
- (void)onCellComponentClickedAtIndex:(NSIndexPath*)indexPath Bundle:(NSDictionary*)extra;

@end
