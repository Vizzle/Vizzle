//
//  VZListViewDataSource.m
//  Vizzle
//
//  Created by Tao Xu on 14-9-15.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZListViewDataSource.h"
#import "VZListViewDelegate.h"
#import "VZListViewController.h"
#import "VZCellActionInterface.h"
#import "VZListCell.h"
#import "VZListItem.h"
#import "VZListDefaultLoadingCell.h"
#import "VZListDefaultErrorCell.h"
#import "VZListDefaultTextCell.h"
#import "VZHTTPListModel.h"
#import "VZAssert.h"

@interface VZListViewDataSource()
{
    NSMutableDictionary* _itemsForSectionInternal;
}

@end

@implementation VZListViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)itemsForSection
{
    return _itemsForSectionInternal;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    
    if (self) {
        _itemsForSectionInternal      = [NSMutableDictionary new];
       
    }
    return self;
}
- (void)dealloc
{
    _controller = nil;
    [_itemsForSectionInternal removeAllObjects];
    _itemsForSectionInternal = nil;
 
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (BOOL)insertSectionAtIndex:(NSInteger)sectionIndex withItems:(NSArray* )items
{
    VZAssertMainThread();
    
    VZAssertTrue(items && [items isKindOfClass:[NSArray class]]);
    
    NSUInteger numberOfSection = _itemsForSectionInternal.count;
    
    VZAssertTrue(sectionIndex >= 0 && sectionIndex <= numberOfSection);
    
    //insert at bottom
    if (sectionIndex == numberOfSection) {
        
        _itemsForSectionInternal[@(sectionIndex)] = [items mutableCopy];
        return YES;
    }
    
    //inseret at top & middle
    if (sectionIndex >= 0 && sectionIndex < numberOfSection)
    {
        
        for (int i=0; i<numberOfSection; i++)
        {
            if (i == sectionIndex) {
                
                for (int j = (int)numberOfSection-1; j >= i; j--){
                    _itemsForSectionInternal[@(j+1)] = _itemsForSectionInternal[@(j)];
                }
                _itemsForSectionInternal[@(sectionIndex)] = [items mutableCopy];
                
  
                break;
            }
        }
  
        //重新绑定items的indexpath
        [self reloadAllItems];
        
        return YES;
    }

    return NO;
}

- (BOOL)removeSectionByIndex:(NSInteger)sectionIndex
{
    VZAssertMainThread();
    
    NSUInteger numberOfSection = _itemsForSectionInternal.count;
    
    VZAssertTrue(sectionIndex >= 0 && sectionIndex < numberOfSection);
    
    if (sectionIndex >= 0 && sectionIndex < numberOfSection)
    {
        for (int i=0; i<numberOfSection; i++)
        {
            if (i == sectionIndex) {
                
                for (int j=i; j<= numberOfSection-i; j++) {
                  _itemsForSectionInternal[@(j)] = _itemsForSectionInternal[@(j+1)];
                }
                [_itemsForSectionInternal removeObjectForKey:@(numberOfSection-1)];
                break;
            }
        }
        
        //重新绑定items的indexpath
        [self reloadAllItems];
        
        return YES;
    }
    
    return NO;
}


- (BOOL)setItems:(NSArray*)items ForSection:(NSInteger)n
{
    VZAssertMainThread();
    VZAssertTrue(items && [items isKindOfClass:[NSArray class]]);
    VZAssertTrue(n>=0);
    
    if (n < 0) {
        return NO;
    }
    
    if ( items && [items isKindOfClass:[NSArray class]])
    {
        [_itemsForSectionInternal setObject:[items mutableCopy] forKey:@(n)];
        //重新绑定item的indexpath
        [self reloadItemsForSection:n];
        return YES;
        
    }
    return NO;
}

- (NSArray *)itemsForSection:(NSInteger)section
{
    VZAssertMainThread();
    VZAssertTrue(section >=0 && section < [_itemsForSectionInternal count]);
    
    if (section < [_itemsForSectionInternal count])
    {
        return _itemsForSectionInternal[@(section)];
    }
    else
        return nil;
}

- (BOOL)insertItem:(VZListItem* )item AtIndexPath:(NSIndexPath* )indexPath
{
    VZAssertMainThread();
    VZAssertTrue(item && [item isKindOfClass:[VZListItem class]]);
    VZAssertTrue(indexPath.section < _itemsForSectionInternal.count);
    
    if([item isKindOfClass:[VZListItem class]])
    {
        if(indexPath.section < _itemsForSectionInternal.count)
        {
            NSMutableArray* list = [_itemsForSectionInternal objectForKey:@(indexPath.section)];
            
            if (list.count > 0 && indexPath.row <= list.count) {
                
                [list insertObject:item atIndex:indexPath.row];
                //重新绑定item的indexpath
                [self reloadItemsForSection:indexPath.section];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)replaceItem:(VZListItem* )item AtIndexPath:(NSIndexPath* )indexPath
{
    VZAssertMainThread();
    VZAssertTrue(item && [item isKindOfClass:[VZListItem class]]);
    VZAssertTrue(indexPath.section < _itemsForSectionInternal.count);
    
    if([item isKindOfClass:[VZListItem class]])
    {
        if(indexPath.section < _itemsForSectionInternal.count)
        {
            NSMutableArray* list = [_itemsForSectionInternal objectForKey:@(indexPath.section)];
            
            if (list.count > 0 && indexPath.row < list.count) {
                
                if ([list objectAtIndex:indexPath.row]) {
                    
                    [list replaceObjectAtIndex:indexPath.row withObject:item];
                    //重新绑定item的indexpath
                    [self reloadItemsForSection:indexPath.section];
                    return YES;
                }
            }
        }
    }
    return NO;
}


- (BOOL)removeItemAtIndexPath:(NSIndexPath* )indexPath
{
    VZAssertMainThread();
    VZAssertTrue(indexPath.section < _itemsForSectionInternal.count);
    
    if(indexPath.section < _itemsForSectionInternal.count)
    {
        NSMutableArray* list = [_itemsForSectionInternal objectForKey:@(indexPath.section)];
        
        if (list.count > 0 && indexPath.row < list.count) {
            
            [list removeObjectAtIndex:indexPath.row];
            //重新绑定item的indexpath
            [self reloadItemsForSection:indexPath.section];
            return YES;
        }
    }
    return NO;
}

- (void)reloadItemsForSection:(NSUInteger)section{
    
    VZAssertMainThread();
    NSArray* items = [self itemsForSection:section];
    for (int i=0; i<items.count; i++) {
        
        VZListItem* item = items[i];
        item.indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        if(i==items.count-1){
            item.isLast = YES;
        }
        else{
            item.isLast = NO;
        }
    }
}

//- (BOOL)removeItemsForSection:(NSInteger)n
//{
//    VZAssertMainThread();
//    
//    if (n>=0 && n < _itemsForSectionInternal.count) {
//        [_itemsForSectionInternal removeObjectForKey:@(n)];
//        return YES;
//    }
//    return NO;
//}

- (void)reloadAllItems{

    VZAssertMainThread();
    
    NSUInteger sections = _itemsForSectionInternal.count;
    
    for (int i=0; i<sections; i++) {
        
        [self reloadItemsForSection:i];
    }
}

- (void)removeAllItems
{
    VZAssertMainThread();
    
    [_itemsForSectionInternal removeAllObjects];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableView's dataSource

//子类重载
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _itemsForSectionInternal.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* items = _itemsForSectionInternal[@(section)];
    return items.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.controller tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //拿到当前的item
    VZListItem *item = [self itemForCellAtIndexPath:indexPath];
    //拿到当前cell的类型
    Class cellClass = [self cellClassForItem:item AtIndex:indexPath];
    //拿到name
    NSString* identifier = NSStringFromClass(cellClass);
    //创建cell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //绑定cell和item
    if ([cell isKindOfClass:[VZListCell class]])
    {
        VZListCell* customCell = (VZListCell*)cell;
        customCell.indexPath = indexPath;
        customCell.delegate  = (id<VZCellActionInterface>)tableView.delegate;
        
        if (item)
        {
            //为cell,item绑定index
            item.indexPath = indexPath;
            NSInteger count = [[self itemsForSection:indexPath.section] count];
            item.isLast = indexPath.row == count - 1 ? YES:NO;
            [(VZListCell *)cell setItem:item];
        }
        else
        {
            //Jayson:
            /**
             *  @dicussion:
             *
             *  These codes are never supposed to be executed.
             *  If it does, it probably means something goes wrong.
             *  For some unpredictable error we display an empty cell with 44 pixel height
             */
            
            VZListItem* item = [VZListItem new];
            item.itemType = kItem_Normal;
            item.itemHeight = 44;
            item.indexPath = indexPath;
            [(VZListCell *)cell setItem:item];
        }
    }
    
    
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (UITableViewCell*)tableView:(UITableView *)tableView initCellAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// item for index
- (VZListItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath
{
    VZAssertMainThread();
    NSArray* items = _itemsForSectionInternal[@(indexPath.section)];
    VZAssertTrue(items);
    
    VZListItem* item = nil;
    
    if (indexPath.row < items.count) {
        
        item = items[indexPath.row];
    }
    else
    {
        item = [VZListItem new];
    }
    return item;
    
}
// cell for index
- (Class)cellClassForItem:(VZListItem*)item AtIndex:(NSIndexPath *)indexPath
{
    VZAssertMainThread();
    
    if (item.itemType == kItem_Normal) {
        return [VZListCell class];
    }
    else if (item.itemType == kItem_Loading) {
        return [VZListDefaultLoadingCell class];
    }
    else if (item.itemType == kItem_Error)
    {
        return [VZListDefaultErrorCell class];
    }
    else if (item.itemType == kItem_Customize)
    {
        return [VZListDefaultTextCell class];
    }
    else
        return [VZListCell class];
}
// bind model
- (void)tableViewControllerDidLoadModel:(VZHTTPListModel*)model
{
    // set data
    NSMutableArray* items = [model.objects mutableCopy];
    [self setItems:items ForSection:model.sectionNumber];
    
}


@end
