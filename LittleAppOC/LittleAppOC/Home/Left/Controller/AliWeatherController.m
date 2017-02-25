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

#define AliMainScrollContentHeight kScreenHeight - 120 + (kScreenHeight/2.0 - 120)          // 主滑动视图的内容尺寸
#define AliHourlyStartY (kScreenHeight/2.0 - 120)                                           // 时刻温度表的起点
#define AliHourlyCellWidth 60                                                               // 时刻表的温度单元格宽度
#define AliHourlyHeight 100                                                                 // 时刻表的高度
#define AliDailyCellSatrtY (AliHourlyStartY + AliHourlyHeight)                              // 每日天气的滑动视图起点
#define AliDailyCellHeight (AliMainScrollContentHeight - AliDailyCellSatrtY)                // 每日天气的高度
#define AliTemplowLabelColor CRGB(155, 200, 221, 1)                                         // 最低温的标签颜色


@interface AliWeatherController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) AliWeatherModel *weatherModel;        // 天气model
@property (strong, nonatomic) UIActivityIndicatorView *activityView;// 菊花

@property (strong, nonatomic) UIButton *backButton;             // 返回按钮
@property (strong, nonatomic) UIButton *searchButton;           // 搜索天气按钮
@property (strong, nonatomic) UITextField *searchField;         // 搜索输入框
@property (strong, nonatomic) UILabel *cityNameLabel;           // 城市名
@property (strong, nonatomic) UILabel *weatherLabel;            // 天气
@property (strong, nonatomic) UILabel *tempLabel;               // 当前气温
@property (strong, nonatomic) UILabel *weekLabel;               // 星期几
@property (strong, nonatomic) UILabel *temphighLabel;           // 今天的最高温度
@property (strong, nonatomic) UILabel *templowLabel;            // 今天的最低温度
@property (strong, nonatomic) UIScrollView *mainScrollView;     // 承载时刻气温和未来几天两个滑动视图的主滑动视图
@property (strong, nonatomic) UIView *subTopView;               // 遮在子滑动视图上的视图，用于向上滑动子滑动视图的时候，不让子视图滑动，反而滑动主滑动视图


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
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.view addSubview:_activityView];
    }
    return _activityView;
    
}


