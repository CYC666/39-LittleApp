//
//  CThemeLabel.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CThemeLabel.h"
#import "ThemeManager.h"

@implementation CThemeLabel


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        // 监听主题改变的通知
        [CNOTIFY addObserver:self
                    selector:@selector(CThemeLabelChange)
                        name:CThemeChangeNotification
                      object:nil];
    }
    return self;

}



#pragma mark - 主题改变
- (void)CThemeLabelChange {

    // 根据主题改变字体颜色
    switch (CTHEME.themeType) {
        case CDayTheme:
            self.textColor = C_MAIN_TEXTCOLOR;
            break;
            
        case CNightTheme:
            self.textColor = [UIColor whiteColor];
            break;
            
        default:
            self.textColor = C_MAIN_TEXTCOLOR;
            break;
    }

}


#pragma mark - 移除通知
- (void)dealloc {

    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];

}





























@end
