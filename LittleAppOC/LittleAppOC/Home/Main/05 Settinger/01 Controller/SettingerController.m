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

#define SettingCellID @"SettingCellID"

@interface SettingerController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *setTableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *imageArray;




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
    _titleArray = @[@"使用密码访问", @"清除缓存"];
    _imageArray = @[@"setting_password", @"setting_clear"];
    
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

    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingCellID];
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    
    
    
    if (indexPath.row == 0) {
        // 访问密码开关
        UISwitch *passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 20, 5, 80, 40)];
        
        if ([CUSER objectForKey:CPassword]) {
            // 密码存在就是开
            [passwordSwitch setOn:YES];
        }
        [passwordSwitch addTarget:self action:@selector(passwordSwitchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = passwordSwitch;
    
    } else if (indexPath.row == 1) {
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































































@end
