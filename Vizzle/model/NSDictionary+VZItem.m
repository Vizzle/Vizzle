//
//  NSDictionary+VZItem.m
//  VizzleListExample
//
//  Created by Yulin Ding on 30/11/2016.
//  Copyright © 2016 VizLab. All rights reserved.
//

#import "NSDictionary+VZItem.h"

@implementation NSDictionary (VZItem)

- (id)vz_valueForJSONKeyPath:(NSString *)JSONKeyPath {
    NSArray *components = [JSONKeyPath componentsSeparatedByString:@"."];
    
    id ret = self;
    NSInteger i = 0;
    for (NSString *component in components) {
        if (ret == nil ||
            ret == [NSNull null] ||
            ![ret isKindOfClass:[NSDictionary class]]) {
            break;
        };

        ret = ret[component];
        i++;
	}

	return ret;
}

@end
