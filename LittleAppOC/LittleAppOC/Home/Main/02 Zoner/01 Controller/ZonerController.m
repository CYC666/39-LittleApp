//
//  ZonerController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

// QQ音乐排行榜

#import "ZonerController.h"
#import "ThemeManager.h"
#import "CNetWorking.h"
#import "SongModel.h"
#import "MJRefresh.h"
#import "SongCell.h"
#import "MenuController.h"
#import "SongViewController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>


#define SongListTableViewID @"SongListTableViewID"  // 表视图单元格重用标识符

@interface ZonerController () <UITableViewDelegate, UITableViewDataSource,
                            MenuControllerDelegate, SongViewControllerDelegate>

@property (strong, nonatomic) AVPlayer *mp3Player;                  // 播放mp3
@property (strong, nonatomic) UIImageView *songImageView;           // 点击播放音乐之后，显示在导航栏左边的图片
@property (strong, nonatomic) NSTimer *mainTimer;                   // 监听进度的定时器
@property (strong, nonatomic) NSMutableArray *tableViewDataArray;   // 用于表视图显示的数组
@property (strong, nonatomic) SongViewController *songView;         // 播放详情页

@end

@implementation ZonerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 独立的方法去做导航栏标题的设置
    [self setNavigationBarTitle];
    

    
    // 导航栏右边的类别按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"music_menu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(rightItemAction:)];

    // 搜索按钮
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"music_search"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(searchItemAction:)];
    [self.navigationItem setRightBarButtonItems:@[rightItem, searchItem]];
    
    
    self.view.backgroundColor = CTHEME.themeColor;
    
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
    
    // 检测本地的数据是否已经到了更新时间（间隔一天）
    BOOL toReload = [self isNecessaryToReloadData];
    
    // 查看上一次浏览的排行榜是哪个一个
    NSString *topid = [self getTopid];
    
    if (toReload) {
        
        // 前往更新
        
        // 网络请求排行榜数据(返回的数据中有updatetime，可以根据这个来决定是否要更新)
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self loadNetDataWithTopid:topid];
            
        });
        
    } else {
        
        // 加载本地数据
        NSString *key = [NSString stringWithFormat:@"%@%@", CMusic_Top_, topid];
        NSArray *songlist = [CUSER objectForKey:key];
        // 处理数据
        [self loadMusicModel:songlist];
        
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)songArray {

    if (_songArray == nil) {
        _songArray = [NSMutableArray array];
    }
    return _songArray;

}
- (NSMutableArray *)tableViewDataArray {

    if (_tableViewDataArray == nil) {
        _tableViewDataArray = [NSMutableArray array];
    }
    return _tableViewDataArray;

}



- (UITableView *)songListTableView {

    if (_songListTableView == nil) {
        _songListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)
                                                          style:UITableViewStylePlain];
        _songListTableView.backgroundColor = [UIColor clearColor];
        [_songListTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _songListTableView.delegate = self;
        _songListTableView.dataSource = self;
        [_songListTableView registerNib:[UINib nibWithNibName:@"SongCell" bundle:[NSBundle mainBundle]]
                 forCellReuseIdentifier:SongListTableViewID];
        [self.view addSubview:_songListTableView];
        
        // 下拉刷新控件
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        [refresh addTarget:self action:@selector(updateData) forControlEvents:UIControlEventValueChanged];
        _songListTableView.refreshControl = refresh;
        
    }
    return _songListTableView;

}
- (MJRefreshAutoGifFooter *)footer {

    if (_footer == nil) {
        _footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _footer.refreshingTitleHidden = YES;
        _footer.stateLabel.hidden = YES;
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:20];
        for (int i = 1; i < 21; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pull_image_%d", i]];
            [images addObject:image];
        }
        [_footer setImages:images forState:MJRefreshStateRefreshing];
        [_footer setImages:@[images[0]] forState:MJRefreshStateIdle];
        
    }
    return _footer;

}


