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
#import "PasswordController.h"
#import <SMS_SDK/SMSSDK.h>
#import "CYCLoginController.h"
#import <AVFoundation/AVFoundation.h>

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
        
        // 判断本地是否存有进入App的密码，如果有那就进入输入密码页面，没有那就显示主页
        if ([CUSER objectForKey:CPassword]) {
            PasswordController *controller = [[PasswordController alloc] init];
            controller.controllerType = PasswordControllerGoIn;
            self.window.rootViewController = controller;
            
        } else {
            _mainController = [[MMDrawerController alloc] initWithCenterViewController:[[CYCTabBarController alloc] init]
                                                              leftDrawerViewController:[[CYCLeftController alloc] init]];
            _mainController.maximumLeftDrawerWidth = cLeftControllerWidth;
            _mainController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
            _mainController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
            self.window.rootViewController = _mainController;
        }
        
        
    } else {
        self.window.rootViewController = [[CYCLoginController alloc] init];
    }

    [self.window makeKeyAndVisible];
    
    // 允许后台使用扬声器播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // 进入后台之后，就把主窗口设置为输入密码的窗口，那样的话就不会在下次显示的时候先显示tabbar
    if ([CUSER objectForKey:CPassword]) {
        PasswordController *controller = [[PasswordController alloc] init];
        controller.controllerType = PasswordControllerGoIn;
        self.window.rootViewController = controller;
    }
    // 如果没有设置密码，那么久没必要去操作了
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {


    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





@end
