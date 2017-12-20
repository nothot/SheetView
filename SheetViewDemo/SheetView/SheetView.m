//
//  SheetView.m
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/19.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import "SheetView.h"
#import "ContentViewCell.h"


static NSString *leftViewCellId = @"left.tableview.cell";
static NSString *topViewCellId = @"top.collectionview.cell";
static NSString *contentViewCellId = @"content.tableview.cell";

@interface SheetLeftView : UITableView
@end
@implementation SheetLeftView
@end

@interface SheetTopView : UICollectionView
@end
@implementation SheetTopView
@end

@interface SheetContentView : UITableView
@end
@implementation SheetContentView
@end

@interface SheetView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SheetLeftView *leftView;
@property (nonatomic, strong) SheetTopView *topView;
@property (nonatomic, strong) SheetContentView *contentView;
@property (nonatomic, strong) UILabel *sheetHeadLabel;

@end
@implementation SheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [[UIColor colorWithRed:0xe5 / 255.0 green:0xe5 / 255.0 blue:0xe5 / 255.0 alpha:1.0] CGColor];
        self.layer.cornerRadius = 1.0f;
        self.layer.borderWidth = 1.0f;
        
        self.leftView = [[SheetLeftView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.leftView.dataSource = self;
        self.leftView.delegate = self;
        self.leftView.showsVerticalScrollIndicator = NO;
        self.leftView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
        self.leftView.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        self.leftView.layer.borderWidth = 1.0f;
        self.leftView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.topView = [[SheetTopView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.topView.dataSource = self;
        self.topView.delegate = self;
        self.topView.showsHorizontalScrollIndicator = NO;
        [self.topView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:topViewCellId];
        self.topView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
        self.topView.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        self.topView.layer.borderWidth = 1.0f;
        
        self.contentView = [[SheetContentView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.contentView.dataSource = self;
        self.contentView.delegate = self;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
        
        [self addSubview:self.leftView];
        [self addSubview:self.topView];
        [self addSubview:self.contentView];
        
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[SheetLeftView class]]) {
        self.contentView.contentOffset = self.leftView.contentOffset;
    }
    if ([scrollView isKindOfClass:[SheetContentView class]]) {
        self.leftView.contentOffset = self.contentView.contentOffset;
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        for (ContentViewCell *cell in self.contentView.visibleCells) {
            cell.cellCollectionView.contentOffset = scrollView.contentOffset;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat sheetViewWidth = self.frame.size.width;
    CGFloat sheetViewHeight = self.frame.size.height;
    self.leftView.frame = CGRectMake(0, self.titleRowHeight, self.titleColWidth, sheetViewHeight - self.titleRowHeight);
    self.topView.frame = CGRectMake(self.titleColWidth, 0, sheetViewWidth - self.titleColWidth, self.titleRowHeight);
    self.contentView.frame = CGRectMake(self.titleColWidth, self.titleRowHeight, sheetViewWidth - self.titleColWidth, sheetViewHeight - self.titleRowHeight);
    
    if (self.sheetHeadLabel) {
        [self.sheetHeadLabel removeFromSuperview];
    }
    self.sheetHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.titleColWidth, self.titleRowHeight)];
    self.sheetHeadLabel.text = self.sheetHead;
    self.sheetHeadLabel.textColor = [UIColor blackColor];
    self.sheetHeadLabel.textAlignment = NSTextAlignmentCenter;
    self.sheetHeadLabel.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
    self.sheetHeadLabel.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
    self.sheetHeadLabel.layer.borderWidth = 1.0;
    [self addSubview:self.sheetHeadLabel];
}

- (void)reloadData
{
    self.sheetHeadLabel.frame = CGRectMake(0, 0, self.titleColWidth, self.titleRowHeight);
    [self.leftView reloadData];
    [self.topView reloadData];
    [self.contentView reloadData];
}

# pragma mark -- UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate sheetView:self heightForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource sheetView:self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isKindOfClass:[SheetLeftView class]]) {
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:leftViewCellId];
        if (leftCell == nil)
        {
            leftCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftViewCellId];
            leftCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *view in leftCell.contentView.subviews) {
            [view removeFromSuperview];
        }
        leftCell.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
        leftCell.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        leftCell.layer.borderWidth = 1;
        
        CGFloat width = self.titleColWidth;
        CGFloat height = [self.delegate sheetView:self heightForRowAtIndexPath:indexPath];
        
        CGRect rect = CGRectMake(0, 0, width, height);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.text = [self.dataSource sheetView:self cellForLeftColAtIndexPath:indexPath];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [leftCell.contentView addSubview:label];
        
        return leftCell;
    }

    ContentViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:contentViewCellId];
    if (contentCell == nil)
    {
        contentCell = [[ContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentViewCellId];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    contentCell.cellForItemBlock = ^NSString *(NSIndexPath *indexPathInner) {
        return [self.dataSource sheetView:self cellForContentItemAtIndexRow:indexPath indexCol:indexPathInner];
    };
    contentCell.numberOfItemsBlock = ^NSInteger(NSInteger section) {
        return [self.dataSource sheetView:self numberOfColsInSection:section];
    };
    contentCell.sizeForItemBlock = ^CGSize(UICollectionViewLayout * collectionViewLayout, NSIndexPath *indexPathInner) {
        CGFloat width = [self.delegate sheetView:self widthForColAtIndexPath:indexPathInner];
        CGFloat height = [self.delegate sheetView:self heightForRowAtIndexPath:indexPath];
        return CGSizeMake(width, height);
    };
    contentCell.contentViewCellDidScrollBlock = ^(UIScrollView *scroll) {
        for (ContentViewCell *cell in self.contentView.visibleCells) {
            cell.cellCollectionView.contentOffset = scroll.contentOffset;
        }
        self.topView.contentOffset = scroll.contentOffset;
    };
    if ([self.dataSource respondsToSelector:@selector(sheetView:cellWithColorAtIndexRow:)]) {
        contentCell.cellWithColorBlock = ^BOOL(NSIndexPath *indexPathInner) {
            return [self.dataSource sheetView:self cellWithColorAtIndexRow:indexPath];
        };
    }
    contentCell.cellDidSelectBlock = ^(NSIndexPath *indexPathInner) {
        if ([self.delegate respondsToSelector:@selector(sheetView:didSelectItemAtIndexRow:indexCol:)]) {
            [self.delegate sheetView:self didSelectItemAtIndexRow:indexPath indexCol:indexPathInner];
        }
    };
    
    contentCell.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
    contentCell.cellCollectionView.frame = CGRectMake(0, 0, self.frame.size.width - self.titleColWidth, [self.delegate sheetView:self heightForRowAtIndexPath:indexPath]);
    [contentCell.cellCollectionView reloadData];
    
    return contentCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isKindOfClass:[SheetLeftView class]]) {
        return;
    }
    ContentViewCell *willDisplayCell = (ContentViewCell *)cell;
    ContentViewCell *didDisplayCell = (ContentViewCell *)[tableView.visibleCells firstObject];
    if (willDisplayCell.cellCollectionView && didDisplayCell.cellCollectionView && willDisplayCell.cellCollectionView.contentOffset.x != didDisplayCell.cellCollectionView.contentOffset.x) {
        willDisplayCell.cellCollectionView.contentOffset = didDisplayCell.cellCollectionView.contentOffset;
    }
}

# pragma mark -- UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource sheetView:self numberOfColsInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)uiCollectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [self.delegate sheetView:self widthForColAtIndexPath:indexPath];
    CGFloat height = self.titleRowHeight;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:topViewCellId forIndexPath:indexPath];
    if (topCell) {
        for (UIView *view in topCell.contentView.subviews) {
            [view removeFromSuperview];
        }
        topCell.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
        topCell.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        topCell.layer.borderWidth = 1;
        CGFloat width = [self.delegate sheetView:self widthForColAtIndexPath:indexPath];
        CGFloat height = self.titleRowHeight;
        CGRect rect = CGRectMake(0, 0, width, height);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.text = [self.dataSource sheetView:self cellForTopRowAtIndexPath:indexPath];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [topCell.contentView addSubview:label];
    }
    
    return topCell;
}

@end