#pragma mark - 设置导航栏
- (void)setNavigationBarTitle {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    NSString *topid = [self getTopid];
    if ([topid isEqualToString:@"3"]) {
        title.text = @"排行榜(欧美)";
    } else if ([topid isEqualToString:@"5"]) {
        title.text = @"排行榜(内地)";
    } else if ([topid isEqualToString:@"6"]) {
        title.text = @"排行榜(港台)";
    } else if ([topid isEqualToString:@"16"]) {
        title.text = @"排行榜(韩国)";
    } else if ([topid isEqualToString:@"17"]) {
        title.text = @"排行榜(日本)";
    } else if ([topid isEqualToString:@"18"]) {
        title.text = @"排行榜(民谣)";
    } else if ([topid isEqualToString:@"19"]) {
        title.text = @"排行榜(摇滚)";
    } else if ([topid isEqualToString:@"23"]) {
        title.text = @"排行榜(销量)";
    } else if ([topid isEqualToString:@"26"]) {
        title.text = @"排行榜(热歌)";
    } else {
        title.text = @"排行榜";
    }

    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    
    


}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    
    
}

#pragma mark - 导航栏的响应
// 搜索按钮
- (void)searchItemAction:(UIBarButtonItem *)item {

    // 弹出搜索框

}

// 类别
- (void)rightItemAction:(UIBarButtonItem *)item {
    
    MenuController *menu = [[MenuController alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                           Topid:[self getTopid]];
    menu.delegate = self;
    menu.alpha = 0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
    
    [UIView animateWithDuration:.35 animations:^{
        menu.alpha = 1;
    }];
    
}

#pragma mark - 菜单按钮控制器选中某个类别之后响应的代理方法
- (void)didSelectMenuController:(MenuController *)menuController {

    NSString *topid = menuController.selectTopid;
    
    // 根据ID获取排行榜数据
    [self changeRankWithTopid:topid];
    
}

#pragma mark - 更换排行榜
- (void)changeRankWithTopid:(NSString *)topid {

    // 查看本地是否有数据
    NSString *key = [NSString stringWithFormat:@"%@%@", CMusic_Top_, topid];
    NSArray *musicArray = [CUSER objectForKey:key];
    
    if (musicArray == nil) {
        // 如果没有数据，那么加载
        [self loadNetDataWithTopid:topid];
        
    } else {
        // 如果有数据，判断是否要更新
        BOOL toReload = [self isNecessaryToReloadData];
        if (toReload) {
            // 加载更新数据
            [self loadNetDataWithTopid:topid];
            
        } else {
            // 使用旧数据
            [self loadMusicModel:musicArray];
        }
        
    }
    
    // 重新设置导航栏标题
    [CUSER setObject:topid forKey:CMusicTopid];
    [self setNavigationBarTitle];

}

#pragma mark - 加载数据，并缓存到本地
- (void)loadNetDataWithTopid:(NSString *)topid {

    [CNetWorking loadMusicRankWithTopid:topid
                                success:^(id response) {
                                    
                                    // 获取关键数据
                                    NSDictionary *showapi_res_body = response[@"showapi_res_body"];
                                    NSDictionary *pagebean = showapi_res_body[@"pagebean"];
                                    NSArray *songlist = pagebean[@"songlist"];
                                    
                                    // 将数据储存一下
                                    NSString *key = [NSString stringWithFormat:@"%@%@", CMusic_Top_, topid];
                                    if ([CUSER objectForKey:key] != nil) {
                                        [CUSER removeObjectForKey:key];
                                    }
                                    [CUSER setObject:songlist forKey:key];
                                    
                                    // 处理数据
                                    [self loadMusicModel:songlist];
                                    
                                } failure:^(NSError *err) {
                                    
                                    // 错误(提示加载不能)
                                    
                                    // 使用旧的数据
                                    NSString *key = [NSString stringWithFormat:@"%@%@", CMusic_Top_, topid];
                                    if ([CUSER objectForKey:key]) {
                                        
                                        NSArray *songlist = [CUSER objectForKey:key];
                                        // 处理数据
                                        [self loadMusicModel:songlist];
                                        
                                    }
                                    
                                }];

}

#pragma mark - 上拉加载
- (void)loadMoreData {

    NSInteger count = _tableViewDataArray.count;
    if (_songArray.count == count) {
        [self.songListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-2 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [_footer endRefreshing];
        return;
    }
    
    if (_songArray.count - count >= 20) {
        
        for (NSInteger i = count; i < count+20; i++) {
            [_tableViewDataArray addObject:_songArray[i]];
        }
        
    } else  {
        for (NSInteger i = count; i < _songArray.count; i++) {
            [_tableViewDataArray addObject:_songArray[i]];
        }
    }
    
    [self.songListTableView reloadData];
    
    [_footer endRefreshing];

}

#pragma mark - 下拉刷新
- (void)updateData {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // 两秒之后停止刷新
        [_songListTableView.refreshControl endRefreshing];
        
    });
    
}

