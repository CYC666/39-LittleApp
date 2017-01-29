//
//  Ali_AQI_Model.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/23.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 空气质量指数

#import <Foundation/Foundation.h>

@interface Ali_AQI_Model : NSObject

@property (copy, nonatomic) NSString *aqi;                  // PM值
@property (copy, nonatomic) NSString *primarypollutant;     // PM值
@property (copy, nonatomic) NSString *quality;              // 质量等级
@property (copy, nonatomic) NSString *aqiinfo_affect;       // 描述
@property (copy, nonatomic) NSString *aqiinfo_measure;      // 建议


@end
