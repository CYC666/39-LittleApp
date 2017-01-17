//
//  WeatherModel.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (copy, nonatomic) NSString *locationName;
@property (copy, nonatomic) NSString *weatherText;
@property (copy, nonatomic) NSString *weatherCode;
@property (copy, nonatomic) NSString *temperature;




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
