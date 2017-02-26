//
//  PasswordController.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/26.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 输入密码进入app

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PasswordControllerGoIn,
    PasswordControllerSetPassword
} PasswordControllerType;

@interface PasswordController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *passA;
@property (weak, nonatomic) IBOutlet UIPickerView *passB;
@property (weak, nonatomic) IBOutlet UIPickerView *passC;
@property (weak, nonatomic) IBOutlet UIPickerView *passD;
@property (weak, nonatomic) IBOutlet UIPickerView *passE;
@property (weak, nonatomic) IBOutlet UIPickerView *passF;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (assign, nonatomic) PasswordControllerType controllerType;

@end