#pragma mark - 获取排行榜的类型
- (NSString *)getTopid {

    NSString *topid = [CUSER objectForKey:CMusicTopid];
    if (topid == nil) {
        // 如果没有，那么默认是欧美排行榜
        [CUSER setObject:@"3" forKey:CMusicTopid];
        return @"3";
    } else {
        return [CUSER objectForKey:CMusicTopid];
    }
    
}

#pragma mark - 检测本地数据是否要更新
- (BOOL)isNecessaryToReloadData {
    
    // 接口中的日期格式为    2017-02-23

    NSString *lastDay = [CUSER objectForKey:CMusicSaveDay];
    if (lastDay == nil) {
        
        // 如果是初始状态，那么储存当天时间，并返回刷新确认指令
        NSString *todayString = [self getTodayString];
        [CUSER setObject:todayString forKey:CMusicSaveDay];
        return YES;
        
    } else {
        
        
        NSString *todayString = [self getTodayString];
        if ([todayString isEqualToString:lastDay]) {
            
            // 是同一天那就不更新
            return NO;
            
        } else {
            
            // 不是同一天就更新，并刷新更新日期
            [CUSER setObject:todayString forKey:CMusicSaveDay];
            return YES;
            
        }
        
    }

}

#pragma mark - 获取当天的日期格式化后的字符串
- (NSString *)getTodayString {

    NSDate *todayDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    return [formatter stringFromDate:todayDate];

}

