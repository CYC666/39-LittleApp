//
//  ThemeManager.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    CDayTheme,      // 白天
    CNightTheme,    // 夜间
} CThemeType;

@interface ThemeManager : NSObject

@property (assign, nonatomic) CThemeType themeType;

+ (instancetype)shareThemeManager;

@end
