//
//  BoomController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/3/12.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 点击炸弹，炸弹的位置会改变

#import "BoomController.h"
#import "ThemeManager.h"

@interface BoomController () <UIScrollViewDelegate> {

    UIScrollView *_mainScrollView;
    UIButton *_boomButton;
    UIView *_tipView;
    


}



@end

@implementation BoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    title.text = @"寻找炸弹";
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight + 64)];
    _mainScrollView.contentSize = CGSizeMake(5000, 5000);
    _mainScrollView.delegate = self;
    _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:_mainScrollView];
    
    _boomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _boomButton.frame = CGRectMake(0, 0, 100, 100);
    _boomButton.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    [_boomButton setImage:[UIImage imageNamed:@"image_boom"] forState:UIControlStateNormal];
    [_boomButton addTarget:self action:@selector(boomAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_boomButton];
    
    _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _tipView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    _tipView.userInteractionEnabled = NO;
    _tipView.layer.cornerRadius = 5;
    _tipView.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view addSubview:_tipView];
    
    self.view.backgroundColor = CTHEME.themeColor;
    
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
    
}




- (void)boomAction:(UIButton *)sender {
    
    [UIView animateWithDuration:.1
                     animations:^{
                         _boomButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.2
                                          animations:^{
                                              _boomButton.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:.35
                                                               animations:^{
                                                                   // 限制不能越过边界
                                                                   CGFloat x = arc4random() % 5000;
                                                                   if (x < 50) {
                                                                       x = 50;
                                                                   } else if (x > 4950) {
                                                                       x = 4950;
                                                                   }
                                                                   CGFloat y = arc4random() % 5000;
                                                                   if (y < 50) {
                                                                       y = 50;
                                                                   } else if (x > 4950) {
                                                                       y = 4950;
                                                                   }
                                                                   _boomButton.center = CGPointMake(x, y);
                                                                   
                                                                   // 修改提示标志的位置
                                                                   CGPoint center = [_mainScrollView convertPoint:_boomButton.center toView:self.view];
                                                                   
                                                                   if (center.x < 0) {
                                                                       center.x = 0;
                                                                   } else if (center.x > kScreenWidth) {
                                                                       center.x = kScreenWidth;
                                                                   }
                                                                   if (center.y < 64) {
                                                                       center.y = 64;
                                                                   } else if (center.y > kScreenHeight) {
                                                                       center.y = kScreenHeight;
                                                                   }
                                                                   
                                                                   _tipView.center = center;
                                                                   
                                                                   
                                                               }];
                                          }];
                     }];
    
    
    
}


#pragma mark - 滑动视图的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint center = [_mainScrollView convertPoint:_boomButton.center toView:self.view];
    
    if (center.x < 0) {
        center.x = 0;
    } else if (center.x > kScreenWidth) {
        center.x = kScreenWidth;
    }
    if (center.y < 64) {
        center.y = 64;
    } else if (center.y > kScreenHeight) {
        center.y = kScreenHeight;
    }
    
    _tipView.center = center;
    
    NSLog(@"%@", NSStringFromCGPoint(center));
    
}


#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    
}






























@end
