//
//  ThirdController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/18.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "ThirdController.h"
#import "ThemeManager.h"

@interface ThirdController ()

@end

@implementation ThirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backItemAction:)];
    [backItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.view.backgroundColor = CTHEME.themeColor;
    self.textView.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
}

#pragma mark - 返回按钮响应
- (void)backItemAction:(UIBarButtonItem *)item {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    self.textView.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
    
}

#pragma mark - 移除观察者
- (void)dealloc {
    
    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];
    
}

@end
