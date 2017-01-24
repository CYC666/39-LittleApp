//
//  GamerCell.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "GamerCell.h"
#import "ThemeManager.h"
#import "CThemeLabel.h"

@implementation GamerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _gameImageView.layer.cornerRadius = 10;
    _gameImageView.layer.borderWidth = 2;
    _gameImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _gameImageView.clipsToBounds = YES;
    
    [CNOTIFY addObserver:self
                selector:@selector(themeChangeNotification:)
                    name:CThemeChangeNotification
                  object:nil];
    
}

- (void)themeChangeNotification:(NSNotification *)notification {

    // 更改描边颜色
    _gameImageView.layer.borderColor = CTHEME.themeType == CDayTheme ? [UIColor blackColor].CGColor : [UIColor whiteColor].CGColor;

}


@end
