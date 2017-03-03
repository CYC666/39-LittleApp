//
//  SongViewController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/28.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "SongViewController.h"
#import "SongModel.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#define ImageSize (kScreenWidth - 30*2)



@implementation SongViewController


#pragma mark - 懒加载
- (NSMutableArray *)songList {

    if (_songList == nil) {
        _songList = [NSMutableArray array];
    }
    return _songList;

}

// 背景图+毛玻璃模糊效果
- (UIImageView *)backgroundImage {

    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backgroundImage.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backgroundImage];
        
        // 黑色遮罩
        UIView *balckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        balckView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.view addSubview:balckView];
        
        // 添加毛玻璃模糊
        FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        blurView.blurRadius = 40;
        [self.view addSubview:blurView];
    }
    return _backgroundImage;

}

// 歌名
- (UILabel *)songLabel {

    if (_songLabel == nil) {
        _songLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
        _songLabel.textColor = [UIColor whiteColor];
        _songLabel.font = C_MUSIC_FONT(20);
        _songLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_songLabel];
    }
    return _songLabel;

}

// 歌手名字  @"—— 曹奕程 ——"
- (UILabel *)singerLabel {

    if (_singerLabel == nil) {
        _singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 20)];
        _singerLabel.textColor = [UIColor whiteColor];
        _singerLabel.font = C_MUSIC_FONT(17);
        _singerLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_singerLabel];
    }
    return _singerLabel;

}

// 专辑图片
- (UIImageView *)albumImageView {

    if (_albumImageView == nil) {
        _albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 160, ImageSize, ImageSize)];
        _albumImageView.layer.borderWidth = 8;
        _albumImageView.layer.borderColor = CRGB(92, 85, 84, 1).CGColor;
        [self.view addSubview:_albumImageView];
        
        _albumImageView.userInteractionEnabled = YES;
        
        // 向下隐藏
        UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dismissCurrentView:)];
        downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
        [_albumImageView addGestureRecognizer:downSwipe];
        
        // 向上切歌
        UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(changeSong:)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
        [_albumImageView addGestureRecognizer:upSwipe];
        
    }
    return _albumImageView;

}

- (UIImageView *)dismissImage {

    if (_dismissImage == nil) {
        _dismissImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 160, ImageSize, ImageSize)];
        _dismissImage.layer.borderWidth = 8;
        _dismissImage.layer.borderColor = CRGB(92, 85, 84, 1).CGColor;
        [self.view addSubview:_dismissImage];
    }
    return _dismissImage;

}

// 进度(数字 00:00)
- (UILabel *)liveLabel {

    if (_liveLabel == nil) {
        _liveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140 + ImageSize + 80, 60, 20)];
        _liveLabel.textColor = CRGB(197, 201, 204, 1);
        _liveLabel.font = C_MUSIC_FONT(17);
        _liveLabel.layer.shadowOffset = CGSizeMake(0, 2);
        _liveLabel.layer.shadowColor = CRGB(62, 66, 70, 1).CGColor;
        _liveLabel.layer.shadowRadius = 5;
        _liveLabel.layer.shadowOpacity = 1;
        _liveLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_liveLabel];
    }
    return _liveLabel;

}

// 进度条
- (UISlider *)songSlider {

    if (_songSlider == nil) {
        _songSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, 140 + ImageSize + 80 - 5, kScreenWidth - 60*2, 30)];
        _songSlider.maximumTrackTintColor = CRGB(113, 83, 86, 1);
        _songSlider.minimumTrackTintColor = CRGB(45, 194, 131, 1);
        _songSlider.thumbTintColor = CRGB(45, 194, 131, 1);
        self.songSlider.minimumValue = 0.0;
        self.songSlider.maximumValue = 1.0;
        [self.view addSubview:_songSlider];
        
        // 改变进度
        [_songSlider addTarget:self action:@selector(songSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _songSlider;

}

// 歌曲长度
- (UILabel *)lengLabel {

    if (_lengLabel == nil) {
        _lengLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 140 + ImageSize + 80, 60, 20)];
        _lengLabel.textColor = CRGB(197, 201, 204, 1);
        _lengLabel.font = C_MUSIC_FONT(17);
        _lengLabel.layer.shadowOffset = CGSizeMake(0, 2);
        _lengLabel.layer.shadowColor = CRGB(62, 66, 70, 1).CGColor;
        _lengLabel.layer.shadowRadius = 5;
        _lengLabel.layer.shadowOpacity = 1;
        _lengLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_lengLabel];
    }
    return _lengLabel;

}

