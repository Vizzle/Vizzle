  
//
//  BXTWTripListViewDataSource.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-07-14 21:28:18 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXTWTripListViewDataSource.h"
#import "BXTWTripListCell.h"

@interface BXTWTripListViewDataSource()

@end

@implementation BXTWTripListViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    return [BXTWTripListCell class];
    
}




@end  
