//
//  CYCTabBarController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CYCTabBarController.h"
#import "GamerController.h"
#import "ZonerController.h"
#import "HomerController.h"
#import "DiscoverController.h"
#import "SettingerController.h"

@interface CYCTabBarController ()

@property (strong, nonatomic) NSMutableArray *subArray;

@end

@implementation CYCTabBarController


- (instancetype)init {

    if (self = [super init]) {
        [self creatSubController];
        [self setTabBarController];
    }
    return self;

}



#pragma mark - 初始化子标签控制器
- (void)creatSubController {
    
    NSArray *tabNameArray = @[@"游戏",
                              @"动态",
                              @"首页",
                              @"探索",
                              @"设置"];
    NSArray *tabImageArray = @[@"icon_tab_gamer",
                               @"icon_tab_zoner",
                               @"icon_tab_homer",
                               @"icon_tab_discover",
                               @"icon_tab_settinger"];
    NSArray *tabControllerArray = @[@"GamerController",
                                    @"ZonerController",
                                    @"HomerController",
                                    @"DiscoverController",
                                    @"SettingerController"];
    _subArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < tabControllerArray.count; i++) {
        UIViewController *controller = [[NSClassFromString(tabControllerArray[i]) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.navigationBar.translucent = YES;
        nav.navigationBar.barTintColor = C_MAIN_COLOR;
        nav.tabBarItem.title = tabNameArray[i];
        nav.tabBarItem.image = [UIImage imageNamed:tabImageArray[i]];
        [_subArray addObject:nav];
    }
    self.viewControllers = _subArray;
    
    
    
}

#pragma mark - 标签控制器总设置
- (void)setTabBarController {

    self.selectedIndex = 2;
    UITabBar *tabBar = self.tabBar;
    tabBar.translucent = NO;

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}




































@end
