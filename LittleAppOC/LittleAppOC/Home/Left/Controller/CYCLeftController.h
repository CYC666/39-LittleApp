//
//  CYCLeftController.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 侧滑控制器的左控制器

#import <UIKit/UIKit.h>
@class CThemeButton;

@interface CYCLeftController : UIViewController

@property (strong, nonatomic) UIImageView *headImageView;   // 头部背景图片
@property (strong, nonatomic) UITableView *middleTableView; // 中部表视图
@property (strong, nonatomic) CThemeButton *nightButton;    // 夜间模式按钮


@end
