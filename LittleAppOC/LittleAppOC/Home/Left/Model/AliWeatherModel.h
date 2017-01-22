//
//  AliWeatherModel.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/23.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Ali_AQI_Model;


@interface AliWeatherModel : NSObject

@property (copy, nonatomic) NSString *city;         // 城市
@property (copy, nonatomic) NSString *cityid;       // 城市id
@property (copy, nonatomic) NSString *citycode;     // 城市编码
@property (copy, nonatomic) NSString *date;         // 日期
@property (copy, nonatomic) NSString *week;         // 星期几
@property (copy, nonatomic) NSString *weather;      // 天气描述
@property (copy, nonatomic) NSString *temp;         // 当前温度
@property (copy, nonatomic) NSString *temphigh;     // 最高温
@property (copy, nonatomic) NSString *templow;      // 最低温
@property (copy, nonatomic) NSString *img;          // 天气img
@property (copy, nonatomic) NSString *humidity;     // 湿度
@property (copy, nonatomic) NSString *pressure;     // 气压
@property (copy, nonatomic) NSString *windspeed;    // 风速
@property (copy, nonatomic) NSString *winddirect;   // 风向
@property (copy, nonatomic) NSString *windpower;    // 风力等级
@property (copy, nonatomic) NSString *updatetime;   // 更新时间
@property (strong, nonatomic) Ali_AQI_Model *aqi;   // 空气质量指数
@property (strong, nonatomic) NSArray *dailyArray;  // 未来几天的天气
@property (strong, nonatomic) NSArray *hourlyArray; // 天气时刻表


@end

