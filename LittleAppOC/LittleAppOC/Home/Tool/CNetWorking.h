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
// 获取某个地点的天气
// 
// location : 地名    (深圳)
//-----------------------------------------------------
+ (void)loadWeatherWithLocation:(NSString *)location
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;


@end
