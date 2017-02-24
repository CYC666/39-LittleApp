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

    // 知心天气
    NSString *urlStr = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/now.json?key=eukjfvabkmt88bww&location=%@&language=zh-Hans&unit=c", location];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    


}

+ (void)loadComingDayWeatherWithLocation:(NSString *)location
                                 success:(void (^)(id response))success
                                 failure:(void (^)(NSError *err))failure {
    
    // 阿里云
    NSString *urlStr = [NSString stringWithFormat:@"http://jisutianqi.market.alicloudapi.com/weather/query"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"city" : location};
    NSString *appcode = @"0c9b5b03701a473c833deaeef4ca46d5";
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"APPCODE %@", appcode] forHTTPHeaderField:@"Authorization"];
    [manager GET:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

+ (void)loadMusicRankWithTopid:(NSString *)topid
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {

    NSString *urlStr = [NSString stringWithFormat:@"http://ali-qqmusic.showapi.com/top"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"topid" : topid};
    NSString *appcode = @"0c9b5b03701a473c833deaeef4ca46d5";
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"APPCODE %@", appcode] forHTTPHeaderField:@"Authorization"];
    [manager GET:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}





































/*

 已丢弃
 

*/


@end
