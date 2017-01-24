//
//  CthemeButton.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CthemeButton.h"
#import "ThemeManager.h"

@implementation CThemeButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [CNOTIFY addObserver:self
                    selector:@selector(CButtonThemeChange)
                        name:CThemeChangeNotification
                      object:nil];
        
    }
    return self;

}

// 使用xib加载的UI，会走这个方法
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 监听主题改变的通知
    [CNOTIFY addObserver:self
                selector:@selector(CButtonThemeChange)
                    name:CThemeChangeNotification
                  object:nil];
    
}


#pragma mark - 主题改变的通知响应
- (void)CButtonThemeChange {

    switch (CTHEME.themeType) {
        case CDayTheme:
            [self setTitleColor:C_MAIN_TEXTCOLOR forState:UIControlStateNormal];
            break;
            
        case CNightTheme:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        default:
            [self setTitleColor:C_MAIN_TEXTCOLOR forState:UIControlStateNormal];
            break;
    }

}


#pragma mark - 移除通知
- (void)dealloc {

    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];

}
































@end
