//
//  GamerController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "GamerController.h"
#import "ThemeManager.h"
#import "GamerCell.h"
#import "CThemeLabel.h"

#define GamerCellID @"GamerCellID"  

@interface GamerController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation GamerController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"游戏";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    self.view.backgroundColor = CTHEME.themeColor;
    
    // 监听主题改变
    [CNOTIFY addObserver:self
                selector:@selector(changeBackgroundColor:)
                    name:CThemeChangeNotification
                  object:nil];
    
    // 创建UI
    [self creatSubviews];
}

#pragma mark - 创建UI
- (void)creatSubviews {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *gamesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                               collectionViewLayout:flowLayout];
    gamesCollectionView.backgroundColor = [UIColor clearColor];
    flowLayout.itemSize = CGSizeMake(110, 150);
    flowLayout.headerReferenceSize = CGSizeMake(0, 20);
    gamesCollectionView.delegate = self;
    gamesCollectionView.dataSource = self;
    [gamesCollectionView registerNib:[UINib nibWithNibName:@"GamerCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:GamerCellID];
    [self.view addSubview:gamesCollectionView];

}

#pragma mark - 主题改变，修改背景颜色
- (void)changeBackgroundColor:(NSNotification *)notification {
    
    self.view.backgroundColor = CTHEME.themeColor;
    
}

#pragma mark - 集合视图代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 10;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    GamerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GamerCellID
                                                                forIndexPath:indexPath];
//    if (indexPath.item == 0) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_2048"];
        cell.gameNameLabel.text = @"2048";
//    }
    return cell;

}





































@end
