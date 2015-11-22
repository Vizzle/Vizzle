//
//  VZCollectionViewDataSource.m
//  VizzleListExample
//
//  Created by moxin on 15/11/15.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZCollectionViewDataSource.h"
#import "VZCollectionItem.h"
#import "VZCollectionCell.h"
#import "VZCellActionInterface.h"

@interface VZCollectionViewDataSource()
{
    NSMutableDictionary* _itemsForSectionInternal;
}

@end

@implementation VZCollectionViewDataSource

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
    
    NSLog(@"[%@]--->dealloc",self.class);
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - protocol VZCollectionViewDataSource

/*
 * 指定cell的类型
 */
- (Class)cellClassForItem:(VZCollectionItem*)item AtIndex:(NSIndexPath *)indexPath
{
    VZAssertMainThread();
    
    //for temperary use
    return [VZCollectionCell class];
    
}
/**
 指定返回的item
 */
- (VZCollectionItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath
{
    VZAssertMainThread();
    NSArray* items = _itemsForSectionInternal[@(indexPath.section)];
    VZAssertTrue(items);
    
    VZCollectionItem* item = nil;
    
    if (indexPath.row < items.count) {
        
        item = items[indexPath.row];
    }
    else
    {
        item = [VZCollectionItem new];
    }
    return item;
}
/**
 绑定items和model
 */
- (void)collectionViewControllerDidLoadModel:(VZHTTPListModel*)model
{
    // set data
    NSMutableArray* items = [model.objects mutableCopy];
    [self setItems:items ForSection:model.sectionNumber];

}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (BOOL)insertSectionAtIndex:(NSInteger)sectionIndex withItems:(NSArray<__kindof VZCollectionItem *> *)items
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
                //[_itemsForSectionInternal removeObjectForKey:@(numberOfSection-1)];
                break;
            }
        }
        return YES;
    }
    
    return NO;
}

- (NSArray<__kindof VZCollectionItem* > *)itemsForSection:(NSInteger)section;
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
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL)setItems:(NSArray<__kindof VZCollectionItem *> *)items ForSection:(NSInteger)n
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
        return YES;
        
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
            return YES;
        }
    }
    return NO;
}


- (BOOL)removeItemsForSection:(NSInteger)n
{
    VZAssertMainThread();
    
    if (n>=0 && n < _itemsForSectionInternal.count) {
        [_itemsForSectionInternal removeObjectForKey:@(n)];
        return YES;
    }
    return NO;
}
- (void)removeAllItems
{
    VZAssertMainThread();
    
    [_itemsForSectionInternal removeAllObjects];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* items = _itemsForSectionInternal[@(section)];
    return items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //拿到当前的item
    VZCollectionItem *item = [self itemForCellAtIndexPath:indexPath];
    
    //拿到当前cell的类型
    Class cellClass = [self cellClassForItem:item AtIndex:indexPath];
    
    //拿到name
    NSString* identifier = NSStringFromClass(cellClass);
    
    //注册cell
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    
    //创建cell
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //绑定cell和item
    if ([cell isKindOfClass:[VZCollectionCell class]])
    {
        VZCollectionCell* customCell = (VZCollectionCell*)cell;
        customCell.indexPath = indexPath;
        customCell.delegate  = (id<VZCellActionInterface>)collectionView.delegate;
        
        if (item)
        {
            //为cell,item绑定index
            item.indexPath = indexPath;
            [(VZCollectionCell *)cell setItem:item];
        }
        else
        {
            //moxin:
            /**
             *  @dicussion:
             *
             *  These codes are never supposed to be executed.
             *  If it does, it probably means something goes wrong.
             *  For some unpredictable error we display an empty cell with 44 pixel height
             */
            
            VZCollectionItem* item = [VZCollectionItem new];
          //  item.itemType = kCollection_Item_Normal;
            item.itemHeight = 44;
            item.indexPath = indexPath;
            [(VZCollectionCell *)cell setItem:item];
        }
    }
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
 
    
    UICollectionReusableView* view = nil;
    
    NSLog(@"kind:%@",kind);
    
    if ([kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
        
        NSMutableDictionary* map = [self.controller valueForKey:@"headerViewKeyForSection"];
        NSString* identifier = map[@(indexPath.section)];
        
        if (identifier) {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        }
        else
            view = [UICollectionReusableView new];
        
        
    }
    else if([kind isEqualToString:@"UICollectionElementKindSectionFooter"])
    {
        NSMutableDictionary* map = [self.controller valueForKey:@"footerViewKeyForSection"];
        NSString* identifier = map[@(indexPath.section)];
        
        if (identifier) {
            
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        }
        else
            view = [UICollectionReusableView new];
        
    }
    else
    {
        //not supposed to happen...
        view = [UICollectionReusableView new];
        
    }
    
    return view;
}




@end

