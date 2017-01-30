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
#import "SMSSDKUI.h"
#import "MMDrawerController.h"
#import "CYCTabBarController.h"
#import "CYCLeftController.h"


@interface CYCLoginController ()

@end

@implementation CYCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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






@end
