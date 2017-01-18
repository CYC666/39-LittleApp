//
//  CYCLeftController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CYCLeftController.h"
#import "CNetWorking.h"
#import "WeatherModel.h"
#import "ThemeManager.h"
#import "CThemeLabel.h"
#import "CThemeButton.h"
#import "CLeftCtrlCell.h"
#import "WeatherController.h"
#import "DailyController.h"
#import <CoreLocation/CoreLocation.h>

#define CYCLeftControllerCellID @"CYCLeftControllerCellID"  // 单元格重用标识符


@interface CYCLeftController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *tableViewTitles;     // 表视图的title
@property (strong, nonatomic) NSArray *tableViewIcons;      // 表视图的icon
@property (strong, nonatomic) CLLocationManager *manager;   // 定位管理员
@property (strong, nonatomic) CThemeLabel *locationLabel;   // 定位标签
@property (strong, nonatomic) UILabel *temperatureLabel;    // 温度标签
@property (strong, nonatomic) UIImageView *weatherImageView;// 显示天气的图
@property (copy, nonatomic) NSString *currentCoor2D;        // 用于查询的经纬度结合体

@end

@implementation CYCLeftController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubviews];
    
    self.view.backgroundColor = CTHEME.themeColor;
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
}


// ------------------------------------------------------UI创建-------------------------------------------------------
#pragma mark - 创建子视图
- (void)creatSubviews {

    // 头部背景图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths firstObject] stringByAppendingString:@"/leftControllerHeadImage.jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image;
    if (imageData == nil) {
        image = [UIImage imageNamed:@"image_leftControllerHeadImage"];
    } else {
        image = [UIImage imageWithData:imageData];
    }
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cLeftControllerWidth, cLeftControllerHeadImageHeight)];
    _headImageView.image = image;
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    [_headImageView addGestureRecognizer:headTap];
    [self.view addSubview:_headImageView];
    
    // 表视图显示功能
    _tableViewTitles = @[@"曹老师",
                         @"第三方",
                         @"功能介绍",
                         @"开发日记"];
    _tableViewIcons = @[@"icon_leftCtrl_user",
                        @"icon_leftCtrl_Third",
                        @"icon_leftCtrl_function",
                        @"icon_leftCtrl_feedBack"];
    _middleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cLeftControllerHeadImageHeight + 15,
                                                                     cLeftControllerWidth, kScreenHeight - cLeftControllerHeadImageHeight - 49 - 15)
                                                    style:UITableViewStylePlain];
    _middleTableView.separatorColor = [UIColor clearColor];
    [_middleTableView registerClass:[CLeftCtrlCell class] forCellReuseIdentifier:CYCLeftControllerCellID];
    _middleTableView.backgroundColor = [UIColor clearColor];
    _middleTableView.delegate = self;
    _middleTableView.dataSource = self;
    [self.view addSubview:_middleTableView];
    
    // 夜间模式开关
    _nightButton = [CThemeButton buttonWithType:UIButtonTypeCustom];
    _nightButton.frame = CGRectMake(10, kScreenHeight - 49, 70, 49);
    _nightButton.titleLabel.font = C_MAIN_FONT(15);
    [_nightButton addTarget:self action:@selector(nightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nightButton];
    

    if (CTHEME.themeType == CDayTheme) {
        [_nightButton setImage:[UIImage imageNamed:@"icon_leftController_day"] forState:UIControlStateNormal];
        [_nightButton setTitle:@" 白天" forState:UIControlStateNormal];
        [_nightButton setTitleColor:C_MAIN_TEXTCOLOR forState:UIControlStateNormal];
    } else  {
        [_nightButton setImage:[UIImage imageNamed:@"icon_leftController_night"] forState:UIControlStateNormal];
        [_nightButton setTitle:@" 夜间" forState:UIControlStateNormal];
        [_nightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    // 地点
    _locationLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(cLeftControllerWidth - 100, kScreenHeight - 49, 50, 49)];
    _locationLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
    _locationLabel.font = C_MAIN_FONT(15);
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.alpha = 0;
    [self.view addSubview:_locationLabel];
    
    // 温度
    _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(cLeftControllerWidth - 50, kScreenHeight - 53, 50, 49)];
    _temperatureLabel.textColor = CRGB(27, 199, 246, 1);
    _temperatureLabel.font = C_MAIN_FONT(30);
    _temperatureLabel.textAlignment = NSTextAlignmentLeft;
    _temperatureLabel.alpha = 0;
    [self.view addSubview:_temperatureLabel];
    
    // 天气图
    _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cLeftControllerWidth - 80, kScreenHeight - 49 - 60, 60, 60)];
    _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    _weatherImageView.alpha = 0;
    _weatherImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *weatherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weatherTapAction:)];
    [_weatherImageView addGestureRecognizer:weatherTap];
    [self.view addSubview:_weatherImageView];

    
    // 定位 -- 天气 -- 设置天气UI
    [self loadLocation];

}

