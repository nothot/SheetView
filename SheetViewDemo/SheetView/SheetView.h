//
//  SheetView.h
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/19.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SheetView;
@protocol SheetViewDataSource <NSObject>
@required
//返回表格有多少行
- (NSInteger)sheetView:(SheetView *)sheetView numberOfRowsInSection:(NSInteger)section;
//返回表格有多少列
- (NSInteger)sheetView:(SheetView *)sheetView numberOfColsInSection:(NSInteger)section;
//返回表格某行某列位置上需要显示的内容
- (NSString *)sheetView:(SheetView *)sheetView cellForContentItemAtIndexRow:(NSIndexPath *)indexRow indexCol:(NSIndexPath *)indexCol;
//返回表格左侧标题列每行需要显示的内容
- (NSString *)sheetView:(SheetView *)sheetView cellForLeftColAtIndexPath:(NSIndexPath*)indexPath;
//返回表格上边标题行每列需要显示的内容
- (NSString *)sheetView:(SheetView *)sheetView cellForTopRowAtIndexPath:(NSIndexPath*)indexPath;

@optional
//返回表格某行是否需要填充颜色
- (BOOL)sheetView:(SheetView *)sheetView cellWithColorAtIndexRow:(NSIndexPath *)indexRow;
@end

@protocol SheetViewDelegate <NSObject>
@required
//返回表格每行的高度
- (CGFloat)sheetView:(SheetView *)sheetView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//返回表格每列的宽度
- (CGFloat)sheetView:(SheetView *)sheetView widthForColAtIndexPath:(NSIndexPath *)indexPath;

- (void)sheetView:(SheetView *)sheetView didSelectItemAtIndexRow:(NSIndexPath *)indexRow indexCol:(NSIndexPath *)indexCol;
@end

@interface SheetView : UIView

@property (nonatomic, strong) id<SheetViewDataSource> dataSource;
@property (nonatomic, strong) id<SheetViewDelegate> delegate;
@property (nonatomic, strong) NSString *sheetHead;//第一行第一列格子要显示的内容

@property (nonatomic, assign) CGFloat titleColWidth;//左侧标题列宽度（必须设置）
@property (nonatomic, assign) CGFloat titleRowHeight;//上边标题行高度（必须设置）

//表格刷新
- (void)reloadData;

@end
