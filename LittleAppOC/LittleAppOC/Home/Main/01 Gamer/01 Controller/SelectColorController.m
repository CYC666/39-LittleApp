//
//  SelectColorController.m
//  LittleAppOC
//
//  Created by yongda sha on 17/3/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "SelectColorController.h"

@interface SelectColorController ()

@end

@implementation SelectColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"取色板";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    
    
    // 给滑动条添加值改变响应
    [_redSlider addTarget:self action:@selector(redSilderChange:) forControlEvents:UIControlEventValueChanged];
    [_greenSlider addTarget:self action:@selector(greenSilderChange:) forControlEvents:UIControlEventValueChanged];
    [_blueSlider addTarget:self action:@selector(blueSilderChange:) forControlEvents:UIControlEventValueChanged];
    [_alphaSlider addTarget:self action:@selector(alphaSilderChange:) forControlEvents:UIControlEventValueChanged];
    
    // 给输入框添加值发生改变的响应
    [_redField addTarget:self action:@selector(fieldValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [_greenField addTarget:self action:@selector(fieldValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [_blueField addTarget:self action:@selector(fieldValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [_alphaField addTarget:self action:@selector(fieldValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // 下滑显示颜色区域可隐藏键盘
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardTap:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [_colorView addGestureRecognizer:downSwipe];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    // 开启点击显示、隐藏导航栏
    self.navigationController.hidesBarsOnTap = YES;

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    // 关闭点击显示、隐藏导航栏
    self.navigationController.hidesBarsOnTap = NO;

}


#pragma mark - 滑动条值改变
// 红
- (void)redSilderChange:(UISlider *)slider {

    _redField.text = [NSString stringWithFormat:@"%.0f", slider.value];
    
    self.colorView.backgroundColor = CRGB([_redField.text floatValue], [_greenField.text floatValue], [_blueField.text floatValue], [_alphaField.text floatValue]);

}
// 绿
- (void)greenSilderChange:(UISlider *)slider {
    
    _greenField.text = [NSString stringWithFormat:@"%.0f", slider.value];
    
    self.colorView.backgroundColor = CRGB([_redField.text floatValue], [_greenField.text floatValue], [_blueField.text floatValue], [_alphaField.text floatValue]);
    
}
// 蓝
- (void)blueSilderChange:(UISlider *)slider {
    
    _blueField.text = [NSString stringWithFormat:@"%.0f", slider.value];
    
    self.colorView.backgroundColor = CRGB([_redField.text floatValue], [_greenField.text floatValue], [_blueField.text floatValue], [_alphaField.text floatValue]);
    
}
// alpha
- (void)alphaSilderChange:(UISlider *)slider {
    
    _alphaField.text = [NSString stringWithFormat:@"%.1f", slider.value];
    
    self.colorView.backgroundColor = CRGB([_redField.text floatValue], [_greenField.text floatValue], [_blueField.text floatValue], [_alphaField.text floatValue]);
    
}


#pragma mark - 输入框代理方法
- (void)fieldValueDidChange:(UITextField *)textField {
    

    if ([textField isEqual:_redField]) {
        _redSlider.value = [textField.text floatValue];
        
    } else if ([textField isEqual:_greenField]) {
        _greenSlider.value = [textField.text floatValue];
        
    } else if ([textField isEqual:_blueField]) {
        _blueSlider.value = [textField.text floatValue];
        
    } else if ([textField isEqual:_alphaField]) {
        _alphaSlider.value = [textField.text floatValue];
        
    }
    
    self.colorView.backgroundColor = CRGB([_redField.text floatValue], [_greenField.text floatValue], [_blueField.text floatValue], [_alphaField.text floatValue]);

}



#pragma mark - 手势响应
- (void)hideKeyBoardTap:(UISwipeGestureRecognizer *)swipe {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}



























@end
