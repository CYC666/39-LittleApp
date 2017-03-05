//
//  CYCTouchID.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/3/5.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 做指纹验证的类
// 单例


#import <Foundation/Foundation.h>

// 根据App的语言类型，设置提示是否用中文
#define CYCNotice(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Hans"] ? Chinese : English

// TouchID 识别结果代理方法
@protocol CYCTouchIDDelegate <NSObject>


@required

// 成功与失败两个代理方法是必须实现的
- (void)CYCTouchIDAuthorizeSuccess;     // 验证成功
- (void)CYCTouchIDAuthorizeFailure;      // 验证失败

@optional

- (void)CYCTouchIDAuthorizeErrorUserCancel;                  // 取消TouchID验证 (用户点击了取消)
- (void)CYCTouchIDAuthorizeErrorUserFallback;                // 在TouchID对话框中点击输入密码按钮
- (void)CYCTouchIDAuthorizeErrorSystemCancel;                // 在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
- (void)CYCTouchIDAuthorizeErrorPasscodeNotSet;              // 无法启用TouchID,设备没有设置密码
- (void)CYCTouchIDAuthorizeErrorTouchIDNotEnrolled;          // 设备没有录入TouchID,无法启用TouchID
- (void)CYCTouchIDAuthorizeErrorTouchIDNotAvailable;         // 该设备的TouchID无效
- (void)CYCTouchIDAuthorizeErrorTouchIDLockout;              // 多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
- (void)CYCTouchIDAuthorizeErrorAppCancel;                   // 当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
- (void)CYCTouchIDAuthorizeErrorInvalidContext;              // 当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
- (void)CYCTouchIDIsNotSupport;                              // 当前设备不支持指纹识别

@end


@interface CYCTouchID : NSObject

@property (nonatomic, weak) id<CYCTouchIDDelegate> delegate; // 代理对象

// 发起TouchID验证(开始识别时的提示文本、识别失败时右边的按钮)
- (void)startCYCTouchIDWithMessage:(NSString *)message
                     fallbackTitle:(NSString *)fallbackTitle
                          delegate:(id<CYCTouchIDDelegate>)delegate;

// 创建，单例
+ (instancetype)touchID;


@end
