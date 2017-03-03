//
//  SongModel.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

// QQ音乐排行榜每个音乐的model



#import <Foundation/Foundation.h>

@interface SongModel : NSObject


@property (copy, nonatomic) NSString *songname;         // 歌名
@property (assign, nonatomic) NSValue *seconds;         // 歌曲时长
@property (copy, nonatomic) NSString *albummid;         // 所属专辑
@property (assign, nonatomic) NSValue *songid;          // 歌曲ID
@property (assign, nonatomic) NSValue *singerid;        // 歌手ID
@property (copy, nonatomic) NSString *albumpic_big;     // 专辑大图
@property (copy, nonatomic) NSString *albumpic_small;   // 专辑小图
@property (copy, nonatomic) NSString *downUrl;          // 下载链接
@property (copy, nonatomic) NSString *url;              // 歌曲链接
@property (copy, nonatomic) NSString *singername;       // 歌手名字
@property (assign, nonatomic) NSValue *albumid;         // 专辑ID

@property (copy, nonatomic) NSString *number;           // 排名



@end
