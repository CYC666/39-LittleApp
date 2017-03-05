//
//  CYCTouchID.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/3/5.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CYCTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation CYCTouchID

static CYCTouchID *touchID;

+ (instancetype)touchID {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchID = [[self alloc]init];
    });
    return touchID;
}

- (void)startCYCTouchIDWithMessage:(NSString *)message
                     fallbackTitle:(NSString *)fallbackTitle
                          delegate:(id<CYCTouchIDDelegate>)delegate {

    // 创建连接
    LAContext *context = [[LAContext alloc] init];
    
    context.localizedFallbackTitle = fallbackTitle == nil ? CYCNotice(@"按钮标题", @"Fallback Title") : fallbackTitle;
    
    NSError *error = nil;
    
    self.delegate = delegate;
    
    NSAssert(self.delegate != nil, CYCNotice(@"CYCTouchIDDelegate 不能为空", @"CYCTouchIDDelegate must be non-nil"));

    // 如果能使用touchID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    
        // 开始链接
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:message == nil ? CYCNotice(@"自定义信息", @"The Custom Message") : message
                          reply:^(BOOL success, NSError * _Nullable error) {
        
                              if (success) {
                                  // 成功验证TouchID
                                  if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeSuccess)]) {
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          [self.delegate CYCTouchIDAuthorizeSuccess];
                                      }];
                                      
                                  }
                              
                              // 验证失败
                              } else if (error) {
                              
                                  switch (error.code) {
                                          
                                      case LAErrorAuthenticationFailed: {
                                          
                                          // 验证失败
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeFailure)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeFailure];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorUserCancel: {
                                          
                                          // 取消TouchID验证 (用户点击了取消)
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorUserCancel)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorUserCancel];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorUserFallback: {
                                          
                                          // 验证失败之后点击右边的按钮
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorUserFallback)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorUserFallback];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorSystemCancel:{
                                          
                                          // 在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorSystemCancel)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorSystemCancel];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorTouchIDNotEnrolled: {
                                          
                                          // 设备没有录入TouchID,无法启用TouchID
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorTouchIDNotEnrolled)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorTouchIDNotEnrolled];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorPasscodeNotSet: {
                                          
                                          // 无法启用TouchID,设备没有设置密码
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorPasscodeNotSet)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorPasscodeNotSet];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorTouchIDNotAvailable: {
                                          
                                          // 该设备的TouchID无效
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorTouchIDNotAvailable)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorTouchIDNotAvailable];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorTouchIDLockout: {
                                          
                                          // 多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorTouchIDLockout)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorTouchIDLockout];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorAppCancel:  {
                                          
                                          // 当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorAppCancel)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorAppCancel];
                                              }];
                                          }
                                      }
                                          break;
                                          
                                      case LAErrorInvalidContext: {
                                          
                                          // 当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
                                          if ([self.delegate respondsToSelector:@selector(CYCTouchIDAuthorizeErrorInvalidContext)]) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.delegate CYCTouchIDAuthorizeErrorInvalidContext];
                                              }];
                                          }
                                      }
                                          break;
                                  }
                              
                              }
        
        }];
    
    // 不能使用touchID
    } else {
        // 当前设备不支持指纹识别
        if ([self.delegate respondsToSelector:@selector(CYCTouchIDIsNotSupport)]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate CYCTouchIDIsNotSupport];
            }];
        }
    }
    
}





































@end
