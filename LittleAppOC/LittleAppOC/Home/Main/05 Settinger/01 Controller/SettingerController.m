//
//  SettingerController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "SettingerController.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "PasswordController.h"
#import "CYCTouchID.h"

#define SettingCellID @"SettingCellID"

@interface SettingerController () <UITableViewDataSource, UITableViewDelegate, CYCTouchIDDelegate>

@property (strong, nonatomic) UITableView *setTableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) UISwitch *passwordSwitch;     // 密码开关
@property (strong, nonatomic) UISwitch *touchIDSwitch;      // TouchID开关




@end

@implementation SettingerController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"设置";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    self.view.backgroundColor = CTHEME.themeColor;
    
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
    
    // 数据数组
    _titleArray = @[@"密码访问", @"Touch ID", @"清除缓存"];
    _imageArray = @[@"setting_password", @"setting_touchID", @"setting_clear"];
    
    // 表视图
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49)
                                                 style:UITableViewStyleGrouped];
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    [_setTableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 0)];
    [self.view addSubview:_setTableView];
    [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SettingCellID];
    
}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    
}


#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingCellID];
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    
    
    
    if (indexPath.row == 0) {
        // 访问密码开关
        _passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 20, 5, 80, 40)];
        
        if ([CUSER objectForKey:CPassword]) {
            // 密码存在就是开
            [_passwordSwitch setOn:YES];
        } else {
            [_passwordSwitch setOn:NO];
        }
        [_passwordSwitch addTarget:self action:@selector(passwordSwitchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _passwordSwitch;
        cell.detailTextLabel.text = @"App变活跃需要";
    
    } else if (indexPath.row == 1) {
        // 使用TouchID的开关
        _touchIDSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 20, 5, 80, 40)];
        
        if ([CUSER boolForKey:CTouchID]) {
            // 密码存在就是开
            [_touchIDSwitch setOn:YES];
        } else {
            [_touchIDSwitch setOn:NO];
        }
        [_touchIDSwitch addTarget:self action:@selector(touchIDSwitchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _touchIDSwitch;
        cell.detailTextLabel.text = @"起动App需要";

    } else if (indexPath.row == 2) {
        // 清除缓存
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark - 是否设置密码开关
- (void)passwordSwitchAction:(UISwitch *)swi {

    if (swi.on) {
        // 前往设置密码
        PasswordController *controller = [[PasswordController alloc] init];
        controller.controllerType = PasswordControllerSetPassword;
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        // 把密码删了
        [CUSER removeObjectForKey:CPassword];
    
    }

}

#pragma mark - 开启TouchID的开关
- (void)touchIDSwitchAction:(UISwitch *)swi {
    
    if (swi.on) {
        
        // 验证指纹
        [[CYCTouchID touchID] startCYCTouchIDWithMessage:CYCNotice(@"请验证指纹", @"Please use touchID")
                                           fallbackTitle:CYCNotice(@"不使用", @"Don't use touchID")
                                                delegate:self];
        
    } else {
        // 关了
        [[CYCTouchID touchID] startCYCTouchIDWithMessage:CYCNotice(@"请验证指纹", @"Please use touchID")
                                           fallbackTitle:CYCNotice(@"输入手机号码", @"Input phone number")
                                                delegate:self];
    }
    
    
}

#pragma mark - TouchID代理方法
// 验证成功
- (void)CYCTouchIDAuthorizeSuccess {

    if (_touchIDSwitch.on) {
        // 设置本地需要touchID
        [CUSER setBool:YES forKey:CTouchID];
    } else {
        // 设置本地不需要touchID
        [CUSER setBool:NO forKey:CTouchID];
    }
    
}

// 验证失败
- (void)CYCTouchIDAuthorizeFailure {

    [self touchIDFaile];

}

// 取消TouchID验证 (用户点击了取消)
- (void)CYCTouchIDAuthorizeErrorUserCancel {

    [self touchIDFaile];

}
// 在TouchID对话框中点击输入密码按钮
- (void)CYCTouchIDAuthorizeErrorUserFallback {

    if (_touchIDSwitch.on) {
        // 不使用touchID
        [_touchIDSwitch setOn:NO];
    } else {
        // 弹出需要输入手机号码的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入电话号码"
                                                                       message:@"输入正确即可关闭touchID"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // 创建文本框
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"请输入您的手机号码";
            textField.secureTextEntry = NO;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               if ([alert.textFields.firstObject.text isEqualToString:[CUSER objectForKey:CUserPhone]]) {
                                                                   
                                                                   // 输入正确，关闭touchID
                                                                   [_touchIDSwitch setOn:NO];
                                                                   [CUSER setBool:NO forKey:CTouchID];
                                                                   
                                                               } else {
                                                                   
                                                                   // 输入错误，无效，继续使用touchID
                                                                   [_touchIDSwitch setOn:YES];
                                                               }
                                                               
                                                           }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
// 在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
- (void)CYCTouchIDAuthorizeErrorSystemCancel {

    [self touchIDFaile];

}
// 无法启用TouchID,设备没有设置密码
- (void)CYCTouchIDAuthorizeErrorPasscodeNotSet {

    [self touchIDFaile];

}
// 设备没有录入TouchID,无法启用TouchID
- (void)CYCTouchIDAuthorizeErrorTouchIDNotEnrolled {

    [self touchIDFaile];

}
// 该设备的TouchID无效
- (void)CYCTouchIDAuthorizeErrorTouchIDNotAvailable {

    [self touchIDFaile];

}
// 多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
- (void)CYCTouchIDAuthorizeErrorTouchIDLockout {

    [self touchIDFaile];

}
// 当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
- (void)CYCTouchIDAuthorizeErrorAppCancel {

    [self touchIDFaile];

}
// 当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
- (void)CYCTouchIDAuthorizeErrorInvalidContext {

    [self touchIDFaile];

}
// 当前设备不支持指纹识别
- (void)CYCTouchIDIsNotSupport {

    [self touchIDFaile];

}

#pragma mark - 指纹验证失败、取消等统一反应
- (void)touchIDFaile {

    if (_touchIDSwitch.on) {
        [_touchIDSwitch setOn:NO];
        [CUSER setBool:NO forKey:CTouchID];
    } else {
        [_touchIDSwitch setOn:YES];
        [CUSER setBool:YES forKey:CTouchID];
    }
    
}























































@end
