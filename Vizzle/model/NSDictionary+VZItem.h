//
//  NSDictionary+VZItem.h
//  VizzleListExample
//
//  Created by Yulin Ding on 30/11/2016.
//  Copyright © 2016 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VZItem)

- (id)vz_valueForJSONKeyPath:(NSString *)JSONKeyPath;

@end