// 搜索输入框
- (UITextField *)searchField {

    if (_searchField == nil) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2.0, -30, 200, 30)];
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.backgroundColor = [UIColor clearColor];
        _searchField.textColor = [UIColor whiteColor];
        _searchField.layer.cornerRadius = 15;
        _searchField.layer.borderWidth = 2;
        _searchField.layer.borderColor = [UIColor whiteColor].CGColor;
        _searchField.textAlignment = NSTextAlignmentCenter;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.delegate = self;
        [self.view addSubview:_searchField];
    }
    return _searchField;

}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 20, 60, 60);
    [_backButton setImage:[UIImage imageNamed:@"icon_weather_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    // 搜索按钮
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake((kScreenWidth - 60), 20, 60, 60);
    [_searchButton setImage:[UIImage imageNamed:@"icon_weather_search"] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(searchItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
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

#pragma mark - 搜索按钮
- (void)searchItemAction:(UIButton *)button {
    
    // 显示搜索输入框
    [UIView animateWithDuration:.35
                     animations:^{
                         self.searchField.transform = CGAffineTransformMakeTranslation(0, 65);
                     }];

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
    AQI_model.aqi = data[@"aqi"][@"aqi"];
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
    _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2.0, 80, 200, 40)];
    _cityNameLabel.textAlignment = NSTextAlignmentCenter;
    _cityNameLabel.font = C_MAIN_FONT(35);
    _cityNameLabel.textColor = [UIColor whiteColor];
    _cityNameLabel.text = _weatherModel.city;
    [self.view addSubview:_cityNameLabel];
    
    _weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2.0, 120, 200, 20)];
    _weatherLabel.textAlignment = NSTextAlignmentCenter;
    _weatherLabel.font = C_MAIN_FONT(15);
    _weatherLabel.textColor = [UIColor whiteColor];
    _weatherLabel.text = _weatherModel.weather;
    [self.view addSubview:_weatherLabel];
    
    _tempLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2.0, 150, 100, 80)];
    _tempLabel.textAlignment = NSTextAlignmentCenter;
    _tempLabel.font = [UIFont systemFontOfSize:80];
    _tempLabel.textColor = [UIColor whiteColor];
    _tempLabel.adjustsFontSizeToFitWidth = YES;
    _tempLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.temp];
    [self.view addSubview:_tempLabel];
    // 设置度º
    UILabel *zeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 - 20, 0, 20, 20)];
    zeroLabel.text = @"o";
    zeroLabel.textColor = [UIColor whiteColor];
    zeroLabel.textAlignment = NSTextAlignmentCenter;
    zeroLabel.font = [UIFont systemFontOfSize:20];
    [_tempLabel addSubview:zeroLabel];
    
    
    // 主滑动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, kScreenHeight - 120)];
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, AliMainScrollContentHeight);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    
    // 星期几 今天
    _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, AliHourlyStartY - 25, 100, 20)];
    _weekLabel.textAlignment = NSTextAlignmentLeft;
    _weekLabel.font = C_MAIN_FONT(15);
    _weekLabel.textColor = [UIColor whiteColor];
    _weekLabel.text = [NSString stringWithFormat:@"%@  今天", _weatherModel.week];
    [_mainScrollView addSubview:_weekLabel];
    
    // 今天最高最低温度
    _temphighLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, AliHourlyStartY - 25, 30, 20)];
    _temphighLabel.textAlignment = NSTextAlignmentLeft;
    _temphighLabel.font = C_MAIN_FONT(15);
    _temphighLabel.textColor = [UIColor whiteColor];
    _temphighLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.temphigh];
    [_mainScrollView addSubview:_temphighLabel];
    
    _templowLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, AliHourlyStartY - 25, 30, 20)];
    _templowLabel.textAlignment = NSTextAlignmentRight;
    _templowLabel.font = C_MAIN_FONT(15);
    _templowLabel.textColor = AliTemplowLabelColor;
    _templowLabel.text = [NSString stringWithFormat:@"%@", _weatherModel.templow];
    [_mainScrollView addSubview:_templowLabel];
    
    // 时刻气温表
    UIScrollView *hourlyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, AliHourlyStartY, kScreenWidth, AliHourlyHeight)];
    hourlyScrollView.contentSize = CGSizeMake( AliHourlyCellWidth * (_weatherModel.hourlyArray.count + 1), AliHourlyHeight);
    hourlyScrollView.showsHorizontalScrollIndicator = NO;
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
    
    // 时刻温度表
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
    
    // 承载未来几天天气和其他信息的滑动视图
    UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, AliDailyCellSatrtY,
                                                                                   kScreenWidth, AliMainScrollContentHeight - AliDailyCellSatrtY)];
    subScrollView.contentSize = CGSizeMake(kScreenWidth, 10 + 30*_weatherModel.dailyArray.count + 260 + 10);
    subScrollView.showsVerticalScrollIndicator = NO;
    subScrollView.delegate = self;
    [_mainScrollView addSubview:subScrollView];
    
    // 初始让subTopView跌在子滑动视图之上
    // 遮在子滑动视图上的视图，用于向上滑动子滑动视图的时候，不让子视图滑动，反而滑动主滑动视图
    // frame跟承载其他信息滑动视图的大小一致
    _subTopView = [[UIView alloc] initWithFrame:CGRectMake(0, AliDailyCellSatrtY,
                                                           kScreenWidth, AliMainScrollContentHeight - AliDailyCellSatrtY)];
    _subTopView.backgroundColor = [UIColor clearColor];
    // 放在主滑动视图上
    [_mainScrollView addSubview:_subTopView];
    
    float dailyCellHeight = 10;
    // 未来几天天气
    for (NSInteger i = 0; i < _weatherModel.dailyArray.count; i++) {
        
        AliDailyModel *model = _weatherModel.dailyArray[i];
        
        // 星期几
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + 30*i, 100, 20)];
        week.textAlignment = NSTextAlignmentLeft;
        week.font = C_MAIN_FONT(15);
        week.textColor = [UIColor whiteColor];
        week.text = model.week;
        [subScrollView addSubview:week];
        
        // 云图
        UIImageView *cloud = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 30)/2.0, 10 + 30*i, 25, 25)];
        cloud.contentMode = UIViewContentModeScaleAspectFit;
        cloud.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_weatner_day_%@", model.day_img]];
        [subScrollView addSubview:cloud];
        
        // 最高温
        UILabel *high = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 10 + 30*i, 30, 20)];
        high.textAlignment = NSTextAlignmentLeft;
        high.font = C_MAIN_FONT(15);
        high.textColor = [UIColor whiteColor];
        high.text = model.day_temphigh;
        [subScrollView addSubview:high];

        
        // 最低温
        UILabel *low = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 10 + 30*i, 30, 20)];
        low.textAlignment = NSTextAlignmentRight;
        low.font = C_MAIN_FONT(15);
        low.textColor = AliTemplowLabelColor;
        low.text = model.night_templow;
        [subScrollView addSubview:low];
        
        // 记录每日天气视图的总高度
        dailyCellHeight += 30;
    }
    
    // 上下横线
    CALayer *top = [[CALayer alloc] init];
    top.frame = CGRectMake(0, dailyCellHeight, kScreenWidth, 0.5);
    top.backgroundColor = [UIColor whiteColor].CGColor;
    [subScrollView.layer addSublayer:top];
    CALayer *bottom = [[CALayer alloc] init];
    bottom.frame = CGRectMake(0, dailyCellHeight + 40 - 0.5, kScreenWidth, 0.5);
    bottom.backgroundColor = [UIColor whiteColor].CGColor;
    [subScrollView.layer addSublayer:bottom];
    
    // 今天天气描述
    UILabel *todayDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, dailyCellHeight, kScreenWidth - 15, 40)];
    todayDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    todayDescriptionLabel.font = C_MAIN_FONT(14);
    todayDescriptionLabel.textColor = [UIColor whiteColor];
    todayDescriptionLabel.text = [NSString stringWithFormat:@"今天:当前%@。 气温%@º； 最高气温%@º", _weatherModel.weather, _weatherModel.temp, _weatherModel.temphigh];
    [subScrollView addSubview:todayDescriptionLabel];
    
    // 日出日落（拿每日天气里的第一个）
    UILabel *sunrise = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 40 + 5, kScreenWidth/2.0 - 20, 20)];
    sunrise.textAlignment = NSTextAlignmentRight;
    sunrise.font = C_MAIN_FONT(14);
    sunrise.textColor = [UIColor whiteColor];
    sunrise.text = @"日出:";
    [subScrollView addSubview:sunrise];
    UILabel *sunset = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 60 + 2, kScreenWidth/2.0 - 20, 20)];
    sunset.textAlignment = NSTextAlignmentRight;
    sunset.font = C_MAIN_FONT(14);
    sunset.textColor = [UIColor whiteColor];
    sunset.text = @"日落:";
    [subScrollView addSubview:sunset];
    
    AliDailyModel *model = _weatherModel.dailyArray.firstObject;
    UILabel *sunriseNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 40 + 5, kScreenWidth/2.0, 20)];
    sunriseNum.textAlignment = NSTextAlignmentLeft;
    sunriseNum.font = C_MAIN_FONT(14);
    sunriseNum.textColor = [UIColor whiteColor];
    sunriseNum.text = model.sunrise;
    [subScrollView addSubview:sunriseNum];
    UILabel *sunsetNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 60 + 2, kScreenWidth/2.0, 20)];
    sunsetNum.textAlignment = NSTextAlignmentLeft;
    sunsetNum.font = C_MAIN_FONT(14);
    sunsetNum.textColor = [UIColor whiteColor];
    sunsetNum.text = model.sunset;
    [subScrollView addSubview:sunsetNum];
    
    // 降雨概率和湿度
    UILabel *rain = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 85 + 5, kScreenWidth/2.0 - 20, 20)];
    rain.textAlignment = NSTextAlignmentRight;
    rain.font = C_MAIN_FONT(14);
    rain.textColor = [UIColor whiteColor];
    rain.text = @"降雨概率:";
    [subScrollView addSubview:rain];
    UILabel *humidity = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 105 + 2, kScreenWidth/2.0 - 20, 20)];
    humidity.textAlignment = NSTextAlignmentRight;
    humidity.font = C_MAIN_FONT(14);
    humidity.textColor = [UIColor whiteColor];
    humidity.text = @"湿度:";
    [subScrollView addSubview:humidity];
    
    UILabel *rainNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 85 + 5, kScreenWidth/2.0, 20)];
    rainNum.textAlignment = NSTextAlignmentLeft;
    rainNum.font = C_MAIN_FONT(14);
    rainNum.textColor = [UIColor whiteColor];
    rainNum.text = @"50%-";
    [subScrollView addSubview:rainNum];
    UILabel *humidityNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 105 + 2, kScreenWidth/2.0, 20)];
    humidityNum.textAlignment = NSTextAlignmentLeft;
    humidityNum.font = C_MAIN_FONT(14);
    humidityNum.textColor = [UIColor whiteColor];
    humidityNum.text = [NSString stringWithFormat:@"%@%%", _weatherModel.humidity];
    [subScrollView addSubview:humidityNum];
    
    // 风速风力等级
    UILabel *windspeed = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 130 + 5, kScreenWidth/2.0 - 20, 20)];
    windspeed.textAlignment = NSTextAlignmentRight;
    windspeed.font = C_MAIN_FONT(14);
    windspeed.textColor = [UIColor whiteColor];
    windspeed.text = @"风速:";
    [subScrollView addSubview:windspeed];
    UILabel *windpower = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 150 + 2, kScreenWidth/2.0 - 20, 20)];
    windpower.textAlignment = NSTextAlignmentRight;
    windpower.font = C_MAIN_FONT(14);
    windpower.textColor = [UIColor whiteColor];
    windpower.text = @"风力等级:";
    [subScrollView addSubview:windpower];
    
    UILabel *windspeedNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 130 + 5, kScreenWidth/2.0, 20)];
    windspeedNum.textAlignment = NSTextAlignmentLeft;
    windspeedNum.font = C_MAIN_FONT(14);
    windspeedNum.textColor = [UIColor whiteColor];
    windspeedNum.text = [NSString stringWithFormat:@"%@ 每秒%@米", _weatherModel.winddirect, _weatherModel.windspeed];
    [subScrollView addSubview:windspeedNum];
    UILabel *windpowerNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 150 + 2, kScreenWidth/2.0, 20)];
    windpowerNum.textAlignment = NSTextAlignmentLeft;
    windpowerNum.font = C_MAIN_FONT(14);
    windpowerNum.textColor = [UIColor whiteColor];
    windpowerNum.text = _weatherModel.windpower;
    [subScrollView addSubview:windpowerNum];
    
    // 降水量气压
    UILabel *raining = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 175 + 5, kScreenWidth/2.0 - 20, 20)];
    raining.textAlignment = NSTextAlignmentRight;
    raining.font = C_MAIN_FONT(14);
    raining.textColor = [UIColor whiteColor];
    raining.text = @"降水量:";
    [subScrollView addSubview:raining];
    UILabel *pressure = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 195 + 2, kScreenWidth/2.0 - 20, 20)];
    pressure.textAlignment = NSTextAlignmentRight;
    pressure.font = C_MAIN_FONT(14);
    pressure.textColor = [UIColor whiteColor];
    pressure.text = @"气压:";
    [subScrollView addSubview:pressure];
    
    UILabel *rainingNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 175 + 5, kScreenWidth/2.0, 20)];
    rainingNum.textAlignment = NSTextAlignmentLeft;
    rainingNum.font = C_MAIN_FONT(14);
    rainingNum.textColor = [UIColor whiteColor];
    rainingNum.text = @"50毫米-";
    [subScrollView addSubview:rainingNum];
    UILabel *pressureNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 195 + 2, kScreenWidth/2.0, 20)];
    pressureNum.textAlignment = NSTextAlignmentLeft;
    pressureNum.font = C_MAIN_FONT(14);
    pressureNum.textColor = [UIColor whiteColor];
    pressureNum.text = [NSString stringWithFormat:@"%@百帕", _weatherModel.pressure];
    [subScrollView addSubview:pressureNum];
    
    // 空气质量指数和空气质量
    UILabel *aqi = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 220 + 5, kScreenWidth/2.0 - 20, 20)];
    aqi.textAlignment = NSTextAlignmentRight;
    aqi.font = C_MAIN_FONT(14);
    aqi.textColor = [UIColor whiteColor];
    aqi.text = @"空气质量指数:";
    [subScrollView addSubview:aqi];
    UILabel *quality = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 240 + 2, kScreenWidth/2.0 - 20, 20)];
    quality.textAlignment = NSTextAlignmentRight;
    quality.font = C_MAIN_FONT(14);
    quality.textColor = [UIColor whiteColor];
    quality.text = @"气压:";
    [subScrollView addSubview:quality];
    
    UILabel *aqiNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 220 + 5, kScreenWidth/2.0, 20)];
    aqiNum.textAlignment = NSTextAlignmentLeft;
    aqiNum.font = C_MAIN_FONT(14);
    aqiNum.textColor = [UIColor whiteColor];
    aqiNum.text = _weatherModel.aqi.aqi;
    [subScrollView addSubview:aqiNum];
    UILabel *qualityNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, dailyCellHeight + 240 + 2, kScreenWidth/2.0, 20)];
    qualityNum.textAlignment = NSTextAlignmentLeft;
    qualityNum.font = C_MAIN_FONT(14);
    qualityNum.textColor = [UIColor whiteColor];
    qualityNum.text = _weatherModel.aqi.quality;
    [subScrollView addSubview:qualityNum];
    
    // 空气描述和建议
