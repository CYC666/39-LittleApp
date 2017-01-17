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

@interface CYCTabBarController () {
    UIImageView *_selectImageView;
}

@property (strong, nonatomic) NSMutableArray *subArray;

@end

@implementation CYCTabBarController


- (instancetype)init {

    if (self = [super init]) {
        [self creatSubController];
        [self deleteSubTbaBarButton];
        [self setTabBar];
    }
    return self;

}



#pragma mark - 初始化子标签控制器
- (void)creatSubController {
    
    
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
        [_subArray addObject:nav];
    }
    self.viewControllers = _subArray;
    
    
    
}

#pragma mark - 删除标签按钮
- (void)deleteSubTbaBarButton {

    //获取要删除的类
    Class removeClass = NSClassFromString(@"UITabBarButton");
    
    //删除类名一致的视图
    for (UIView *view in self.tabBar.subviews) {
        
        if ([view isKindOfClass:removeClass]) {
            //从俯视图中删除
            [view removeFromSuperview];
        }
        
    }

}

#pragma mark - 标签控制器设置
- (void)setTabBar {

    self.selectedIndex = 2;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UITabBar *tabBar = self.tabBar;
    tabBar.translucent = NO;
    tabBar.clipsToBounds = YES;     // 去掉顶部的横线
    
    // 背景图片
    UIImageView *barImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tab_Bar"]];
    barImageView.frame = tabBar.bounds;
    barImageView.contentMode = UIViewContentModeScaleToFill;
    [tabBar insertSubview:barImageView atIndex:0];
    
    
    
    
    // 创建按钮
    NSArray *titleArray = @[@"游戏",
                            @"动态",
                            @"主页",
                            @"探索",
                            @"设置"];
    float buttonWidth = kScreenWidth / titleArray.count;
    
    // 选中时显示的背景图片
    _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 49)];
    _selectImageView.image = [UIImage imageNamed:@"home_bottom_tab_arrow"];
    [self.tabBar addSubview:_selectImageView];
    
    for (int i = 0; i < titleArray.count; i++) {
        //按钮图片
        NSString *string = [NSString stringWithFormat:@"home_tab_icon_%d@2x.png", i+1];
        //创建按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, 49);
        //只需要指定图片名字，button内部帮忙设置图片
        [button setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        button.tag = i;
        [self.tabBar addSubview:button];
        [button addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

#pragma mark - 更改选项
- (void)tabbarAction:(UIButton *)button {

    self.selectedIndex = button.tag;
    [UIView animateWithDuration:.35
                     animations:^{
                         //更改选中图片的位置
                         _selectImageView.center = button.center;
                     }];
}


































@end