#pragma mark - 处理网络请求下来的排行榜数据
- (void)loadMusicModel:(NSArray *)musicArray {
    
    // 把旧的数据清除
    [self.songArray removeAllObjects];
    [self.tableViewDataArray removeAllObjects];

    for (NSInteger i = 0; i < musicArray.count; i++) {
        
        NSDictionary *musicDic = musicArray[i];
        
        SongModel *model = [[SongModel alloc] init];
        model.songname = musicDic[@"songname"];
        model.seconds = musicDic[@"seconds"];
        model.albummid = musicDic[@"albummid"];
        model.songid = musicDic[@"songid"];
        model.singerid = musicDic[@"singerid"];
        model.albumpic_big = musicDic[@"albumpic_big"];
        model.albumpic_small = musicDic[@"albumpic_small"];
        model.downUrl = musicDic[@"downUrl"];
        model.url = musicDic[@"url"];
        model.singername = musicDic[@"singername"];
        model.albumid = musicDic[@"albumid"];
        model.number = [NSString stringWithFormat:@"%ld", i+1];
        
        [self.songArray addObject:model];
    }
    
    // 取出前二十用于显示，可以上拉获取更多
    for (int i = 0; i < 20; i++) {
        [self.tableViewDataArray addObject:_songArray[i]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 返回主线程更新UI
        [self.songListTableView reloadData];
        
        // 设置上拉加载
        self.songListTableView.mj_footer = self.footer;
        
        // 显示最顶部
        [self.songListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    });

}

#pragma mark - 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tableViewDataArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SongModel *model = _tableViewDataArray[indexPath.row];
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:SongListTableViewID];
    
    cell.songModel = model;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SongModel *songModel = _tableViewDataArray[indexPath.row];
    
    // 播放音乐
    _mp3Player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:songModel.url]];
    [_mp3Player play];
    
    if (_songImageView == nil) {
        // 导航栏左边的音乐图片
        _songImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _songImageView.layer.cornerRadius = 15;
        _songImageView.clipsToBounds = YES;
        _songImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftItemAction:)];
        [_songImageView addGestureRecognizer:tap];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_songImageView];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    [_songImageView sd_setImageWithURL:[NSURL URLWithString:songModel.albumpic_small]];
    
    // 创建播放详情页
    if (_songView == nil) {
        _songView = [[SongViewController alloc] init];
        _songView.delegate = self;

    }
    _songView.songList = _tableViewDataArray;
    _songView.liveIndex = indexPath.row;
    
    if (_mainTimer == nil) {
        // 定时器监听进度
        _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(currentTimeChange:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    

}

#pragma mark - 导航栏左边按钮响应，弹出播放界面
- (void)leftItemAction:(UIBarButtonItem *)item {
    
    [self presentViewController:_songView animated:YES completion:nil];
    
}

#pragma mark - 播放完毕，本来是监听播放完毕的，后来改用监听进度，因为前者的item改变，不能继续监听
- (void)songPlayDidEnd {

    // 监听歌曲播放完毕(不能只监听一次，因为currentItem会更改，下一首就不能监听到停止了)
    //        [[NSNotificationCenter defaultCenter] addObserver:self
    //                                                 selector:@selector(songPlayDidEnd:)
    //                                                     name:AVPlayerItemDidPlayToEndTimeNotification
    //                                                   object:_mp3Player.currentItem];
    
    // 判断播放类型是顺序播放还是随机播放
    if (_songView.songPlayType == SongPlayOrder) {
        
        // 顺序播放
        if (_songView.liveIndex < (_tableViewDataArray.count - 1)) {
            
            _songView.liveIndex++;
            
            SongModel *liveModel = _tableViewDataArray[_songView.liveIndex];
            [_songImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_small]];
            _mp3Player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:liveModel.url]];
            [_mp3Player play];
        } else {
        
            _songView.liveIndex = 0;
            
            SongModel *liveModel = _tableViewDataArray[_songView.liveIndex];
            [_songImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_small]];
            _mp3Player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:liveModel.url]];
            [_mp3Player play];

        
        }
        
    } else {
    
        // 随机播放
        if (_tableViewDataArray.count == 1) {
            
            // 当列表只有一首歌，那就循环播放
            __weak typeof(self) weakSelf = self;
            [_mp3Player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [weakSelf.mp3Player play];
            }];
            
        } else {
        
            NSInteger happenIndex = arc4random() % (_tableViewDataArray.count - 1);
            
            _songView.liveIndex = happenIndex;
            
            SongModel *liveModel = _tableViewDataArray[_songView.liveIndex];
            [_songImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_small]];
            _mp3Player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:liveModel.url]];
            [_mp3Player play];
        
        }
        
    
    }
    
    

}

#pragma mark - 监听播放进度
- (void)currentTimeChange:(NSTimer *)timer {

    float value = CMTimeGetSeconds(_mp3Player.currentItem.currentTime) / CMTimeGetSeconds(_mp3Player.currentItem.duration);
    
    // 如果播放结束了
    if (value == 1) {
        
        [self songPlayDidEnd];
        return;
    }
    
    // 设置播放页面的进度
    _songView.currentValue = value;
    
    
    
}

#pragma mark - 播放页面的代理方法
// 调节滑动进度条
- (void)songCurrentValueChange:(float)time {

    SongModel *liveModel = _tableViewDataArray[_songView.liveIndex];
    NSNumber *number = (NSNumber *)liveModel.seconds;
    
    CMTime changeTime = CMTimeMakeWithSeconds(number.floatValue * time, number.floatValue);
    
    [_mp3Player seekToTime:changeTime completionHandler:^(BOOL finished) {
        
        // 调节完毕之后，再次允许定时器运作
        
        
    }];

}
// 上一首
- (void)lastSong:(NSInteger)index {

    SongModel *liveModel = _tableViewDataArray[index];
    [_songImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_small]];
    _mp3Player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:liveModel.url]];
    [_mp3Player play];

}

// 暂停、播放
- (void)pauseSong:(SongStateType)type {

    if (type == SongPlay) {
        [_mp3Player play];
    } else {
        [_mp3Player pause];
    }

}

// 下一首
- (void)nextSong:(NSInteger)index {

    SongModel *liveModel = _tableViewDataArray[index];
    [_songImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.albumpic_small]];
    _mp3Player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:liveModel.url]];
    [_mp3Player play];

}


#pragma mark - 控制器被移除
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_mp3Player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CThemeChangeNotification
                                                  object:nil];

}













    

@end
