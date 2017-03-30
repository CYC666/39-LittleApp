//
//  VSliderView.h
//  VSlider
//
//  Created by yongda sha on 2017/3/30.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VSliderView;

@protocol VSliderViewDelegate <NSObject>

@optional
// 拖动指示图结束后响应
- (void)endDragTipView:(VSliderView *)sliderView;

@end

@interface VSliderView : UIView

@property (weak, nonatomic) id<VSliderViewDelegate> delegate;  // 代理对象
@property (assign, nonatomic) float minValue;                  // 最大值
@property (assign, nonatomic) float maxValue;                  // 最小值
@property (assign, nonatomic) float currentValue;              // 当期值
@property (strong, nonatomic) UIColor *bColor;                 // 背景颜色
@property (strong, nonatomic) UIColor *tColor;                 // 轨迹颜色
@property (copy, nonatomic) NSString *tImage;                  // 指示图名字
@property (assign, nonatomic) float trackToRight;              // 轨迹与右边界的距离

- (instancetype)initWithFrame:(CGRect)frame
                     minValue:(float)min
                     maxValue:(float)max
                 currentValue:(float)current
              backgroundColor:(UIColor *)bColor
                    tintColor:(UIColor *)tColor
                     tipImage:(NSString *)tImage
                 trackToRight:(float)distnace;




@end