//    UILabel *affectNum = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 265 + 5, kScreenWidth, 20)];
//    affectNum.textAlignment = NSTextAlignmentCenter;
//    affectNum.font = C_MAIN_FONT(14);
//    affectNum.textColor = [UIColor whiteColor];
//    affectNum.adjustsFontSizeToFitWidth = YES;
//    affectNum.text = _weatherModel.aqi.aqiinfo_affect;
//    [subScrollView addSubview:affectNum];
//    UILabel *measureNum = [[UILabel alloc] initWithFrame:CGRectMake(0, dailyCellHeight + 285 + 2, kScreenWidth, 20)];
//    measureNum.textAlignment = NSTextAlignmentCenter;
//    measureNum.font = C_MAIN_FONT(14);
//    measureNum.textColor = [UIColor whiteColor];
//    measureNum.adjustsFontSizeToFitWidth = YES;
//    measureNum.text = _weatherModel.aqi.aqiinfo_measure;
//    [subScrollView addSubview:measureNum];
    
    
    
    
    
}


#pragma mark - 代理方法
// 滑动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 收回搜索输入框
    if (_searchField != nil) {
        [UIView animateWithDuration:.35
                         animations:^{
                             self.searchField.transform = CGAffineTransformIdentity;
                         }];
    }

    // 根据主滑动视图的位置，设置定位和温度标签的不透明度
    if (scrollView == _mainScrollView) {
        
        if (scrollView.contentOffset.y == AliHourlyStartY) {
            // 隐藏遮罩层
            self.subTopView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        } else {
            // 显示遮罩层
            self.subTopView.transform = CGAffineTransformMakeTranslation(0, 0);
        }
        
        if (scrollView.contentOffset.y >= AliHourlyStartY) {
            // 不能再往上走了
            scrollView.contentOffset = CGPointMake(0, AliHourlyStartY);
        } else if (scrollView.contentOffset.y <= 0) {
            // 往下拉还是可以的，但是不改变定位等标签的属性
        } else {
            // 这个区域内，改变定位等标签的属性
            _cityNameLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
            _weatherLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
            _tempLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
            _tempLabel.alpha = ((AliHourlyStartY - 60) - scrollView.contentOffset.y) / (AliHourlyStartY - 60);
            _weekLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
            _temphighLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
            _templowLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
        }
    }

}