// 随机播放按钮
- (UIButton *)happenButton {

    if (_happenButton == nil) {
        _happenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _happenButton.frame = CGRectMake(20, 160 + ImageSize + 120, 30, 30);
        [_happenButton setImage:[UIImage imageNamed:@"music_song_order"] forState:UIControlStateNormal];
        [_happenButton addTarget:self action:@selector(happenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_happenButton];
    }
    return _happenButton;

}

// 上一曲
- (UIButton *)lastButton {

    if (_lastButton == nil) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastButton.frame = CGRectMake((kScreenWidth - 70)/2 - 30 - 50, 160 + ImageSize + 110, 50, 50);
        [_lastButton setImage:[UIImage imageNamed:@"music_song_last"] forState:UIControlStateNormal];
        [_lastButton addTarget:self action:@selector(lastButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_lastButton];
    }
    return _lastButton;

}

// 暂停/播放
- (UIButton *)pauseButton {

    if (_pauseButton == nil) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.frame = CGRectMake((kScreenWidth - 70)/2, 160 + ImageSize + 100, 70, 70);
        [_pauseButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_pauseButton];
    }
    return _pauseButton;

}

// 下一曲
- (UIButton *)nextButton {

    if (_nextButton == nil) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake((kScreenWidth - 70)/2 + 70 +30, 160 + ImageSize + 110, 50, 50);
        [_nextButton setImage:[UIImage imageNamed:@"music_song_next"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;

}

// 歌曲列表
- (UIButton *)listButton {

    if (_listButton == nil) {
        _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _listButton.frame = CGRectMake(kScreenWidth - 20 - 30, 160 + ImageSize + 120, 30, 30);
        [_listButton setImage:[UIImage imageNamed:@"music_song_list"] forState:UIControlStateNormal];
        [_listButton addTarget:self action:@selector(listButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_listButton];
    }
    return _listButton;

}


#pragma mark - 设置index的时候，赋予UI内容，注意UI先后顺序
- (void)setLiveIndex:(NSInteger)liveIndex {

    _liveIndex = liveIndex;
    
    SongModel *liveModel = _songList[liveIndex];
    
    // 开始调用UI
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_big]];
    
    self.songLabel.text = liveModel.songname;
    
    self.singerLabel.text = [NSString stringWithFormat:@"— %@ —", liveModel.singername];
    
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_big]];
    
    self.liveLabel.text = @"00:00";
    
    self.songSlider.value = 0.0;
    
    NSNumber *lengNumber = (NSNumber *)liveModel.seconds;
    self.lengLabel.text = [self secondsToString:lengNumber.integerValue];
    
    self.happenButton.alpha = 1;
    
    self.lastButton.alpha = 1;
    
    [self.pauseButton setImage:[UIImage imageNamed:@"music_song_pause"] forState:UIControlStateNormal];
    
    self.nextButton.alpha = 1;
    
    self.listButton.alpha = 1;
    
    
}


