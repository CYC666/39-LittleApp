//
//  CNetWorking.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/17.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CNetWorking.h"
#import "AFNetworking.h"

@implementation CNetWorking

+ (void)loadWeatherWithLocation:(NSString *)location
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure{

    NSString *urlStr = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/now.json?key=eukjfvabkmt88bww&location=%@&language=zh-Hans&unit=c", location];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}





@end
