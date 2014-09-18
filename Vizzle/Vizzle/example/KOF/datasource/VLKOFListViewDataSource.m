  
//
//  VLKOFListViewDataSource.m
//  KOF97
//
//  Created by Jayson Xu on 2014-09-18 22:48:47 +0800.
//  Copyright (c) 2014年 VizLab: http://vizlab.com. All rights reserved.
//



#import "VLKOFListViewDataSource.h"
#import "VLKOFListCell.h"

@interface VLKOFListViewDataSource()

@end

@implementation VLKOFListViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    return [VLKOFListCell class];

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end  
