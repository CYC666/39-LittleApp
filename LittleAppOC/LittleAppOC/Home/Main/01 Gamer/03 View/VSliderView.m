//
//  VSliderView.m
//  VSlider
//
//  Created by yongda sha on 2017/3/30.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "VSliderView.h"

@interface VSliderView () {

    UISlider *_slider;       // 滑动条
    UIImageView *_tipView;   // 指示图

}

@end

@implementation VSliderView


- (instancetype)initWithFrame:(CGRect)frame
                     minValue:(float)min
                     maxValue:(float)max
                 currentValue:(float)current
              backgroundColor:(UIColor *)bColor
                    tintColor:(UIColor *)tColor
                     tipImage:(NSString *)tImage
                 trackToRight:(float)distnace{

    if (self = [super initWithFrame:frame]) {
        
        _minValue = min;
        _maxValue = max;
        _currentValue = current;
        _bColor = bColor;
        _tColor = tColor;
        _tImage = tImage;
        _trackToRight = distnace;
        
        [self creatSubviews];
   
    }
    return self;

}


#pragma mark - 创建UI
- (void)creatSubviews {
    
    // 背景颜色
    self.backgroundColor = _bColor;
    
    // 灰色轨迹
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = CGRectMake(self.bounds.size.width - _trackToRight, 0, 5, self.bounds.size.height);
    lineLayer.cornerRadius = 2.5;
    lineLayer.backgroundColor = _tColor.CGColor;
    [self.layer addSublayer:lineLayer];;
    
    
    // 指示图
    _tipView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    _tipView.image = [UIImage imageNamed:_tImage];
    _tipView.userInteractionEnabled = YES;
    [self addSubview:_tipView];
    
    // 计算起始位置
    float x = self.bounds.size.width/2.0;
    float y = self.bounds.size.height * ((_maxValue - _currentValue) / _maxValue);
    CGPoint center = CGPointMake(x, y);
    _tipView.center = center;
    
    // 添加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTipViewAction:)];
    [_tipView addGestureRecognizer:pan];
    

}

#pragma mark - 拖动提示图
- (void)panTipViewAction:(UIPanGestureRecognizer *)pan {

    CGPoint center = [pan locationInView:self];
    
    // 移动中,修改提示图的位置
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (center.y > 0 && center.y < self.bounds.size.height) {   // 不应超过俯视图
            
            _tipView.center = CGPointMake(self.bounds.size.height/2.0, center.y);
            
        }
   
    } else if (pan.state == UIGestureRecognizerStateEnded) {
    
        // 计算位置对应的currentValue，响应代理方法
        _currentValue = (self.bounds.size.height - center.y) / self.bounds.size.height * (_maxValue);
        if (_currentValue > _maxValue) {
            _currentValue = _maxValue;
        } else if (_currentValue < _minValue) {
            _currentValue = _minValue;
        }
        
        if ([_delegate respondsToSelector:@selector(endDragTipView:)]) {
            [_delegate endDragTipView:self];
        }
    
    }

}



































@end
