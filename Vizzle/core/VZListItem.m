//
//  VZListItem.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZListItem.h"

@implementation VZListItem

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.indexPath     forKey:@"indexPath"];
    [aCoder encodeObject:@(self.itemHeight) forKey:@"itemHeight"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.indexPath = [aDecoder decodeObjectForKey:@"indexPath"];
        self.itemHeight = ((NSNumber*)[aDecoder decodeObjectForKey:@"itemHeight"]).floatValue;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    VZListItem* item  = [super copyWithZone:zone];
    item.indexPath = self.indexPath;
    item.itemHeight = self.itemHeight;
    
    return item;
}


@end
