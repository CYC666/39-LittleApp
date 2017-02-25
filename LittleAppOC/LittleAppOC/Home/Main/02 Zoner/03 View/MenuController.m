//
//  MenuController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/25.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController


- (instancetype)initWithFrame:(CGRect)frame Topid:(NSString *)topid {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _oldTopid = topid;
        
        [self creatSubviews];
    }
    return self;

}

// 创建子视图
- (void)creatSubviews {

    // 底部的按钮(点击退出)
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    backButton.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    // 计算按钮大小(空隙大小为40)
    float buttonSize = (kScreenWidth - 40*4)/3;
    float startY = (kScreenHeight - kScreenWidth)/2;
    
    NSArray *buttonTitle = @[@"欧美", @"内地", @"港台", @"韩国", @"日本", @"民谣", @"摇滚", @"售量", @"热歌"];
    NSArray *buttonTag = @[@"3", @"5", @"6", @"16", @"17", @"18", @"19", @"23", @"26"];
    
    // 中部的九宫格菜单按钮
    for (NSInteger i = 0; i < 9; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40 + (buttonSize + 40)*(i%3), startY + 40 + (buttonSize + 40)*(i/3), buttonSize, buttonSize);
        button.backgroundColor = CRGB(45, 194, 131, 1);
        button.layer.cornerRadius = buttonSize/2;
        button.tag = [buttonTag[i] integerValue];
        button.titleLabel.font = C_MAIN_FONT(20);
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 突出当前排行榜类型的按钮
        if ([buttonTag[i] isEqualToString:_oldTopid]) {
            button.userInteractionEnabled = NO;
        }
        
    }
    

}


#pragma mark - 退出当前控制器
- (void)backAction {
    
    [UIView animateWithDuration:.35
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];

}

#pragma mark - 点击了按钮
- (void)buttonAction:(UIButton *)button {
    
    [UIView animateWithDuration:.1
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.1
                                          animations:^{
                                              button.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:.1
                                                               animations:^{
                                                                   button.transform = CGAffineTransformMakeScale(1, 1);
                                                               } completion:^(BOOL finished) {
                                                                   
                                                                   self.selectTopid = [NSString stringWithFormat:@"%ld", button.tag];
                                                                   
                                                                   if ([_delegate respondsToSelector:@selector(didSelectMenuController:)]) {
                                                                       [_delegate didSelectMenuController:self];
                                                                   }
                                                                   
                                                                   [UIView animateWithDuration:.35
                                                                                    animations:^{
                                                                                        self.alpha = 0;
                                                                                    } completion:^(BOOL finished) {
                                                                                        [self removeFromSuperview];
                                                                                    }];

                                                               }];
                                          }];
                     }];
    
    
}


































@end
