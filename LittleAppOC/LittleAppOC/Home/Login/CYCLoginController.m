//
//  CYCLoginController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/30.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CYCLoginController.h"

#import "SMS_HYZBadgeView.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <SMS_SDK/SMSSDK.h>
#import "SMSSDKUI.h"
#import "MMDrawerController.h"
#import "CYCTabBarController.h"
#import "CYCLeftController.h"


@interface CYCLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;   // 电话号码输入框
@property (weak, nonatomic) IBOutlet UIButton *loginButton;     // 登录按钮
@property (strong, nonatomic) UIView *receiveView;              // 接收验证码的框框
@property (strong, nonatomic) UITextField *compareField;        // 验证码输入框

@end

@implementation CYCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _inputField.layer.cornerRadius = 25;
    _inputField.layer.borderWidth = 2;
    _inputField.layer.borderColor = C_MAIN_COLOR.CGColor;
    
    _loginButton.layer.cornerRadius = 25;
    
    // 添加手势，隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(hideKeyBoardGesture:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (UIView *)receiveView {

    if (_receiveView == nil) {
        
        // 底部遮罩层
        UIView *hideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        hideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self.view addSubview:hideView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardGesture:)];
        [hideView addGestureRecognizer:tap];
        
        _receiveView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 300)/2.0, 200, 300, 200)];
        _receiveView.backgroundColor = CRGB(88, 225, 74, 1);
        _receiveView.layer.cornerRadius = 10;
        _receiveView.layer.borderWidth = 1;
        _receiveView.layer.borderColor = [UIColor yellowColor].CGColor;
        [self.view addSubview:_receiveView];
        
        // 请输入验证码
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 30)];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = C_MAIN_FONT(30);
        tipLabel.text = @"请输入验证码";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [_receiveView addSubview:tipLabel];
        
        // 输入框
        _compareField = [[UITextField alloc] initWithFrame:CGRectMake((300 - 100)/2.0, 70, 100, 50)];
        _compareField.borderStyle = UITextBorderStyleNone;
        _compareField.backgroundColor = [UIColor whiteColor];
        _compareField.layer.cornerRadius = 25;
        _compareField.textAlignment = NSTextAlignmentCenter;
        _compareField.keyboardType = UIKeyboardTypePhonePad;
        _compareField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _compareField.returnKeyType = UIReturnKeyDone;
        [_receiveView addSubview:_compareField];
        
        // 确定按钮
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake((300 - 100)/2.0, 130, 100, 50);
        [sureButton setBackgroundColor:CRGB(40, 170, 235, 1)];
        sureButton.layer.cornerRadius = 25;
        [sureButton setTitle:@"确定" forState:UIWindowLevelNormal];
        [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_receiveView addSubview:sureButton];
        
    }
    return _receiveView;

}



// 发送验证码
- (IBAction)send:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    // 判断是否是手机号码
    if ([self validateMobile:_inputField.text]) {
        
        __weak typeof(self) weakSelf = self;
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                                phoneNumber:_inputField.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error){
                                         if (!error) {
                                             
                                             // 弹出接收验证码的框框
                                             
                                             [UIView animateWithDuration:.1
                                                              animations:^{
                                                                  weakSelf.receiveView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                                              } completion:^(BOOL finished) {
                                                                  [UIView animateWithDuration:.2
                                                                                   animations:^{
                                                                                       weakSelf.receiveView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                                                                   } completion:^(BOOL finished) {
                                                                                       [UIView animateWithDuration:.1
                                                                                                        animations:^{
                                                                                                            weakSelf.receiveView.transform = CGAffineTransformMakeScale(1, 1);
                                                                                                        }];
                                                                                   }];
                                                              }];
                                             
                                         } else {
                                             NSLog(@"错误信息：%@",error);
                                         }
                                     }];
        
    } else {
        // 请输入正确的手机号码
        [UIView animateWithDuration:.1
                         animations:^{
                             _inputField.transform = CGAffineTransformMakeTranslation(-10, 0);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:.2
                                              animations:^{
                                                  _inputField.transform = CGAffineTransformMakeTranslation(10, 0);
                                              } completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:.1
                                                                   animations:^{
                                                                       _inputField.transform = CGAffineTransformMakeTranslation(0, 0);
                                                                   }];
                                              }];
                         }];

    }
    
    
}





