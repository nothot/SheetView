//
//  ViewController.m
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/19.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SheetView *sheetView = [[SheetView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    sheetView.dataSource = self;
    sheetView.delegate = self;
    sheetView.sheetHead = @"sheet";
    [self.view addSubview:sheetView];
    
}



- (NSInteger)sheetView:(SheetView *)sheetView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}
- (NSInteger)sheetView:(SheetView *)sheetView numberOfColsInSection:(NSInteger)section
{
    return 50;
}
- (NSString *)sheetView:(SheetView *)sheetView cellForContentItemAtIndexRow:(NSIndexPath *)indexRow indexCol:(NSIndexPath *)indexCol
{
    return @"data";
}
- (NSString *)sheetView:(SheetView *)sheetView cellForLeftColAtIndexPath:(NSIndexPath*)indexPath
{
    return @"row";
}
- (NSString *)sheetView:(SheetView *)sheetView cellForTopRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @"col";
}

- (CGFloat)sheetView:(SheetView *)sheetView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)sheetView:(SheetView *)sheetView widthForColAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)sheetView:(SheetView *)sheetView cellWithColorAtIndexRow:(NSIndexPath *)indexRow
{
    return (indexRow.row%2 != 0)?YES:NO;
}

@end
