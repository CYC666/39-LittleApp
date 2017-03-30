//
//  FlowSliderController.m
//  LittleAppOC
//
//  Created by CYC on 2017/3/31.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "FlowSliderController.h"
#import "VSliderView.h"

@interface FlowSliderController () <VSliderViewDelegate> {

    UILabel *_tipLabel;     // 预览

}

@end

@implementation FlowSliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    VSliderView *sliderView = [[VSliderView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth)
                                                        minValue:0
                                                        maxValue:300
                                                    currentValue:120
                                                 backgroundColor:[UIColor whiteColor]
                                                       tintColor:[UIColor grayColor]
                                                        tipImage:@"icon_gamer_slider"
                                                    trackToRight:30];
    sliderView.delegate = self;
    [self.view addSubview:sliderView];
    
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenWidth + 100, kScreenWidth, 30)];
    _tipLabel.textColor = [UIColor grayColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tipLabel];
    
    
    
    
}

#pragma mark - 滑动条滑动停止时代理方法
- (void)endDragTipView:(VSliderView *)sliderView {
    
    _tipLabel.text = [NSString stringWithFormat:@"%.2f", sliderView.currentValue];
    
    [UIView animateWithDuration:.35
                     animations:^{
                         // 显示
                         _tipLabel.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                          animations:^{
                                              _tipLabel.alpha = 0.9;
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:.35
                                                               animations:^{
                                                                   _tipLabel.alpha = 0;
                                                               }];
                                          } ];
                     }];

}




@end
