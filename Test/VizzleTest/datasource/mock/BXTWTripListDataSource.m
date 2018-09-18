//
//  BXTWTripListDataSource.m
//  VizzleTest
//
//  Created by moxin on 15/9/25.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "BXTWTripListDataSource.h"
#import "VZListCell.h"
#import "VZHTTPListModel.h"


@implementation BXTWTripListDataSource

- (Class)cellClassForItem:(VZListItem *)item AtIndex:(NSIndexPath *)indexPath
{
    return [VZListCell class];
}

- (void)tableViewControllerDidLoadModel:(VZHTTPListModel *)model
{
    NSMutableArray* list = model.objects;
    
    if (self.singleSection) {
        [self setItems:[list copy] ForSection:self.sectionIndex];
    }
    else
    {
        NSUInteger count = list.count / self.numberOfSection;
        for (int i=0; i<self.numberOfSection; i++) {
            
            NSArray* sublist = [list subarrayWithRange:NSMakeRange(i, count-1)];
            [self setItems:sublist ForSection:i];
        }
    }
   
}

@end
