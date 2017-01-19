//
//  WeatherCellFlowLayout.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/18.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "WeatherCellFlowLayout.h"

#define WeatherCellWidth kScreenWidth * 0.7
#define WeatherCellHeight kScreenWidth * 0.7

@implementation WeatherCellFlowLayout

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        //单元格大小 (屏幕宽度*0.7   3/4比例)
        self.itemSize = CGSizeMake(WeatherCellWidth , WeatherCellHeight);
        //滑动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

#pragma mark - 当当前布局bounds发生改变时，让其他布局不发生改变
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
#pragma mark - 前端页面的放大效果(布局时调用)
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //1.获取当前显示collectionview的区域和坐标
    CGRect visibaleRect;
    visibaleRect.origin = self.collectionView.contentOffset;
    visibaleRect.size = self.collectionView.bounds.size;
    //2.调用父类方法获取当前rect中这些item的布局信息
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *safeAtteibutes = [[NSArray alloc] initWithArray:attributes copyItems:YES];
    for (UICollectionViewLayoutAttributes *attribue in safeAtteibutes) {
        if (CGRectIntersectsRect(attribue.frame, rect)) {       //判断是否有交集(item是否进去系统检测范围之内)
            // float distance = CGRectGetMidX(visibaleRect) - attribue.center.x;       //获取当前item到中点的距离
            // float discale = distance/200;   //放大倍数
            // if (ABS(distance) < 200) {
                // float scale = 1 + 0.3*(1 - ABS(discale));       //凑数
                attribue.transform3D = CATransform3DMakeScale(1, 1, 1);     //对空间三个方向进行放大
                attribue.zIndex = 1;        //更改在z轴的的位置
            // }
        }
    }
    return safeAtteibutes;  //返回放大后的效果图
}

@end
