//
//  WeatherModel.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//
// 知心天气的model

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (copy, nonatomic) NSString *locationName;
@property (copy, nonatomic) NSString *weatherText;
@property (copy, nonatomic) NSString *weatherCode;
@property (copy, nonatomic) NSString *temperature;

// 未来几天的天气里增加了内容
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *text_day;
@property (copy, nonatomic) NSString *code_day;
@property (copy, nonatomic) NSString *text_night;
@property (copy, nonatomic) NSString *code_night;
@property (copy, nonatomic) NSString *high;
@property (copy, nonatomic) NSString *low;
@property (copy, nonatomic) NSString *precip;
@property (copy, nonatomic) NSString *wind_direction;
@property (copy, nonatomic) NSString *wind_direction_degree;
@property (copy, nonatomic) NSString *wind_speed;
@property (copy, nonatomic) NSString *wind_scale;




@end


/*
 
 "results": [
     {
         "location": {
             "id": "WS10730EM8EV",
             "name": "深圳",
             "country": "CN",
             "path": "深圳,深圳,广东,中国",
             "timezone": "Asia/Shanghai",
             "timezone_offset": "+08:00"
         },
         "now": {
             "text": "多云",
             "code": "4",
             "temperature": "19"
         },
         "last_update": "2017-01-17T16:20:00+08:00"
     }
 ]
 
 */

/*
 
 "daily": [{                         //返回指定days天数的结果
     "date": "2015-09-20",             //日期
     "text_day": "多云",               //白天天气现象文字
     "code_day": "4",                  //白天天气现象代码
     "text_night": "晴",               //晚间天气现象文字
     "code_night": "0",                //晚间天气现象代码
     "high": "26",                     //当天最高温度
     "low": "17",                      //当天最低温度
     "precip": "0",                    //降水概率，范围0~100，单位百分比
     "wind_direction": "",             //风向文字
     "wind_direction_degree": "255",   //风向角度，范围0~360
     "wind_speed": "9.66",             //风速，单位km/h（当unit=c时）、mph（当unit=f时）
     "wind_scale": ""                  //风力等级
 }]
 */
