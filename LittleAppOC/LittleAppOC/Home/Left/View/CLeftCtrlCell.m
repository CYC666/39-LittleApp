//
//  CLeftCtrlCell.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CLeftCtrlCell.h"
#import "CThemeLabel.h"
#import "ThemeManager.h"

@implementation CLeftCtrlCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatSubviews];
    }
    return self;

}


#pragma mark - 创建子视图
- (void)creatSubviews {

    _leftCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
    _leftCellImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_leftCellImageView];
    
    _leftCellLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(54, 15, 100, 24)];
    _leftCellLabel.font = C_MAIN_FONT(17);
    [self.contentView addSubview:_leftCellLabel];
    
    _leftCellLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
    

}



































@end
