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

@property (strong, nonatomic) AliWeatherModel *weatherModel;        // 天气model
@property (strong, nonatomic) UIActivityIndicatorView *activityView;// 菊花

@property (strong, nonatomic) UIButton *backButton;             // 返回按钮
@property (strong, nonatomic) UILabel *cityNameLabel;           // 城市名
@property (strong, nonatomic) UILabel *weatherLabel;            // 天气
@property (strong, nonatomic) UILabel *tempLabel;               // 当前气温


@end

@implementation AliWeatherController


// 传入地名以初始化
- (instancetype)initWithCityName:(NSString *)location {

    if (self = [super init]) {
        [self.activityView startAnimating];
        __weak typeof(self) weakSelf = self;
        [CNetWorking loadComingDayWeatherWithLocation:location
                                              success:^(id response) {
                                                  //  处理数据
                                                  if ([response[@"msg"] isEqualToString:@"ok"]) {
                                                      NSDictionary *data = response[@"result"];
                                                      [weakSelf loadData:data];
                                                  }
                                                  [weakSelf.activityView stopAnimating];
                                              } failure:^(NSError *err) {
                                                  [weakSelf.activityView stopAnimating];
                                              }];
    }
    return self;

}

// -----------------------------------------------------懒加载-----------------------------------------------------
// 菊花
- (UIActivityIndicatorView *)activityView {
    
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)/2.0, (kScreenHeight - 64 - 50)/2.0, 50, 50)];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityView];
    }
    return _activityView;
    
}
// 城市名
- (UILabel *)cityNameLabel {

    if (_cityNameLabel == nil) {
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2.0, 80, 200, 40)];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.font = C_MAIN_FONT(35);
        _cityNameLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_cityNameLabel];
    }
    return _cityNameLabel;

}
// 天气描述
- (UILabel *)weatherLabel {
    
    if (_weatherLabel == nil) {
        _weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2.0, 120, 200, 20)];
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.font = C_MAIN_FONT(15);
        _weatherLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_weatherLabel];
    }
    return _weatherLabel;
    
}
// 气温
- (UILabel *)tempLabel {
    
    if (_tempLabel == nil) {
        _tempLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2.0, 150, 100, 80)];
        _tempLabel.textAlignment = NSTextAlignmentCenter;
        _tempLabel.font = [UIFont systemFontOfSize:80];
        _tempLabel.textColor = [UIColor whiteColor];
        _tempLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_tempLabel];
        // 设置度º
        UILabel *zeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 - 20, 0, 20, 20)];
        zeroLabel.text = @"o";
        zeroLabel.textColor = [UIColor whiteColor];
        zeroLabel.textAlignment = NSTextAlignmentCenter;
        zeroLabel.font = [UIFont systemFontOfSize:20];
        [_tempLabel addSubview:zeroLabel];
    }
    return _tempLabel;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 20, 60, 60);
    [_backButton setImage:[UIImage imageNamed:@"icon_weather_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    
    self.view.backgroundColor = CTHEME.themeType == CDayTheme ? CRGB(64, 154, 195, 1) : CRGB(4, 29, 63, 1);
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
    
}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeType == CDayTheme ? CRGB(50, 145, 192, 1) : CRGB(4, 29, 63, 1);
    
}
#pragma mark - 返回按钮响应
- (void)backItemAction:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


// -----------------------------------------------------数据的加载-----------------------------------------------------
- (void)loadData:(NSDictionary *)data {

    _weatherModel = [[AliWeatherModel alloc] init];
    _weatherModel.city = data[@"city"];
    _weatherModel.cityid = data[@"cityid"];
    _weatherModel.citycode = data[@"citycode"];
    _weatherModel.date = data[@"date"];
    _weatherModel.week = data[@"week"];
    _weatherModel.weather = data[@"weather"];
    _weatherModel.temp = data[@"temp"];
    _weatherModel.temphigh = data[@"temphigh"];
    _weatherModel.templow = data[@"templow"];
    _weatherModel.img = data[@"img"];
    _weatherModel.humidity = data[@"humidity"];
    _weatherModel.pressure = data[@"pressure"];
    _weatherModel.windspeed = data[@"windspeed"];
    _weatherModel.winddirect = data[@"winddirect"];
    _weatherModel.windpower = data[@"windpower"];
    _weatherModel.updatetime = data[@"updatetime"];
    
    Ali_AQI_Model *AQI_model = [[Ali_AQI_Model alloc] init];
    AQI_model.primarypollutant = data[@"aqi"][@"primarypollutant"];
    AQI_model.quality = data[@"aqi"][@"quality"];
    AQI_model.aqiinfo_affect = data[@"aqi"][@"aqiinfo"][@"affect"];
    AQI_model.aqiinfo_measure = data[@"aqi"][@"aqiinfo"][@"measure"];
    _weatherModel.aqi = AQI_model;
    
    NSArray *dailyData = data[@"daily"];
    NSMutableArray *dailyMutableArray = [NSMutableArray array];
    for (NSDictionary *dailyDic in dailyData) {
        AliDailyModel *dailyModel = [[AliDailyModel alloc] init];
        dailyModel.date = dailyDic[@"date"];
        dailyModel.week = dailyDic[@"week"];
        dailyModel.sunrise = dailyDic[@"sunrise"];
        dailyModel.sunset = dailyDic[@"sunset"];
        dailyModel.night_weather = dailyDic[@"night"][@"weather"];
        dailyModel.night_templow = dailyDic[@"night"][@"templow"];
        dailyModel.night_img = dailyDic[@"night"][@"img"];
        dailyModel.night_winddirect = dailyDic[@"night"][@"winddirect"];
        dailyModel.night_windpower = dailyDic[@"night"][@"windpower"];
        dailyModel.day_weather = dailyDic[@"day"][@"weather"];
        dailyModel.day_temphigh = dailyDic[@"day"][@"temphigh"];
        dailyModel.day_img = dailyDic[@"day"][@"img"];
        dailyModel.day_winddirect = dailyDic[@"day"][@"winddirect"];
        dailyModel.day_windpower = dailyDic[@"day"][@"windpower"];
        
        [dailyMutableArray addObject:dailyModel];
    }
    _weatherModel.dailyArray = (NSArray *)dailyMutableArray;
    
    NSArray *hourlyData = data[@"hourly"];
    NSMutableArray *hourlyMutableArray = [NSMutableArray array];
    for (NSDictionary *hourlyDic in hourlyData) {
        AliHourlyModel *hourlyModel = [[AliHourlyModel alloc] init];
        hourlyModel.time = hourlyDic[@"time"];
        hourlyModel.weather = hourlyDic[@"weather"];
        hourlyModel.temp = hourlyDic[@"temp"];
        hourlyModel.img = hourlyDic[@"img"];
        
        [hourlyMutableArray addObject:hourlyModel];
    }
    _weatherModel.hourlyArray = (NSArray *)hourlyMutableArray;

    
    // 跳转处理UI
    [self creatSubviews];
}

#pragma mark - 处理UI
- (void)creatSubviews {

    self.cityNameLabel.text = _weatherModel.city;
    self.weatherLabel.text = _weatherModel.weather;
    self.tempLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.temp];
    

}


























#pragma mark - 控制器消失，移除观察者
- (void)dealloc {
    
    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];
    
}


@end
