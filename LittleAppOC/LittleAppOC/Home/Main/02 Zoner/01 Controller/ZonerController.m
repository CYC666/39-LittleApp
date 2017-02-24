//
//  ZonerController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "ZonerController.h"
#import "ThemeManager.h"
#import "CNetWorking.h"
#import "SongModel.h"
#import "SongCell.h"



#define SongListTableViewID @"SongListTableViewID"  // 表视图单元格重用标识符

@interface ZonerController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tableViewDataArray;   // 用于表视图显示的数组

@end

@implementation ZonerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 独立的方法去做导航栏的设置
    [self setNavigationBar];

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
    }
    return _songListTableView;

}

#pragma mark - 设置导航栏
- (void)setNavigationBar {
    
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
    
    // 导航栏左边的下拉菜单按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"music_menuButton"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(leftItemAction:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    // 导航栏右边的刷新按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"music_rightButton"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(rightItemAction:)];
    [self.navigationItem setRightBarButtonItem:rightItem];

}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    
    
}

#pragma mark - 导航栏按钮响应
- (void)leftItemAction:(UIBarButtonItem *)item {

    

}

- (void)rightItemAction:(UIBarButtonItem *)item {
    
    // 不能频繁更新
    
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

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;

}

























    

@end
