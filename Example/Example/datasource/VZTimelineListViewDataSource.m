  
//
//  VZTimelineListViewDataSource.m
//  VizzleListExample
//
//  Created by Tao Xu on 2014-09-29 13:48:38 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZTimelineListViewDataSource.h"
#import "VZTimelineListCell.h"

@interface VZTimelineListViewDataSource()

@end

@implementation VZTimelineListViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    return [VZTimelineListCell class];

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end  
