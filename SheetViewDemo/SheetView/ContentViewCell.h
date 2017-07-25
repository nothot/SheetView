//
//  ContentViewCell.h
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/20.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^cellForItemAtIndexPathBlock)(NSIndexPath *indexPath);
typedef NSInteger(^numberOfItemsInSectionBlock)(NSInteger section);
typedef CGSize(^sizeForItemAtIndexPathBlock)(UICollectionViewLayout * collectionViewLayout, NSIndexPath *indexPath);
typedef void(^ContentViewCellDidScrollBlock)(UIScrollView *scroll);
typedef BOOL(^cellWithColorAtIndexPathBlock)(NSIndexPath *indexPath);

@interface ContentViewCell : UITableViewCell
@property (nonatomic, strong) cellForItemAtIndexPathBlock cellForItemBlock;
@property (nonatomic, strong) numberOfItemsInSectionBlock numberOfItemsBlock;
@property (nonatomic, strong) sizeForItemAtIndexPathBlock sizeForItemBlock;
@property (nonatomic, strong) ContentViewCellDidScrollBlock contentViewCellDidScrollBlock;
@property (nonatomic, strong) cellWithColorAtIndexPathBlock cellWithColorBlock;

@property (nonatomic, strong) UICollectionView *cellCollectionView;
@end
