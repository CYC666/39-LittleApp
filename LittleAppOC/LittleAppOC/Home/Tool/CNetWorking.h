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

//-----------------------------------------------------
// 获取QQ音乐排行榜数据
//
// topid : 排行榜id    (3=欧美 5=内地 6=港台 16=韩国 17=日本 18=民谣 19=摇滚 23=销量 26=热歌)
//-----------------------------------------------------
+ (void)loadMusicRankWithTopid:(NSString *)topid
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;


//-----------------------------------------------------
// 根据关键字搜索歌曲
//
// word : 关键字
// page : 第几页
//
// 默认返回第一页数据，共有20条歌曲信息
//-----------------------------------------------------
+ (void)loadMusicWithSearchWord:(NSString *)word
                           page:(NSString *)page
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;





































@end
