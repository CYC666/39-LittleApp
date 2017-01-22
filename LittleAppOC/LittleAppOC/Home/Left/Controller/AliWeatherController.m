//
//  AliWeatherController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/23.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "AliWeatherController.h"
#import "CNetWorking.h"
#import "AliWeatherModel.h"
#import "Ali_AQI_Model.h"
#import "AliDailyModel.h"
#import "AliHourlyModel.h"
#import "ThemeManager.h"
#import "CThemeLabel.h"

@interface AliWeatherController ()

@property (strong, nonatomic) AliWeatherModel *weatherModel;    // 天气model
@property (strong, nonatomic) UIActivityIndicatorView *activityView;// 菊花

@end

@implementation AliWeatherController


// 传入地名以初始化
- (instancetype)initWithCityName:(NSString *)location {

    if (self = [super init]) {
        [CNetWorking loadComingDayWeatherWithLocation:location
                                              success:^(id response) {
                                                  
                                              } failure:^(NSError *err) {
                                                  
                                              }];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backItemAction:)];
    [backItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(searchItemAction:)];
    [searchItem setTintColor:[UIColor whiteColor]];
    [searchItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:searchItem];
    
    
    
    self.view.backgroundColor = CTHEME.themeColor;
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
    
}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    
}
#pragma mark - 返回按钮响应
- (void)backItemAction:(UIBarButtonItem *)item {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 导航栏搜索按钮
- (void)searchItemAction:(UIBarButtonItem *)item {
    
    
    
}






























#pragma mark - 控制器消失，移除观察者
- (void)dealloc {
    
    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];
    
}


@end
