  
//
//  VZFlickrListViewDataSource.m
//  VizzleListExample
//
//  Created by moxinxt on 2014-10-01 22:14:53 +0800.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//



#import "VZFlickrListViewDataSource.h"
#import "VZFlickrListCell.h"

@interface VZFlickrListViewDataSource()

@end

@implementation VZFlickrListViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    return [VZFlickrListCell class];

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end  
