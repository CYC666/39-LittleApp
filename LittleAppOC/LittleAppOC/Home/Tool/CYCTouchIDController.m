//
//  CYCTouchIDController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/3/5.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 这个控制器主要是用在刚打开App时，验证touchID
// 当成功验证，就改变主窗口
// 验证失败，可以输入手机号码进入


#import "CYCTouchIDController.h"
#import "CYCTouchID.h"
#import "MMDrawerController.h"
#import "CYCTabBarController.h"
#import "CYCLeftController.h"
#import "CYCAppDelegate.h"


@interface CYCTouchIDController () <CYCTouchIDDelegate>

@end

@implementation CYCTouchIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 验证指纹
    [[CYCTouchID touchID] startCYCTouchIDWithMessage:CYCNotice(@"请验证指纹", @"Please use touchID")
                                       fallbackTitle:CYCNotice(@"输入手机号码", @"Input phone number")
                                            delegate:self];
    
    
}


- (IBAction)touchIDAction:(id)sender {
    
    // 验证指纹
    [[CYCTouchID touchID] startCYCTouchIDWithMessage:CYCNotice(@"请验证指纹", @"Please use touchID")
                                       fallbackTitle:CYCNotice(@"输入手机号码", @"Input phone number")
                                            delegate:self];
    
}


#pragma mark - TouchID代理方法
// 验证成功
- (void)CYCTouchIDAuthorizeSuccess {
    
    // 改变主窗口
    CYCAppDelegate *delegate = (CYCAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.mainController == nil) {
        
        // 如果没有再创建，不然的话老是创建新的，上个页面就会丢失
        MMDrawerController *controller = [[MMDrawerController alloc] initWithCenterViewController:[[CYCTabBarController alloc] init]
                                                                         leftDrawerViewController:[[CYCLeftController alloc] init]];
        controller.maximumLeftDrawerWidth = cLeftControllerWidth;
        controller.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        controller.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        delegate.mainController = controller;
    }
    delegate.window.rootViewController = delegate.mainController;
    
}

// 验证失败
- (void)CYCTouchIDAuthorizeFailure {
    
    _tipLabel.text = @"验证失败，请点击重新验证";
    
}

// 取消TouchID验证 (用户点击了取消)
- (void)CYCTouchIDAuthorizeErrorUserCancel {
    
    _tipLabel.text = @"验证取消，请点击重新验证";
    
}
// 在TouchID对话框中点击输入密码按钮
- (void)CYCTouchIDAuthorizeErrorUserFallback {
    
    // 弹出输入手机号码的提示窗
    _tipLabel.text = @"输入电话号码以继续";
    
}
// 在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
- (void)CYCTouchIDAuthorizeErrorSystemCancel {
    
    _tipLabel.text = @"验证失败，请点击重新验证";
    
}
// 无法启用TouchID,设备没有设置密码
- (void)CYCTouchIDAuthorizeErrorPasscodeNotSet {
    
    _tipLabel.text = @"无法启用TouchID,设备没有设置密码";
    
}
// 设备没有录入TouchID,无法启用TouchID
- (void)CYCTouchIDAuthorizeErrorTouchIDNotEnrolled {
    
    _tipLabel.text = @"设备没有录入TouchID,无法启用TouchID";
    
}
// 该设备的TouchID无效
- (void)CYCTouchIDAuthorizeErrorTouchIDNotAvailable {
    
    _tipLabel.text = @"该设备的TouchID无效";
    
}
// 多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
- (void)CYCTouchIDAuthorizeErrorTouchIDLockout {
    
    _tipLabel.text = @"多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁";
    
}
// 当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
- (void)CYCTouchIDAuthorizeErrorAppCancel {
    
    _tipLabel.text = @"验证失败，请点击重新验证";
    
}
// 当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
- (void)CYCTouchIDAuthorizeErrorInvalidContext {
    
    _tipLabel.text = @"验证失败，请点击重新验证";
    
}
// 当前设备不支持指纹识别
- (void)CYCTouchIDIsNotSupport {
    
    _tipLabel.text = @"当前设备不支持指纹识别";
    
}




































@end