// 验证手机号码
- (BOOL)validateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9]|(19[0-9])))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 隐藏键盘的手势
- (void)hideKeyBoardGesture:(UITapGestureRecognizer *)tap {

    [[UIApplication sharedApplication].keyWindow endEditing:YES];

}



// 验证码输入框确定按钮
- (void)sureButtonAction:(UIButton *)button {
    
    // 验证码是否正确
    [SMSSDK commitVerificationCode:_compareField.text
                       phoneNumber:_inputField.text
                              zone:@"86"
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
            if (!error) {
                
                // 本地储存登录状态
                [CUSER setObject:_inputField.text forKey:CUserPhone];
                
                // 改变APP的主窗口
                MMDrawerController *controller = [[MMDrawerController alloc] initWithCenterViewController:[[CYCTabBarController alloc] init]
                                                                                 leftDrawerViewController:[[CYCLeftController alloc] init]];
                controller.maximumLeftDrawerWidth = cLeftControllerWidth;
                controller.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
                controller.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
                [[UIApplication sharedApplication] delegate].window.rootViewController = controller;
                
            } else {
                // 振动
                [UIView animateWithDuration:.1
                                 animations:^{
                                     self.receiveView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                 } completion:^(BOOL finished) {
                                     [UIView animateWithDuration:.2
                                                      animations:^{
                                                          self.receiveView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                                      } completion:^(BOOL finished) {
                                                          [UIView animateWithDuration:.1
                                                                           animations:^{
                                                                               self.receiveView.transform = CGAffineTransformMakeScale(1, 1);
                                                                           }];
                                                      }];
                                 }];

            }
        
    }];
    
}

// 键盘弹起收缩的通知响应
- (void)keyboardNotification:(NSNotification *)notifi {

    if ([notifi.name isEqualToString:UIKeyboardWillShowNotification]) {
        [UIView animateWithDuration:.35
                         animations:^{
                             _inputField.transform = CGAffineTransformMakeTranslation(0, -10);
                         }];
    } else if ([notifi.name isEqualToString:UIKeyboardWillHideNotification]) {
        [UIView animateWithDuration:.35
                         animations:^{
                             _inputField.transform = CGAffineTransformMakeTranslation(0, 0);
                         }];
    }

}






























// 控制器销毁
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}





@end


/*
 
 - (IBAction)login:(id)sender {
 
 
 //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
 [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodVoice result:^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone, NSError *error) {
 
 // 本地储存登录状态
 [CUSER setObject:phoneNumber forKey:CUserPhone];
 
 // 改变APP的主窗口
 MMDrawerController *controller = [[MMDrawerController alloc] initWithCenterViewController:[[CYCTabBarController alloc] init]
 leftDrawerViewController:[[CYCLeftController alloc] init]];
 controller.maximumLeftDrawerWidth = cLeftControllerWidth;
 controller.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
 controller.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
 [[UIApplication sharedApplication] delegate].window.rootViewController = controller;
 
 }];
 }
 
 
 // 隐藏窗口
 [UIView animateWithDuration:.2
 animations:^{
 self.receiveView.transform = CGAffineTransformMakeScale(0.2, 0.2);
 } completion:^(BOOL finished) {
 [UIView animateWithDuration:.1
 animations:^{
 self.receiveView.alpha = 0;
 } completion:^(BOOL finished) {
 [self.receiveView removeFromSuperview];
 }];
 }];
 
 
 
 // 验证码输入框取消按钮
 - (void)cancelButtonAction:(UIButton *)button {
 
 [UIView animateWithDuration:.2
 animations:^{
 self.receiveView.transform = CGAffineTransformMakeScale(0.2, 0.2);
 } completion:^(BOOL finished) {
 [UIView animateWithDuration:.1
 animations:^{
 self.receiveView.alpha = 0;
 } completion:^(BOOL finished) {
 [self.receiveView removeFromSuperview];
 }];
 }];
 
 }

 
 
 
 */
