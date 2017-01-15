//
//  GamerController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "GamerController.h"
#import "MMDrawerController.h"

@interface GamerController ()

@end

@implementation GamerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置游戏控制器这个界面不允许侧滑
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    MMDrawerController *drawCtrl= (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [drawCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];

}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    MMDrawerController *drawCtrl= (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [drawCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];

}



































@end