#pragma mark - 按钮响应区
// 调节进度条
- (void)songSliderDidChange:(UISlider *)slider {

    // 把进度传过去
    if ([_delegate respondsToSelector:@selector(songCurrentValueChange:)]) {
        [_delegate songCurrentValueChange:slider.value];
    }
    
}
// 随机按钮
- (void)happenButtonAction:(UIButton *)button {

    if (_songPlayType == SongPlayOrder) {
        
        // 随机播放
        _songPlayType = SongPlayHappen;
        [button setImage:[UIImage imageNamed:@"music_song_happen"] forState:UIControlStateNormal];
        
    } else {
        
        //  顺序播放
        _songPlayType = SongPlayOrder;
        [button setImage:[UIImage imageNamed:@"music_song_order"] forState:UIControlStateNormal];
    }
    
}
// 上一首
- (void)lastButtonAction:(UIButton *)button {
    
    if (_liveIndex != 0) {
        
        // image做了一个向上渐隐的动作(先做动作，不然渐隐的图片来不及)
        [self imageDismissAnimate];
        
        self.liveIndex--;
        if ([_delegate respondsToSelector:@selector(lastSong:)]) {
            [_delegate lastSong:_liveIndex];
        }
        
    }
    
}
// 暂停、播放
- (void)playButtonAction:(UIButton *)button {
    
    if (_songStateType == SongPlay) {
        
        _songStateType = SongPause;
        [_pauseButton setImage:[UIImage imageNamed:@"music_song_play"] forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(pauseSong:)]) {
            [_delegate pauseSong:_songStateType];
        }
        
    } else {
        
        _songStateType = SongPlay;
        [_pauseButton setImage:[UIImage imageNamed:@"music_song_pause"] forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(pauseSong:)]) {
            [_delegate pauseSong:_songStateType];
        }
        
    }
    
    
}
// 下一首
- (void)nextButtonAction:(UIButton *)button {
    
    if (_liveIndex < _songList.count) {
        
        // image做了一个向上渐隐的动作
        [self imageDismissAnimate];
        
        self.liveIndex++;
        if ([_delegate respondsToSelector:@selector(nextSong:)]) {
            [_delegate nextSong:_liveIndex];
        }
        
    }
    
}
// 列表
- (void)listButtonAction:(UIButton *)button {
    
    
    
}

#pragma mark - 向下轻扫中间的图片，退出当前页面
- (void)dismissCurrentView:(UISwipeGestureRecognizer *)swipe {

    [self dismissViewControllerAnimated:YES completion:nil];
    

}

#pragma mark - 向上轻扫切歌
- (void)changeSong:(UISwipeGestureRecognizer *)swipe {

    if (_liveIndex < _songList.count) {
        
        // image做了一个向上渐隐的动作
        [self imageDismissAnimate];
        
        self.liveIndex++;
        if ([_delegate respondsToSelector:@selector(nextSong:)]) {
            [_delegate nextSong:_liveIndex];
        }
        
    }

}


#pragma mark - 将秒转换成 00:00 格式
- (NSString *)secondsToString:(NSInteger)length {

    NSInteger minInt = length / 60;
    NSString *minStr;
    if (minInt < 10) {
        minStr = [NSString stringWithFormat:@"0%ld", minInt];
    } else {
        minStr = [NSString stringWithFormat:@"%ld", minInt];
    }
    
    NSInteger secInt = length % 60;
    NSString *secStr;
    if (secInt < 10) {
        secStr = [NSString stringWithFormat:@"0%ld", secInt];
    } else {
        secStr = [NSString stringWithFormat:@"%ld", secInt];
    }
    
    return [NSString stringWithFormat:@"%@:%@", minStr, secStr];
    

}

#pragma mark - 设置进度
- (void)setCurrentValue:(float)currentValue {

    // 进度条
    _songSlider.value = currentValue;
    
    // 前面的进度label
    SongModel *liveModel = _songList[_liveIndex];
    NSNumber *lengNumber = (NSNumber *)liveModel.seconds;
    NSInteger currentInteger = lengNumber.integerValue * currentValue;
    _liveLabel.text = [self secondsToString:currentInteger];

}

#pragma mark - image做了一个向上渐隐的动作
- (void)imageDismissAnimate {

    // 设置要进行动作的image
    SongModel *liveModel = _songList[_liveIndex];
    [self.dismissImage sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_big]];
    // 复原
    self.dismissImage.transform = CGAffineTransformMakeTranslation(0, 0);
    self.dismissImage.alpha = 1;
    self.dismissImage.frame = CGRectMake(30, 160, ImageSize, ImageSize);
    
    [UIView animateWithDuration:.2
                     animations:^{
                         // 缩小
                         self.dismissImage.frame = CGRectMake(30 + 10, 160 + 10, ImageSize - 20, ImageSize - 20);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.35
                                          animations:^{
                                              // 上移+透明
                                              self.dismissImage.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
                                              self.dismissImage.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              
                                              
                                              
                                          }];
                     }];

}
























@end
