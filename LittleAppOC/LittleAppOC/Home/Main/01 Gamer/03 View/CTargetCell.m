//
//  CTargetCell.m
//  LFBaseFrameTwo
//
//  Created by yongda sha on 17/3/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CTargetCell.h"

@implementation CTargetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    
    
    
}

// 是否显示阴影
- (void)setShowShadow:(BOOL)showShadow {

    _showShadow = showShadow;
    
    if (showShadow) {
        
        CALayer *topLayer = [[CALayer alloc] init];
        topLayer.frame = CGRectMake(5, 0, kScreenWidth - 10, 130);
        topLayer.backgroundColor = [UIColor whiteColor].CGColor;
        topLayer.shadowRadius = 1;
        topLayer.shadowColor = [UIColor grayColor].CGColor;
        topLayer.shadowOffset = CGSizeMake(0, 2);
        topLayer.shadowOpacity = .6;
        [self.layer insertSublayer:topLayer atIndex:0];
        
        CALayer *buttomLayer = [[CALayer alloc] init];
        buttomLayer.frame = CGRectMake(5, 0, kScreenWidth - 10, 135);
        buttomLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer insertSublayer:buttomLayer atIndex:0];
    } else {
        
        CALayer *buttomLayer = [[CALayer alloc] init];
        buttomLayer.frame = CGRectMake(5, 0, kScreenWidth - 10, 135);
        buttomLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer insertSublayer:buttomLayer atIndex:0];
    }

}

- (IBAction)editAction:(id)sender {
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
