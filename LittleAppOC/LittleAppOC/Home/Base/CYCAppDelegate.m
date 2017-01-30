//
//  CYCAppDelegate.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CYCAppDelegate.h"
#import "CYCTabBarController.h"
#import "CYCLeftController.h"
#import "MMDrawerController.h"
#import "ThemeManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "CYCLoginController.h"

// 短信验证进行登录
#define APP_Key @"1b0ab23fa4a73"
#define APP_Secret @"337b6e21b290739753afa991162f8723"


@implementation CYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化应用的短信验证
    [SMSSDK registerApp:APP_Key
             withSecret:APP_Secret];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 判断是否已经存在登录之后的手机号，如果不存在，那么显示短信登录界面
    if ([CUSER objectForKey:CUserPhone]) {
        MMDrawerController *controller = [[MMDrawerController alloc] initWithCenterViewController:[[CYCTabBarController alloc] init]
                                                                         leftDrawerViewController:[[CYCLeftController alloc] init]];
        controller.maximumLeftDrawerWidth = cLeftControllerWidth;
        controller.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        controller.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        self.window.rootViewController = controller;
    } else {
        self.window.rootViewController = [[CYCLoginController alloc] init];
    }

    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





@end
