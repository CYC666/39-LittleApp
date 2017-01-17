//
//  ThemeManager.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "ThemeManager.h"
#import <UIKit/UIKit.h>

static ThemeManager *manager = nil;

@implementation ThemeManager

+ (instancetype)shareThemeManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;

}

- (instancetype)init {

    if (self = [super init]) {
        CThemeType theme = [CUSER integerForKey:CThemeTypeSave];
        _themeType = theme ? : CDayTheme;
    }
    return self;

}

- (id)copy {
    return self;
}

// -----------------------------------------------------我是分割线-----------------------------------------------------
#pragma mark - 接收主题设置，同时发送主题改变的通知
- (void)setThemeType:(CThemeType)themeType {

    _themeType = themeType;
    
    [CNOTIFY postNotificationName:CThemeChangeNotification object:nil];
    
    // 保存当前主题
    [CUSER setInteger:themeType forKey:CThemeTypeSave];

}


#pragma mark - 根据主题不同，获取不一样的颜色
- (UIColor *)colorFromThemeType:(CThemeType)type {

    UIColor *themeColor;
    switch (type) {
        case CDayTheme:
            themeColor = [UIColor whiteColor];
            break;
    
        case CNightTheme:
            themeColor = CRGB(4, 29, 63, 1);
            break;
            
        default:
            themeColor = [UIColor clearColor];
            break;
    }
    
    return themeColor;

}




































@end
