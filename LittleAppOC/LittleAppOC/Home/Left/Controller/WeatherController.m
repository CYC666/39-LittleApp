//
//  WeatherController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "WeatherController.h"
#import "CNetWorking.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"
#import "WeatherModel.h"

@interface WeatherController ()

@property (copy, nonatomic) NSString *locationID;                   // 城市的ID
@property (copy, nonatomic) NSString *locationName;                 // 城市名
@property (copy, nonatomic) NSString *locationtimezone;             // 城市的时区
@property (strong, nonatomic) NSMutableArray *weatherArray;         // 储存天气的model

@end

@implementation WeatherController

- (instancetype)initWithLocation:(NSString *)location {

    if (self = [super init]) {
        // 请求数据
        [CNetWorking loadComingDayWeatherWithLocation:location
                                              success:^(id response) {
                                                  if (response[@"results"] != nil) {
                                                      [self loadWeatherData:[response[@"results"] firstObject]];
                                                  }
                                              } failure:^(NSError *err) {
                                                  
                                              }];
    }
    return self;

}

#pragma mark - 懒加载
- (NSMutableArray *)weatherArray {

    if (_weatherArray == nil) {
        _weatherArray = [NSMutableArray array];
    }
    return _weatherArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backItemAction:)];
    [backItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
    
    
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


#pragma mark - 解析数据
- (void)loadWeatherData:(NSDictionary *)data {

    _locationID = data[@"location"][@"id"];
    _locationName = data[@"location"][@"name"];
    _locationtimezone = data[@"location"][@"timezone"];
    NSArray *array = data[@"daily"];
    for (NSDictionary *dic in array) {
        WeatherModel *model = [[WeatherModel alloc] init];
        model.date = dic[@"date"];
        model.text_day = dic[@"text_day"];
        model.code_day = dic[@"code_day"];
        model.text_night = dic[@"text_night"];
        model.code_night = dic[@"code_night"];
        model.high = dic[@"high"];
        model.low = dic[@"low"];
        model.precip = dic[@"precip"];
        model.wind_direction = dic[@"wind_direction"];
        model.wind_direction_degree = dic[@"wind_direction_degree"];
        model.wind_speed = dic[@"wind_speed"];
        model.wind_scale = dic[@"wind_scale"];
        
        [self.weatherArray addObject:model];
    }

}

#pragma mark - 返回按钮响应
- (void)backItemAction:(UIBarButtonItem *)item {

    [self dismissViewControllerAnimated:YES completion:nil];

}


































@end
