//
//  WeatherCollectionView.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/18.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "WeatherCollectionView.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherCellFlowLayout.h"

#define WeatherCollectionViewCellID @"WeatherCollectionViewCellID"

@interface WeatherCollectionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) NSInteger lastPage;   // 滑动前的页数

@end

@implementation WeatherCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self != nil) {
        //控制滑动速度
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        //清空集合视图背景颜色
        self.backgroundColor = [UIColor clearColor];
        //不显示水平滑动条
        self.showsHorizontalScrollIndicator = NO;
        //注册单元格
        [self registerClass:[WeatherCollectionViewCell class] forCellWithReuseIdentifier:WeatherCollectionViewCellID];
        //设置代理，签订协议
        self.dataSource = self;
        self.delegate = self;
        
    }
    return self;
}


#pragma mark - 单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _weatherArray.count;
}
#pragma mark - 创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WeatherCollectionViewCellID
                                                                                forIndexPath:indexPath];
    cell.weatherModel = _weatherArray[indexPath.row];
    
    return cell;
}
#pragma mark - 设置集合视图边缘留白
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, (kScreenWidth * 0.3)/2, 0, (kScreenWidth * 0.3)/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentPage != indexPath.item) {
        //点击之后不允许用户再点击视图
        self.userInteractionEnabled = NO;
        //将点击的视图移动到中央
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        //0.35秒后，用户可以再次点击视图
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
        //保存点击之后对应中间的item的位置
        self.currentPage = indexPath.item;
    }
}

#pragma mark - 移动单元格的时候，自动居中
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //x轴位移(相对原始)
    NSInteger xOffset = targetContentOffset->x;
    //获取当前视图的布局对象
    WeatherCellFlowLayout *flowLayout = (WeatherCellFlowLayout *)self.collectionViewLayout;
    //cell单元格页的宽度
    NSInteger pageWidth = kScreenWidth * 0.7 + flowLayout.minimumLineSpacing/2 * 2;
    //当前cell的页数
    NSInteger pageNum = (pageWidth/2 + xOffset) / pageWidth;
    //通过判断滑动的速度来确定当前的页数(优化)
    pageNum = velocity.x == 0 ? pageNum : (velocity.x > 0 ? pageNum + 1 : pageNum - 1);
    //设置当前 pagenum 的范围(0 -- _collectionMoviesData.count-1),防止划过限产生的bug
    pageNum = MIN(MAX(pageNum, 0), _weatherArray.count-1);
    //通过当前页数，直接修改目标偏移量到当前页面中间
    targetContentOffset->x = pageNum * pageWidth;
    
    self.currentPage = pageNum;
    
}

#pragma mark - 当停止滑动时才发通知修改云图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (self.currentPage != _lastPage) {
        [CNOTIFY postNotificationName:CWeatherCellChangeNotification object:nil];
    }
    _lastPage = self.currentPage;

}






























@end
