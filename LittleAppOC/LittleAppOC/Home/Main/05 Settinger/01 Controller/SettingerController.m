//
//  SettingerController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "SettingerController.h"
#import "MMDrawerController.h"

@interface SettingerController ()

@end

@implementation SettingerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}


#pragma mark - 设置这个界面不允许侧滑
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
