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
- (NSInteger)sheetView:(SheetView *)sheetView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)sheetView:(SheetView *)sheetView numberOfColsInSection:(NSInteger)section;
- (NSString *)sheetView:(SheetView *)sheetView cellForContentItemAtIndexRow:(NSIndexPath *)indexRow indexCol:(NSIndexPath *)indexCol;

- (NSString *)sheetView:(SheetView *)sheetView cellForLeftColAtIndexPath:(NSIndexPath*)indexPath;
- (NSString *)sheetView:(SheetView *)sheetView cellForTopRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@protocol SheetViewDelegate <NSObject>
@required
- (CGFloat)sheetView:(SheetView *)sheetView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)sheetView:(SheetView *)sheetView widthForColAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SheetView : UIView

@property (nonatomic, strong) id<SheetViewDataSource> dataSource;
@property (nonatomic, strong) id<SheetViewDelegate> delegate;
@property (nonatomic, strong) NSString *sheetHead;


- (void)reloadData;

@end
