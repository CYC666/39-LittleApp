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
#import "BoomController.h"
#import "SelectColorController.h"
#import "CSalesTargetViewController.h"
#import "brokenLineController.h"
#import "FlowSliderController.h"


#define GamerCellID @"GamerCellID"  

@interface GamerController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation GamerController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"小玩意儿";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    self.view.backgroundColor = CTHEME.themeColor;
    
    // 导航栏返回按钮
    UIBarButtonItem *selfBackItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:nil];
    self.navigationItem.backBarButtonItem = selfBackItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
    UICollectionView *gamesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, kScreenHeight - 64)
                                                               collectionViewLayout:flowLayout];
    gamesCollectionView.backgroundColor = [UIColor clearColor];
    gamesCollectionView.showsVerticalScrollIndicator = NO;
    gamesCollectionView.alwaysBounceVertical = YES;
    flowLayout.itemSize = CGSizeMake(100, 115);
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

    return 6;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    GamerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GamerCellID
                                                                forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_2048"];
        cell.gameNameLabel.text = @"2048";
    } else if (indexPath.item == 1) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_target"];
        cell.gameNameLabel.text = @"目标";
    } else if (indexPath.item == 2) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_boom"];
        cell.gameNameLabel.text = @"扫雷";
    } else if (indexPath.item == 3) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_color"];
        cell.gameNameLabel.text = @"取色板";
    } else if (indexPath.item == 4) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_line"];
        cell.gameNameLabel.text = @"折线图";
    } else if (indexPath.item == 5) {
        cell.gameImageView.image = [UIImage imageNamed:@"icon_gamer_flowSlider"];
        cell.gameNameLabel.text = @"标尺";
    }
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        // 2048
        
    } else if (indexPath.row == 1) {
    
        // 目标
        CSalesTargetViewController *controller = [[CSalesTargetViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    
    } else if (indexPath.row == 2) {
    
        // 寻找炸弹(超大滑动视图)
        BoomController *controller = [[BoomController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    
    } else if (indexPath.row == 3) {
        
        // 区色板
        SelectColorController *controller = [[SelectColorController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (indexPath.row == 4) {
        
        // 折线图
        brokenLineController *controller = [[brokenLineController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (indexPath.row == 5) {
        
        // 折线图
        FlowSliderController *controller = [[FlowSliderController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }

}





































@end
