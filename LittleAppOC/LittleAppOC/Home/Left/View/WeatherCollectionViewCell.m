//
//  WeatherCollectionViewCell.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/18.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "CThemeLabel.h"
#import "ThemeManager.h"
#import "WeatherModel.h"


#define WeatherCellWidth kScreenWidth * 0.7
#define WeatherCellHeight kScreenWidth * 0.7 * 0.75

@interface WeatherCollectionViewCell ()

@property (strong, nonatomic) CThemeLabel *dateLabel;
@property (strong, nonatomic) CThemeLabel *text_dayLabel;
@property (strong, nonatomic) CThemeLabel *temperatureLabel;
@property (strong, nonatomic) CThemeLabel *precipLabel;
@property (strong, nonatomic) CThemeLabel *wind_directionLabel;
@property (strong, nonatomic) CThemeLabel *wind_speedLabel;
@property (strong, nonatomic) CThemeLabel *wind_scaleLabel;



@end


@implementation WeatherCollectionViewCell



#pragma mark - 懒加载
- (CThemeLabel *)dateLabel {

    if (_dateLabel == nil) {
        _dateLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 0, WeatherCellWidth, 30)];
        _dateLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;

}
- (CThemeLabel *)text_dayLabel {
    
    if (_text_dayLabel == nil) {
        _text_dayLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 35, WeatherCellWidth, 30)];
        _text_dayLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _text_dayLabel.textAlignment = NSTextAlignmentCenter;
        _text_dayLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_text_dayLabel];
    }
    return _text_dayLabel;
    
}

- (CThemeLabel *)temperatureLabel {
    
    if (_temperatureLabel == nil) {
        _temperatureLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 70, WeatherCellWidth, 30)];
        _temperatureLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_temperatureLabel];
    }
    return _temperatureLabel;
    
}

- (CThemeLabel *)wind_speedLabel {
    
    if (_wind_speedLabel == nil) {
        _wind_speedLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 105, WeatherCellWidth, 30)];
        _wind_speedLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _wind_speedLabel.textAlignment = NSTextAlignmentCenter;
        _wind_speedLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_wind_speedLabel];
    }
    return _wind_speedLabel;
    
}

- (CThemeLabel *)wind_scaleLabel {
    
    if (_wind_scaleLabel == nil) {
        _wind_scaleLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 140, WeatherCellWidth, 30)];
        _wind_scaleLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _wind_scaleLabel.textAlignment = NSTextAlignmentCenter;
        _wind_scaleLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_wind_scaleLabel];
    }
    return _wind_scaleLabel;
    
}

- (CThemeLabel *)precipLabel {
    
    if (_precipLabel == nil) {
        _precipLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 175, WeatherCellWidth, 30)];
        _precipLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _precipLabel.textAlignment = NSTextAlignmentCenter;
        _precipLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_precipLabel];
    }
    return _precipLabel;
    
}

- (CThemeLabel *)wind_directionLabel {
    
    if (_wind_directionLabel == nil) {
        _wind_directionLabel = [[CThemeLabel alloc] initWithFrame:CGRectMake(0, 210, WeatherCellWidth, 30)];
        _wind_directionLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
        _wind_directionLabel.textAlignment = NSTextAlignmentCenter;
        _wind_directionLabel.font = C_MAIN_FONT(20);
        [self.contentView addSubview:_wind_directionLabel];
    }
    return _wind_directionLabel;
    
}





#pragma mark - 创建子视图
- (void)setWeatherModel:(WeatherModel *)weatherModel {

    _weatherModel = weatherModel;
    
    self.dateLabel.text = _weatherModel.date;
    self.text_dayLabel.text = [NSString stringWithFormat:@"天气: %@", _weatherModel.text_day];
    self.temperatureLabel.text = [NSString stringWithFormat:@"温度: %@º~%@º", _weatherModel.low, _weatherModel.high];
    // self.precipLabel.text = [NSString stringWithFormat:@"降雨概率: %@", _weatherModel.precip];
    // self.wind_directionLabel.text = [NSString stringWithFormat:@"风: %@", _weatherModel.wind_direction_degree];
    self.wind_speedLabel.text = [NSString stringWithFormat:@"风速: %@m/s", _weatherModel.wind_speed];
    self.wind_scaleLabel.text = [NSString stringWithFormat:@"风力等级: %@", _weatherModel.wind_scale];

}




































@end
