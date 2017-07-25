//
//  ContentViewCell.m
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/20.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import "ContentViewCell.h"

@interface ContentViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation ContentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.cellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        self.cellCollectionView.showsHorizontalScrollIndicator = NO;
        self.cellCollectionView.backgroundColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1];
        self.cellCollectionView.layer.borderColor = [UIColor colorWithRed:(0x90 / 255.0)green:(0x90 / 255.0)blue:(0x90 / 255.0)alpha:1].CGColor;
        self.cellCollectionView.layer.borderWidth = 1.0f;
        [self.cellCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"inner.cell"];
        self.cellCollectionView.dataSource = self;
        self.cellCollectionView.delegate = self;
        
        [self.contentView addSubview:self.cellCollectionView];
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.contentViewCellDidScrollBlock) {
        self.contentViewCellDidScrollBlock(scrollView);
    }
}


#pragma mark -- UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfItemsBlock(section);
}

- (CGSize)collectionView:(UICollectionView *)uiCollectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.sizeForItemBlock(collectionViewLayout, indexPath);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *innerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inner.cell" forIndexPath:indexPath];
    if (innerCell) {
        for (UIView *view in innerCell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    BOOL hasColor = NO;
    if (self.cellWithColorBlock) hasColor = self.cellWithColorBlock(indexPath);
    innerCell.backgroundColor = hasColor?[UIColor colorWithRed:(0xf0 / 255.0)green:(0xf0 / 255.0)blue:(0xf0 / 255.0)alpha:1]:[UIColor whiteColor];
    CGFloat width = self.sizeForItemBlock(nil, indexPath).width;
    CGFloat height = self.sizeForItemBlock(nil, indexPath).height;
    CGRect rect = CGRectMake(0, 0, width, height);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = self.cellForItemBlock(indexPath);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [innerCell.contentView addSubview:label];
    
    return innerCell;
}



@end
