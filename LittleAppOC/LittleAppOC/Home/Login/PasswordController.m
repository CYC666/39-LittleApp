//
//  PasswordController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/26.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "PasswordController.h"
#import "MMDrawerController.h"
#import "CYCTabBarController.h"
#import "CYCLeftController.h"
#import "CYCAppDelegate.h"

@interface PasswordController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *passwordArray;

@end

@implementation PasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _passwordArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    
    if (_controllerType == PasswordControllerGoIn) {
        _sureButton.hidden = YES;
        _titleLabel.text = @"输入密码";
    } else {
        _sureButton.hidden = NO;
        _titleLabel.text = @"设置密码";
    }
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


#pragma mark - 代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return _passwordArray.count;

}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return _passwordArray[row];

}



// 设置密码时的确定按钮(设置密码是模态弹出，所以dismiss)
- (IBAction)sureButton:(id)sender {
    
    // 将六位密码拼接在一起，并存到本地
    NSString *password = [NSString stringWithFormat:@"%ld_%ld_%ld_%ld_%ld_%ld",
                          [_passA selectedRowInComponent:0],
                          [_passB selectedRowInComponent:0],
                          [_passC selectedRowInComponent:0],
                          [_passD selectedRowInComponent:0],
                          [_passE selectedRowInComponent:0],
                          [_passF selectedRowInComponent:0]];
    
    [CUSER setObject:password forKey:CPassword];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    // 密码由六位数字组成,并且用_分割
    NSString *password = [CUSER objectForKey:CPassword];
    
    NSArray *array = [password componentsSeparatedByString:@"_"];
    
    if (password) {
        // 如果存在密码(登录的时候)
        
        if (
            // 判断密码是否一致
             [_passA selectedRowInComponent:0] == [array[0] integerValue] &&
             [_passB selectedRowInComponent:0] == [array[1] integerValue] &&
             [_passC selectedRowInComponent:0] == [array[2] integerValue] &&
             [_passD selectedRowInComponent:0] == [array[3] integerValue] &&
             [_passE selectedRowInComponent:0] == [array[4] integerValue] &&
             [_passF selectedRowInComponent:0] == [array[5] integerValue]
            
            ) {
            
            // 密码正确，进入App(输入密码时，是app主控制器，不应该用dismiss)
            // 改变APP的主窗口
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
    } 

}

































@end