/*
 
 "status": "0",
 "msg": "ok",
 "result": {
 "city": "深圳",
 "cityid": "76",
 "citycode": "101280601",
 "date": "2017-01-23",
 "week": "星期一",
 "weather": "晴",
 "temp": "13",
 "temphigh": "21",
 "templow": "13",
 "img": "0",
 "humidity": "86",
 "pressure": "1026",
 "windspeed": "0.0",
 "winddirect": "北风",
 "windpower": "1级",
 "updatetime": "2017-01-23 04:35:04",
 "index": [
     {
     "iname": "空调指数",
     "ivalue": "较少开启",
     "detail": "您将感到很舒适，一般不需要开启空调。"
     },
     {
     "iname": "运动指数",
     "ivalue": "较适宜",
     "detail": "天气较好，户外运动请注意防晒。推荐您进行室内运动。"
     },
     {
     "iname": "紫外线指数",
     "ivalue": "中等",
     "detail": "属中等强度紫外线辐射天气，外出时建议涂擦SPF高于15、PA+的防晒护肤品，戴帽子、太阳镜。"
     },
     {
     "iname": "感冒指数",
     "ivalue": "较易发",
     "detail": "天气较凉，较易发生感冒，请适当增加衣服。体质较弱的朋友尤其应该注意防护。"
     },
     {
     "iname": "洗车指数",
     "ivalue": "较适宜",
     "detail": "较适宜洗车，未来一天无雨，风力较小，擦洗一新的汽车至少能保持一天。"
     },
     {
     "iname": "空气污染扩散指数",
     "index": "较差",
     "detail": "气象条件较不利于空气污染物稀释、扩散和清除，请适当减少室外活动时间。"
     },
     {
     "iname": "穿衣指数",
     "ivalue": "较舒适",
     "detail": "建议着薄外套、开衫牛仔衫裤等服装。年老体弱者应适当添加衣物，宜着夹克衫、薄毛衣等。"
     }
 ],
 "aqi": {
 "so2": "7",
 "so224": "9",
 "no2": "43",
 "no224": "35",
 "co": "0.900",
 "co24": "0.820",
 "o3": "56",
 "o38": "62",
 "o324": "69",
 "pm10": "67",
 "pm1024": "64",
 "pm2_5": "50",
 "pm2_524": "48",
 "iso2": "3",
 "ino2": "22",
 "ico": "9",
 "io3": "18",
 "io38": "31",
 "ipm10": "59",
 "ipm2_5": "69",
 "aqi": "69",
 "primarypollutant": "PM2.5",
 "quality": "良",
 "timepoint": "2017-01-23 04:00:00",
 "aqiinfo": {
 "level": "二级",
 "color": "#FFFF00",
 "affect": "空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响",
 "measure": "极少数异常敏感人群应减少户外活动"
 }
 },
 "daily": [
     {
     "date": "2017-01-23",
     "week": "星期一",
     "sunrise": "07:05",
     "sunset": "18:05",
     "night": {
     "weather": "阴",
     "templow": "13",
     "img": "2",
     "winddirect": "无持续风向",
     "windpower": "微风"
     },
     "day": {
     "weather": "晴",
     "temphigh": "21",
     "img": "0",
     "winddirect": "无持续风向",
     "windpower": "微风"
     }
     },
     {
     "date": "2017-01-24",
     "week": "星期二",
     "sunrise": "07:04",
     "sunset": "18:06",
     "night": {
     "weather": "小雨",
     "templow": "15",
     "img": "7",
     "winddirect": "无持续风向",
     "windpower": "微风"
     },
     "day": {
     "weather": "阴",
     "temphigh": "19",
     "img": "2",
     "winddirect": "无持续风向",
     "windpower": "微风"
     }
     },
     {
     "date": "2017-01-25",
     "week": "星期三",
     "sunrise": "07:04",
     "sunset": "18:07",
     "night": {
     "weather": "晴",
     "templow": "15",
     "img": "0",
     "winddirect": "无持续风向",
     "windpower": "微风"
     },
     "day": {
     "weather": "小雨",
     "temphigh": "18",
     "img": "7",
     "winddirect": "无持续风向",
     "windpower": "微风"
     }
     },
     {
     "date": "2017-01-26",
     "week": "星期四",
     "sunrise": "07:04",
     "sunset": "18:07",
     "night": {
     "weather": "多云",
     "templow": "16",
     "img": "1",
     "winddirect": "无持续风向",
     "windpower": "微风"
     },
     "day": {
     "weather": "晴",
     "temphigh": "20",
     "img": "0",
     "winddirect": "无持续风向",
     "windpower": "微风"
     }
     },
     {
     "date": "2017-01-27",
     "week": "星期五",
     "sunrise": "",
     "sunset": "",
     "night": {
     "weather": "多云",
     "templow": "4",
     "img": "1",
     "winddirect": "",
     "windpower": ""
     },
     "day": {
     "weather": "多云",
     "temphigh": "11",
     "img": "1",
     "winddirect": "北风",
     "windpower": "3～4级"
     }
     },
     {
     "date": "2017-01-28",
     "week": "星期六",
     "sunrise": "07:30",
     "sunset": "19:30",
     "night": {
     "weather": "多云",
     "templow": "17",
     "img": "1",
     "winddirect": "东南风",
     "windpower": "微风"
     },
     "day": {
     "weather": "多云",
     "temphigh": "21",
     "img": "1",
     "winddirect": "东南风",
     "windpower": "微风"
     }
     },
     {
     "date": "2017-01-29",
     "week": "星期日",
     "sunrise": "07:30",
     "sunset": "19:30",
     "night": {
     "weather": "多云",
     "templow": "18",
     "img": "1",
     "winddirect": "东南风",
     "windpower": "微风"
     },
     "day": {
     "weather": "多云",
     "temphigh": "24",
     "img": "1",
     "winddirect": "东南风",
     "windpower": "微风"
     }
     },
     {
     "date": "2017-01-30",
     "week": "星期一",
     "sunrise": "",
     "sunset": "",
     "night": {
     "weather": "阴天",
     "templow": "7",
     "img": "2",
     "winddirect": "",
     "windpower": ""
     },
     "day": {
     "weather": "多云",
     "temphigh": "12",
     "img": "1",
     "winddirect": "北风",
     "windpower": "2级"
     }
     },
     {
     "date": "2017-01-31",
     "week": "星期二",
     "sunrise": "",
     "sunset": "",
     "night": {
     "weather": "局部多云",
     "templow": "6",
     "img": "1",
     "winddirect": "",
     "windpower": ""
     },
     "day": {
     "weather": "多云",
     "temphigh": "9",
     "img": "1",
     "winddirect": "东北偏北风",
     "windpower": "3级"
     }
     }
 ],
 "hourly": [
     {
     "time": "5:00",
     "weather": "晴",
     "temp": "13",
     "img": "0"
     },
     {
     "time": "6:00",
     "weather": "晴",
     "temp": "13",
     "img": "0"
     },
     {
     "time": "7:00",
     "weather": "晴",
     "temp": "12",
     "img": "0"
     },
     {
     "time": "8:00",
     "weather": "晴",
     "temp": "13",
     "img": "0"
     },
     {
     "time": "9:00",
     "weather": "晴",
     "temp": "15",
     "img": "0"
     },
     {
     "time": "10:00",
     "weather": "晴",
     "temp": "17",
     "img": "0"
     },
     {
     "time": "11:00",
     "weather": "晴",
     "temp": "18",
     "img": "0"
     },
     {
     "time": "12:00",
     "weather": "晴",
     "temp": "19",
     "img": "0"
     },
     {
     "time": "13:00",
     "weather": "晴",
     "temp": "19",
     "img": "0"
     },
     {
     "time": "14:00",
     "weather": "晴",
     "temp": "20",
     "img": "0"
     },
     {
     "time": "15:00",
     "weather": "晴",
     "temp": "20",
     "img": "0"
     },
     {
     "time": "16:00",
     "weather": "晴",
     "temp": "20",
     "img": "0"
     },
     {
     "time": "17:00",
     "weather": "晴",
     "temp": "19",
     "img": "0"
     },
     {
     "time": "18:00",
     "weather": "晴",
     "temp": "19",
     "img": "0"
     },
     {
     "time": "19:00",
     "weather": "多云",
     "temp": "18",
     "img": "1"
     },
     {
     "time": "20:00",
     "weather": "多云",
     "temp": "17",
     "img": "1"
     },
     {
     "time": "21:00",
     "weather": "多云",
     "temp": "17",
     "img": "1"
     },
     {
     "time": "22:00",
     "weather": "多云",
     "temp": "17",
     "img": "1"
     },
     {
     "time": "23:00",
     "weather": "多云",
     "temp": "17",
     "img": "1"
     },
     {
     "time": "0:00",
     "weather": "多云",
     "temp": "17",
     "img": "1"
     },
     {
     "time": "1:00",
     "weather": "多云",
     "temp": "16",
     "img": "1"
     },
     {
     "time": "2:00",
     "weather": "多云",
     "temp": "16",
     "img": "1"
     },
     {
     "time": "3:00",
     "weather": "多云",
     "temp": "16",
     "img": "1"
     },
     {
     "time": "4:00",
     "weather": "多云",
     "temp": "16",
     "img": "1"
     }
 ]
 }
 
 
 
 */
