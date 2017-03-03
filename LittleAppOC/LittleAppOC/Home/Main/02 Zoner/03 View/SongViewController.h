//
//  SongViewController.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/28.
//  Copyright © 2017年 CYC. All rights reserved.
//

// 显示正在播放的歌

#import <UIKit/UIKit.h>
@class AVPlayer;


typedef enum : NSUInteger {
    SongPlay,
    SongPause
} SongStateType;

typedef enum : NSUInteger {
    SongPlayOrder,
    SongPlayHappen
} SongPlayType;

@protocol SongViewControllerDelegate <NSObject>

@required
// 当调节进度时，把进度传过去
- (void)songCurrentValueChange:(float)time;
// 上一首
- (void)lastSong:(NSInteger)index;
// 暂停、播放
- (void)pauseSong:(SongStateType)type;
// 下一首
- (void)nextSong:(NSInteger)index;


@end

@interface SongViewController : UIViewController

@property (assign, nonatomic) NSInteger liveIndex;          // 正在播放的歌的位置
@property (assign, nonatomic) float currentValue;           // 当前进度
@property (strong, nonatomic) NSMutableArray *songList;     // 歌曲列表
@property (assign, nonatomic) SongStateType songStateType;  // 歌曲状态
@property (assign, nonatomic) SongPlayType songPlayType;    // 播放类型(顺序、随机)
@property (weak, nonatomic) id<SongViewControllerDelegate> delegate;

// UI
@property (strong, nonatomic) UIImageView *backgroundImage; // 背景图+毛玻璃模糊效果
@property (strong, nonatomic) UILabel *songLabel;           // 歌名
@property (strong, nonatomic) UILabel *singerLabel;         // 歌手名字  @"—— 曹奕程 ——"
@property (strong, nonatomic) UIImageView *albumImageView;  // 专辑图片
@property (strong, nonatomic) UIImageView *dismissImage;    // 切歌时image向上渐隐的动作
@property (strong, nonatomic) UILabel *liveLabel;           // 进度(数字)  @"00:23"
@property (strong, nonatomic) UISlider *songSlider;         // 进度条
@property (strong, nonatomic) UILabel *lengLabel;           // 歌曲长度
@property (strong, nonatomic) UIButton *happenButton;       // 随机播放按钮
@property (strong, nonatomic) UIButton *lastButton;         // 上一曲
@property (strong, nonatomic) UIButton *pauseButton;        // 暂停/播放
@property (strong, nonatomic) UIButton *nextButton;         // 下一曲
@property (strong, nonatomic) UIButton *listButton;         // 歌曲列表



@end
