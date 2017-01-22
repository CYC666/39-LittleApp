//
//  AliWeatherController.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/23.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 换了新的天气UI，使用阿里的天气接口

#import <UIKit/UIKit.h>

@interface AliWeatherController : UIViewController


// 需要传入地名   深圳
- (instancetype)initWithCityName:(NSString *)location;

@end
