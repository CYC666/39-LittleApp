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

#define AliHourlyStartY (kScreenHeight/2.0 - 120)               // 的起点
#define AliHourlyCellWidth 60                                   // 时刻表的温度单元格宽度
#define AliHourlyHeight 100                                     // 时刻表的高度
#define AliTemplowLabelColor CRGB(155, 200, 221, 1)             // 最低温的标签颜色


@interface AliWeatherController ()

@property (strong, nonatomic) AliWeatherModel *weatherModel;        // 天气model
@property (strong, nonatomic) UIActivityIndicatorView *activityView;// 菊花

@property (strong, nonatomic) UIButton *backButton;             // 返回按钮
@property (strong, nonatomic) UILabel *cityNameLabel;           // 城市名
@property (strong, nonatomic) UILabel *weatherLabel;            // 天气
@property (strong, nonatomic) UILabel *tempLabel;               // 当前气温
@property (strong, nonatomic) UILabel *weekLabel;               // 星期几
@property (strong, nonatomic) UILabel *temphighLabel;           // 今天的最高温度
@property (strong, nonatomic) UILabel *templowLabel;            // 今天的最低温度
@property (strong, nonatomic) UIScrollView *mainScrollView;     // 承载时刻气温和未来几天两个滑动视图的主滑动视图


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
// 星期几
- (UILabel *)weekLabel {
    
    if (_weekLabel == nil) {
        _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, AliHourlyStartY - 25, 100, 20)];
        _weekLabel.textAlignment = NSTextAlignmentLeft;
        _weekLabel.font = C_MAIN_FONT(15);
        _weekLabel.textColor = [UIColor whiteColor];
        [_mainScrollView addSubview:_weekLabel];
    }
    return _weekLabel;
    
}
// 今天的最高温度
- (UILabel *)temphighLabel {
    
    if (_temphighLabel == nil) {
        _temphighLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, AliHourlyStartY - 25, 30, 20)];
        _temphighLabel.textAlignment = NSTextAlignmentLeft;
        _temphighLabel.font = C_MAIN_FONT(15);
        _temphighLabel.textColor = [UIColor whiteColor];
        [_mainScrollView addSubview:_temphighLabel];
    }
    return _temphighLabel;
    
}
// 今天的最低温度
- (UILabel *)templowLabel {
    
    if (_templowLabel == nil) {
        _templowLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, AliHourlyStartY - 25, 30, 20)];
        _templowLabel.textAlignment = NSTextAlignmentRight;
        _templowLabel.font = C_MAIN_FONT(15);
        _templowLabel.textColor = AliTemplowLabelColor;
        [_mainScrollView addSubview:_templowLabel];
    }
    return _templowLabel;
    
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

    // 城市名、天气描述、气温
    self.cityNameLabel.text = _weatherModel.city;
    self.weatherLabel.text = _weatherModel.weather;
    self.tempLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.temp];
    
    // 主滑动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, kScreenHeight - 120)];
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 120 + (kScreenHeight/2.0 - 120));
    _mainScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    // 星期几 今天
    self.weekLabel.text = [NSString stringWithFormat:@"%@  今天", _weatherModel.week];
    
    // 今天最高最低温度
    self.temphighLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.temphigh];
    self.templowLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.templow];
    
    // 时刻气温表
    UIScrollView *hourlyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, AliHourlyStartY, kScreenWidth, AliHourlyHeight)];
    hourlyScrollView.contentSize = CGSizeMake( AliHourlyCellWidth * (_weatherModel.hourlyArray.count + 1), AliHourlyHeight);
    [_mainScrollView addSubview:hourlyScrollView];
    
    // 上下横线
    CALayer *topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(0, AliHourlyStartY, kScreenWidth, 0.5);
    topLine.backgroundColor = [UIColor whiteColor].CGColor;
    [_mainScrollView.layer addSublayer:topLine];
    CALayer *bottomLine = [[CALayer alloc] init];
    bottomLine.frame = CGRectMake(0, AliHourlyStartY + AliHourlyHeight - 0.5, kScreenWidth, 0.5);
    bottomLine.backgroundColor = [UIColor whiteColor].CGColor;
    [_mainScrollView.layer addSublayer:bottomLine];
    
    
    // 获取今天的日出日落时间
    AliDailyModel *todayDailyModel = [_weatherModel.dailyArray firstObject];
    NSInteger sunriseInt = [[[todayDailyModel.sunrise componentsSeparatedByString:@":"] firstObject] integerValue];
    NSInteger sunsetInt = [[[todayDailyModel.sunset componentsSeparatedByString:@":"] firstObject] integerValue];
    
    for (NSInteger i = 0; i < (_weatherModel.hourlyArray.count + 1); i++) {
        
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(AliHourlyCellWidth * i, 0, AliHourlyCellWidth, AliHourlyHeight)];
        [hourlyScrollView addSubview:cell];
        
        // 时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, AliHourlyCellWidth, 20)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor whiteColor];
        [cell addSubview:timeLabel];
        
        // img
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((AliHourlyCellWidth - 25)/2.0, (AliHourlyHeight - 25)/2.0, 25, 25)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:imgView];
        
        // 温度
        UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AliHourlyHeight - 20 - 5, AliHourlyCellWidth, 20)];
        temperatureLabel.textAlignment = NSTextAlignmentCenter;
        temperatureLabel.font = [UIFont systemFontOfSize:13];
        temperatureLabel.textColor = [UIColor whiteColor];
        [cell addSubview:temperatureLabel];
        
        // 第一格数据不在hourly模型里,直接拿weather模型的数据
        if (i == 0) {
            timeLabel.text = @"现在";
            
            // 拿更新的时间时间跟日出日落时间对照，判断现在是否是白天,根据状态分别设置
            NSInteger currentTimeInt = [[_weatherModel.updatetime substringWithRange:NSMakeRange(11, 2)] integerValue];
            if (currentTimeInt > sunriseInt && currentTimeInt < sunsetInt) {
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_weatner_day_%@", _weatherModel.img]];
            } else {
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_weatner_night_%@", _weatherModel.img]];
            }
            
            temperatureLabel.text = [NSString stringWithFormat:@"%@º", _weatherModel.temp];
            
        } else {
            AliHourlyModel *model = _weatherModel.hourlyArray[i-1];
            
            // 拼接 （11时）
            NSArray *timeArray = [model.time componentsSeparatedByString:@":"];
            timeLabel.text = [NSString stringWithFormat:@"%@时", [timeArray firstObject]];
            
            // 时间跟日出日落时间对照，判断是否是白天,根据状态分别设置
            if ([[timeArray firstObject] integerValue] > sunriseInt && [[timeArray firstObject] integerValue] < sunsetInt) {
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_weatner_day_%@", model.img]];
            } else {
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_weatner_night_%@", model.img]];
            }
            
            temperatureLabel.text = [NSString stringWithFormat:@"%@º", model.temp];
            
        }
        
        
    }

}


























#pragma mark - 控制器消失，移除观察者
- (void)dealloc {
    
    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];
    
}


@end
