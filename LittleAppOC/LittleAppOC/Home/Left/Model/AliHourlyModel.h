//
//  AliHourlyModel.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/23.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 阿里时刻天气

#import <Foundation/Foundation.h>

@interface AliHourlyModel : NSObject

@property (copy, nonatomic) NSString *time;     // 时刻
@property (copy, nonatomic) NSString *weather;  // 天气
@property (copy, nonatomic) NSString *temp;     // 温度
@property (copy, nonatomic) NSString *img;      // 天气img



@end