#pragma mark - 设置天气UI
- (void)setWeatherUI:(NSDictionary *)dic {

    WeatherModel *model = [[WeatherModel alloc] init];
    model.locationName = dic[@"location"][@"name"];
    model.weatherText = dic[@"now"][@"text"];
    model.weatherCode = dic[@"now"][@"code"];
    model.temperature = dic[@"now"][@"temperature"];
    
    
    _locationLabel.text = model.locationName;
    _temperatureLabel.text = [NSString stringWithFormat:@"%@º", model.temperature];
    _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", model.weatherCode]];
    [UIView animateWithDuration:.35
                     animations:^{
                         _locationLabel.alpha = 1;
                         _temperatureLabel.alpha = 1;
                         _weatherImageView.alpha = 1;
                     }];
}


// ------------------------------------------------------动作响应区----------------------------------------------------
#pragma mark - 点击了头部的背景图片,更换图片
- (void)headTapAction:(UITapGestureRecognizer *)tap {


}

#pragma mark - 夜间模式按钮响应
- (void)nightButtonAction:(UIButton *)button {

    
    if (CTHEME.themeType == CDayTheme) {
        CTHEME.themeType = CNightTheme;
        [button setImage:[UIImage imageNamed:@"icon_leftController_night"] forState:UIControlStateNormal];
        [button setTitle:@" 夜间" forState:UIControlStateNormal];
    } else {
        CTHEME.themeType = CDayTheme;
        [button setImage:[UIImage imageNamed:@"icon_leftController_day"] forState:UIControlStateNormal];
        [button setTitle:@" 白天" forState:UIControlStateNormal];
    }

}

#pragma mark - 点击了天气的图片
- (void)weatherTapAction:(UITapGestureRecognizer *)tap {

    WeatherController *controller = [[WeatherController alloc] initWithLocation:_currentCoor2D];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {

    self.view.backgroundColor = CTHEME.themeColor;

}





// -----------------------------------------------------代理协议方法-----------------------------------------------------
#pragma mark - 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CLeftCtrlCell *cell = [[CLeftCtrlCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CYCLeftControllerCellID];
    cell.leftCellLabel.text = _tableViewTitles[indexPath.row];
    cell.leftCellImageView.image = [UIImage imageNamed:_tableViewIcons[indexPath.row]];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3) {
        DailyController *controller = [[DailyController alloc] initWithNibName:@"DailyController"
                                                                        bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.navigationBar.translucent = NO;
        nav.navigationBar.barTintColor = [UIColor blackColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    // 点击之后取消高亮状态
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    

}

#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // 当前位置
    CLLocation *currentLocation = locations.firstObject;
    CLLocationCoordinate2D currentCoor2D = currentLocation.coordinate;
    // 停止更新地理位置
    [manager stopUpdatingLocation];
    
    // 获取天气
    [self loadWeather:currentCoor2D];
    
}

// -----------------------------------------------------其他方法-----------------------------------------------------
#pragma mark - 加载地理位置
- (void)loadLocation {

    _manager = [[CLLocationManager alloc] init];
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8) {
        [_manager requestWhenInUseAuthorization];           // 请求定位服务
    }
    _manager.delegate = self;
    [_manager startUpdatingLocation];
    

}

#pragma mark - 加载天气状况
- (void)loadWeather:(CLLocationCoordinate2D)coordinate2D {

    NSString *location = [NSString stringWithFormat:@"%.2f:%.2f", coordinate2D.latitude, coordinate2D.longitude];
    _currentCoor2D = location;
    [CNetWorking loadWeatherWithLocation:location
                                 success:^(id response) {
                                     // 设置UI
                                     if (response[@"results"] != nil) {
                                         NSDictionary *dic = [response[@"results"] firstObject];
                                         [self setWeatherUI:dic];
                                     }
                                 } failure:^(NSError *err) {
                                     
                                 }];

}




















@end
