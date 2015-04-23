  
//
//  BXFriendsListViewDataSource.m
//  BX
//
//  Created by Jayson.xu@foxmail.com on 2015-04-23 10:39:37 +0800.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//



#import "BXFriendsListViewDataSource.h"
#import "BXFriendsListCell.h"

@interface BXFriendsListViewDataSource()

@end

@implementation BXFriendsListViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    
    return [BXFriendsListCell class];
    

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end  