// 当结束拖拽，判断是否在定位等标签可变的区间，如果是，那么修手动改偏移
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView == _mainScrollView) {
        
        if (scrollView.contentOffset.y <= 40 && scrollView.contentOffset.y > 0) {
            [UIView animateWithDuration:.35
                             animations:^{
                                 // 不足以隐藏温度标签
                                 _mainScrollView.contentOffset = CGPointMake(0, 0);
                                 _cityNameLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _weatherLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.alpha = ((AliHourlyStartY - 60) - scrollView.contentOffset.y) / (AliHourlyStartY - 60);
                                 _weekLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _temphighLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _templowLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 
                             }];
            
        } else if (scrollView.contentOffset.y > 40 && scrollView.contentOffset.y < AliHourlyStartY) {
            [UIView animateWithDuration:.35
                             animations:^{
                                 // 应该隐藏温度标签了
                                 _mainScrollView.contentOffset = CGPointMake(0, AliHourlyStartY);
                                 _cityNameLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _weatherLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.alpha = ((AliHourlyStartY - 60) - scrollView.contentOffset.y) / (AliHourlyStartY - 60);
                                 _weekLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _temphighLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _templowLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 
                             }];
            
        }
        
    }

}

// 当减速完毕，判断是否在定位等标签可变的区间，如果是，那么修手动改偏移
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _mainScrollView) {
        
        if (scrollView.contentOffset.y <= 40 && scrollView.contentOffset.y > 0) {
            [UIView animateWithDuration:.35
                             animations:^{
                                 // 不足以隐藏温度标签
                                 _mainScrollView.contentOffset = CGPointMake(0, 0);
                                 _cityNameLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _weatherLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.alpha = ((AliHourlyStartY - 60) - scrollView.contentOffset.y) / (AliHourlyStartY - 60);
                                 _weekLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _temphighLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _templowLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 
                             }];
            
        } else if (scrollView.contentOffset.y > 40 && scrollView.contentOffset.y < AliHourlyStartY) {
            [UIView animateWithDuration:.35
                             animations:^{
                                 // 应该隐藏温度标签了
                                 _mainScrollView.contentOffset = CGPointMake(0, AliHourlyStartY);
                                 _cityNameLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _weatherLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.transform = CGAffineTransformMakeTranslation(0, -(60.0 / AliHourlyStartY) * scrollView.contentOffset.y);
                                 _tempLabel.alpha = ((AliHourlyStartY - 60) - scrollView.contentOffset.y) / (AliHourlyStartY - 60);
                                 _weekLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _temphighLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 _templowLabel.alpha = ((AliHourlyStartY - 80) - scrollView.contentOffset.y) / (AliHourlyStartY - 80);
                                 
                             }];
            
        }
        
    }
    
}

