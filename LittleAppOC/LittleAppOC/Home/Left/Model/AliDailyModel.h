//
//  AliDailyModel.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/23.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 未来几天天气

#import <Foundation/Foundation.h>

@interface AliDailyModel : NSObject

@property (copy, nonatomic) NSString *date;             // 日期
@property (copy, nonatomic) NSString *week;             // 星期几
@property (copy, nonatomic) NSString *sunrise;          // 日出时间
@property (copy, nonatomic) NSString *sunset;           // 日落时间

@property (copy, nonatomic) NSString *night_weather;    // 夜间天气
@property (copy, nonatomic) NSString *night_templow;    // 夜间   最低温
@property (copy, nonatomic) NSString *night_img;        // 夜间天气img
@property (copy, nonatomic) NSString *night_winddirect; // 夜间风向
@property (copy, nonatomic) NSString *night_windpower;  // 夜间风力

@property (copy, nonatomic) NSString *day_weather;      // 白天天气
@property (copy, nonatomic) NSString *day_temphigh;     // 白天   最高温
@property (copy, nonatomic) NSString *day_img;          // 白天天气img
@property (copy, nonatomic) NSString *day_winddirect;   // 白天风向
@property (copy, nonatomic) NSString *day_windpower;    // 白天风力

@end
