//
//  brokenLineController.m
//  LittleAppOC
//
//  Created by CYC on 2017/3/29.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "brokenLineController.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"

@interface brokenLineController ()

@end

@implementation brokenLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    title.text = @"折线图";
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scroll.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
    
    //--------------------------------------------------------设置坐标系-----------------------------------------------------------------
    
    SHLineGraphView *_lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 2, kScreenHeight - 64)];
    
    
    NSDictionary *_themeAttributes = @{
                                       // X轴标题颜色、字体
                                       kXAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       // Y轴标题颜色、字体
                                       kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       // Y轴标题的左右空隙之和
                                       kYAxisLabelSideMarginsKey : @20,
                                       // 背景的横线颜色
                                       kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       // 折点的大小
                                       kDotSizeKey : @10,
                                       };
    _lineGraph.themeAttributes = _themeAttributes;
    
    // 竖线底部圆点的颜色
    _lineGraph.bottomCycleColor = [UIColor orangeColor];
    
    // Y轴最大值
    _lineGraph.yAxisRange = @(80);
    _lineGraph.yAxisMinValue = @(20);
    
    // Y轴等级数量
    _lineGraph.yAxisCount = 4;
    
    // Y轴的单位
    _lineGraph.yAxisSuffix = @"";
    
    
    // X轴标题
    _lineGraph.xAxisValues = @[
                               @{ @1 : @"1月" },
                               @{ @2 : @"2月" },
                               @{ @3 : @"3月" },
                               @{ @4 : @"4月" },
                               @{ @5 : @"5月" },
                               @{ @6 : @"6月" },
                               @{ @7 : @"7月" },
                               @{ @8 : @"8月" },
                               @{ @9 : @"9月" },
                               @{ @10 : @"10月" },
                               @{ @11 : @"11月" },
                               @{ @12 : @"12月" }
                               ];
    
    
    
    
    //--------------------------------------------------------设置折线-----------------------------------------------------------------
    
    
    SHPlot *_plot1 = [[SHPlot alloc] init];
    
    // (X,Y)
    _plot1.plottingValues = @[
                              @{ @1 : @65.8 },
                              @{ @2 : @20 },
                              @{ @3 : @23 },
                              @{ @4 : @22 },
                              @{ @5 : @12.3 },
                              @{ @6 : @45.8 },
                              @{ @7 : @56 },
                              @{ @8 : @77 },
                              @{ @9 : @65 },
                              @{ @10 : @10 },
                              @{ @11 : @67 },
                              @{ @12 : @23 }
                              ];
    
    // 折点对应的标题（点击折点会弹出标题）
    NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12"];
    _plot1.plottingPointsLabels = arr;
    
    //
    NSDictionary *_plotThemeAttributes = @{
                                           // 下部分的填充颜色
                                           kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0],
                                           // 折线的描边宽度
                                           kPlotStrokeWidthKey : @2,
                                           // 折线的颜色
                                           kPlotStrokeColorKey : [UIColor colorWithRed:0 green:1 blue:0 alpha:1],
                                           // 折点的颜色
                                           kPlotPointFillColorKey : [UIColor colorWithRed:0 green:1 blue:0 alpha:1],
                                           // 折点标题的字体
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    _plot1.plotThemeAttributes = _plotThemeAttributes;
    [_lineGraph addPlot:_plot1];
    
    
    
    
    SHPlot *_plot2 = [[SHPlot alloc] init];
    
    // (X,Y)
    _plot2.plottingValues = @[
                              @{ @1 : @40.5 },
                              @{ @2 : @37 },
                              @{ @3 : @70 },
                              @{ @4 : @50 },
                              @{ @5 : @30 },
                              @{ @6 : @39 },
                              @{ @7 : @44 },
                              @{ @8 : @62 },
                              @{ @9 : @25 },
                              @{ @10 : @45 },
                              @{ @11 : @10 },
                              @{ @12 : @53 }
                              ];
    
    // 折点对应的标题（点击折点会弹出标题）
    NSArray *arr2 = @[@"Y1", @"Y2", @"Y3", @"Y4", @"Y5", @"Y6" , @"Y7" , @"Y8", @"Y9", @"Y10", @"Y11", @"Y12"];
    _plot2.plottingPointsLabels = arr2;
    
    //
    NSDictionary *_plotThemeAttributes2 = @{
                                            // 下部分的填充颜色
                                            kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0],
                                            // 折线的描边宽度
                                            kPlotStrokeWidthKey : @2,
                                            // 折线的颜色
                                            kPlotStrokeColorKey : [UIColor colorWithRed:0.41 green:0.12 blue:0.18 alpha:1],
                                            // 折点的颜色
                                            kPlotPointFillColorKey : [UIColor colorWithRed:0.41 green:0.12 blue:0.18 alpha:1],
                                            // 折点标题的字体
                                            kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                            };
    
    _plot2.plotThemeAttributes = _plotThemeAttributes2;
    [_lineGraph addPlot:_plot2];
    
    
    // 如果需要多条折线，就跟上面的方式继续添加
    
    //--------------------------------------------------------添加折线-----------------------------------------------------------------
    [_lineGraph setupTheView];
    
    [scroll addSubview:_lineGraph];
    
    

    
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationController.hidesBarsOnTap = YES;

}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.navigationController.hidesBarsOnTap = NO;

}






@end
