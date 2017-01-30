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

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) UIView *receiveView;              // 接收验证码的框框
@property (copy, nonatomic) NSString *phoneNum;                 // 电话号码
@property (copy, nonatomic) NSString *compareStr;               // 验证码

@end

@implementation CYCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加手势，隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(hideKeyBoardGesture:)];
    [self.view addGestureRecognizer:tap];
    
}

- (UIView *)receiveView {

    if (_receiveView == nil) {
        _receiveView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 300)/2.0, 200, 300, 200)];
        _receiveView.backgroundColor = [UIColor orangeColor];
        _receiveView.layer.cornerRadius = 10;
        _receiveView.layer.borderWidth = 2;
        _receiveView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:_receiveView];
        
        // 请输入验证码
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 300, 20)];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = C_MAIN_FONT(20);
        tipLabel.text = @"请输入验证码";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [_receiveView addSubview:tipLabel];
        
        // 输入框
        UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
        input.borderStyle = UITextBorderStyleRoundedRect;
        input.keyboardType = UIKeyboardTypePhonePad;
        input.clearButtonMode = UITextFieldViewModeWhileEditing;
        input.returnKeyType = UIReturnKeyDone;
        [_receiveView addSubview:input];
        
        // 取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(50, 140, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIWindowLevelNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_receiveView addSubview:cancelButton];
        
        
        // 确定按钮
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(210, 140, 40, 40);
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
        
        _phoneNum = _inputField.text;
        __weak typeof(self) weakSelf = self;
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodVoice
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


// 验证码输入框确定按钮
- (void)sureButtonAction:(UIButton *)button {
    
    // 验证码是否正确
    [SMSSDK commitVerificationCode:_compareStr
                       phoneNumber:_phoneNum
                              zone:@"86"
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
            if (!error) {
                
                NSLog(@"验证成功");
            } else {
                NSLog(@"错误信息:%@",error);
            }
        
    }];
    
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
 
 
 
 */
