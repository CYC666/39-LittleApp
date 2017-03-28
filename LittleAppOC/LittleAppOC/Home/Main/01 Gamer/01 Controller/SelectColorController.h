//
//  SelectColorController.h
//  LittleAppOC
//
//  Created by yongda sha on 17/3/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectColorController : UIViewController


// 显示颜色
@property (weak, nonatomic) IBOutlet UIView *colorView;

// 颜色标致
@property (weak, nonatomic) IBOutlet UILabel *redView;
@property (weak, nonatomic) IBOutlet UILabel *greenView;
@property (weak, nonatomic) IBOutlet UILabel *blueViw;
@property (weak, nonatomic) IBOutlet UILabel *alphaView;

// 滑动条
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

// 输入框
@property (weak, nonatomic) IBOutlet UITextField *redField;
@property (weak, nonatomic) IBOutlet UITextField *greenField;
@property (weak, nonatomic) IBOutlet UITextField *blueField;
@property (weak, nonatomic) IBOutlet UITextField *alphaField;

@end
