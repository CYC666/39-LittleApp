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
#import "CThemeLabel.h"
#import "CThemeButton.h"
#import "WeatherCellFlowLayout.h"
#import "WeatherCollectionView.h"

@interface WeatherController ()

@property (copy, nonatomic) NSString *locationID;                   // 城市的ID
@property (copy, nonatomic) NSString *locationName;                 // 城市名
@property (copy, nonatomic) NSString *locationtimezone;             // 城市的时区
@property (strong, nonatomic) NSMutableArray *weatherArray;         // 储存天气的model

@property (strong, nonatomic) UIImageView *weatherImageView;        // 显示天气的图像
@property (strong, nonatomic) WeatherCollectionView *collectionView;// 三天天气集合视图

@property (strong, nonatomic) UIActivityIndicatorView *activityView;// 菊花

@end

@implementation WeatherController

// location ---> @"lat:lon"
- (instancetype)initWithLocation:(NSString *)location {

    if (self = [super init]) {
        
        [self.activityView startAnimating];
        __weak typeof(self) weakSelf = self;
        // 请求数据
        [CNetWorking loadComingDayWeatherWithLocation:location
                                              success:^(id response) {
                                                  if (response[@"results"] != nil) {
                                                      [self loadWeatherData:[response[@"results"] firstObject]];
                                                  }
                                              } failure:^(NSError *err) {
                                                  [weakSelf.activityView stopAnimating];
                                              }];
        
    }
    return self;

}

- (UIActivityIndicatorView *)activityView {

    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)/2.0, (kScreenHeight - 64 - 50)/2.0, 50, 50)];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityView];
    }
    return _activityView;

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
    
    // 跳转处理UI
    [self creatSubviews];

}

#pragma mark - 返回按钮响应
- (void)backItemAction:(UIBarButtonItem *)item {

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - 导航栏搜索按钮
- (void)searchItemAction:(UIBarButtonItem *)item {
    
    
    
}

#pragma mark - 创建子视图
- (void)creatSubviews {
    
    [self.activityView stopAnimating];

    // 定位图标
    UIImageView *weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    weatherIcon.image = [UIImage imageNamed:@"icon_weatherController_location"];
    weatherIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:weatherIcon];
    
    // 定位标签
    CThemeLabel *locationLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(55, 20, 50, 30)];
    locationLabel.text = _locationName;
    locationLabel.font = C_MAIN_FONT(19);
    locationLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
    [self.view addSubview:locationLabel];
    
    // 天气图
    _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2.0, 60, 100, 100)];
    _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_weatherImageView];
    WeatherModel *model = _weatherArray.firstObject;
    UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"new_%@.png", model.code_day]];
    if (weatherImage != nil) {
        _weatherImageView.image = weatherImage;
    } else {
        _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", model.code_day]];
    }
    
    
    // 显示三天天气的集合视图
    WeatherCellFlowLayout *flowLayout = [[WeatherCellFlowLayout alloc] init];
    _collectionView = [[WeatherCollectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - kScreenWidth, kScreenWidth, kScreenWidth)
                                              collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.weatherArray = _weatherArray;
    
    // 监听天气单元格是否改变
    [CNOTIFY addObserver:self selector:@selector(weatherCellChangeNotification:) name:CWeatherCellChangeNotification object:nil];

}

#pragma mark - 换了另一天的天气，天气的图片改变
- (void)weatherCellChangeNotification:(NSNotification *)notification {

    WeatherModel *model = _weatherArray[_collectionView.currentPage];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         weakSelf.weatherImageView.alpha = 0;
                     } completion:^(BOOL finished) {
                         UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"new_%@.png", model.code_day]];
                         if (weatherImage != nil) {
                             weakSelf.weatherImageView.image = weatherImage;
                         } else {
                             weakSelf.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", model.code_day]];
                         }
                         [UIView animateWithDuration:.35
                                          animations:^{
                                              _weatherImageView.alpha = 1;
                                          }];
                     }];
    

}



#pragma mark - 移除观察者
- (void)dealloc {

    [CNOTIFY removeObserver:self name:CThemeChangeNotification object:nil];
    [CNOTIFY removeObserver:self name:CWeatherCellChangeNotification object:nil];

}































@end
