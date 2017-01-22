//
//  CNetWorking.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CNetWorking : NSObject

//-----------------------------------------------------
// 获取某个地点的天气    (知心天气)
// 
// location : 经纬度的拼接    (lat:lon)
//-----------------------------------------------------
+ (void)loadWeatherWithLocation:(NSString *)location
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;

//-----------------------------------------------------
// 获取某个地点未来几天的天气    (阿里云)
//
// location : 地名    (深圳)
//-----------------------------------------------------
+ (void)loadComingDayWeatherWithLocation:(NSString *)location
                                 success:(void (^)(id response))success
                                 failure:(void (^)(NSError *err))failure;






































@end
