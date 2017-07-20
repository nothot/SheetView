//
//  SheetView.m
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/19.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import "SheetView.h"
//#import "SheetLeftView.h"
//#import "SheetTopView.h"
//#import "SheetContentView.h"
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
        self.contentView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];;
        
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
    CGFloat rowHeight = [self.delegate sheetView:self heightForRowAtIndexPath:nil];
    CGFloat colWidth = [self.delegate sheetView:self widthForColAtIndexPath:nil];
    self.leftView.frame = CGRectMake(0, rowHeight, colWidth, sheetViewHeight - rowHeight);
    self.topView.frame = CGRectMake(colWidth, 0, sheetViewWidth - colWidth, rowHeight);
    self.contentView.frame = CGRectMake(colWidth, rowHeight, sheetViewWidth - colWidth, sheetViewHeight - rowHeight);
    
    UILabel *sheetHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, colWidth, rowHeight)];
    sheetHeadLabel.text = self.sheetHead;
    sheetHeadLabel.textColor = [UIColor blackColor];
    sheetHeadLabel.textAlignment = NSTextAlignmentCenter;
    sheetHeadLabel.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
    [self addSubview:sheetHeadLabel];
}

- (void)reloadData
{
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
        leftCell.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
        leftCell.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        leftCell.layer.borderWidth = 1;
        CGFloat width = [self.delegate sheetView:self widthForColAtIndexPath:indexPath];
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
    contentCell.sizeForItemBlock = ^CGSize(UICollectionViewLayout * collectionViewLayout, NSIndexPath *indexPath) {
        CGFloat width = [self.delegate sheetView:self widthForColAtIndexPath:indexPath];
        CGFloat height = [self.delegate sheetView:self heightForRowAtIndexPath:indexPath];
        return CGSizeMake(width, height);
    };
    contentCell.contentViewCellDidScrollBlock = ^(UIScrollView *scroll) {
        for (ContentViewCell *cell in self.contentView.visibleCells) {
            cell.cellCollectionView.contentOffset = scroll.contentOffset;
        }
        self.topView.contentOffset = scroll.contentOffset;
    };
    contentCell.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
    contentCell.cellCollectionView.frame = CGRectMake(0, 0, self.frame.size.width - 80, 60);
    [contentCell.cellCollectionView reloadData];
    
    return contentCell;
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
    CGFloat height = [self.delegate sheetView:self heightForRowAtIndexPath:indexPath];
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:topViewCellId forIndexPath:indexPath];
    if (topCell) {
        topCell.backgroundColor = [UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1];
        CGFloat width = [self.delegate sheetView:self widthForColAtIndexPath:indexPath];
        CGFloat height = [self.delegate sheetView:self heightForRowAtIndexPath:indexPath];
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
