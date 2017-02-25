//
//  SongCell.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongModel, CThemeLabel;

@interface SongCell : UITableViewCell

@property (strong, nonatomic) SongModel *songModel;                 // 歌曲数据

@property (weak, nonatomic) IBOutlet UILabel *number;               // 排名
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;   // 专辑图片
@property (weak, nonatomic) IBOutlet CThemeLabel *songNameLabel;    // 歌名
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;      // 歌手名字
@property (weak, nonatomic) IBOutlet UIView *isLive;                // 正在播放



@end
