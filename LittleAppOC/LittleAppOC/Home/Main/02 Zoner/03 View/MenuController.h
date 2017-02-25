//
//  MenuController.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/25.
//  Copyright © 2017年 CYC. All rights reserved.
//


// 显示类别菜单的控制器


#import <UIKit/UIKit.h>
@class MenuController;



@protocol MenuControllerDelegate <NSObject>

@optional
// 当选中了其中一个类别之后，就响应代理方法
- (void)didSelectMenuController:(MenuController *)menuController;

@end



@interface MenuController : UIView

@property (copy, nonatomic) NSString *oldTopid;                                 // 当前显示的排行榜的类别
@property (copy, nonatomic) NSString *selectTopid;                              // 选中的排行榜的类别
@property (weak, nonatomic) id<MenuControllerDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame Topid:(NSString *)topid;

@end





