// 按下搜索return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    if (textField == _searchField) {
        
        // 开始搜索天气
        [self.activityView startAnimating];
        __weak typeof(self) weakSelf = self;
        [CNetWorking loadComingDayWeatherWithLocation:textField.text
                                              success:^(id response) {
                                                  //  处理数据
                                                  if ([response[@"msg"] isEqualToString:@"ok"]) {
                                                      [UIView animateWithDuration:.35
                                                                       animations:^{
                                                                           weakSelf.searchField.transform = CGAffineTransformIdentity;
                                                                       }];
                                                      // 移除原有UI
                                                      [_tempLabel removeFromSuperview];
                                                      [_weatherLabel removeFromSuperview];
                                                      [_cityNameLabel removeFromSuperview];
                                                      [_mainScrollView removeFromSuperview];
                                                      
                                                      // 重新创建UI
                                                      NSDictionary *data = response[@"result"];
                                                      [weakSelf loadData:data];
                                                  }
                                                  [weakSelf.activityView stopAnimating];
                                              } failure:^(NSError *err) {
                                                  [UIView animateWithDuration:.35
                                                                   animations:^{
                                                                       weakSelf.searchField.transform = CGAffineTransformIdentity;
                                                                   }];
                                                  [weakSelf.activityView stopAnimating];
                                              }];
        
    }
    
    return YES;

}


//#pragma mark - 观察者响应
//- (void)addObserver:(NSObject *)observer toObjectsAtIndexes:(NSIndexSet *)indexes forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
//
//    if ([keyPath isEqualToString:@"contentOffset"]) {
//        float y = _mainScrollView.contentOffset.y;
//        if (y == AliHourlyStartY) {
//            self.subTopView.alpha = 0;
//        } else {
//            self.subTopView.alpha = 1;
//        }
//    }
//
//}

















#pragma mark - 控制器消失，移除观察者
- (void)dealloc {
    
    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];
    // [_subTopView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
}


@end
