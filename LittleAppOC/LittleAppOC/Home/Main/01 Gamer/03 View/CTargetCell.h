//
//  CTargetCell.h
//  LFBaseFrameTwo
//
//  Created by yongda sha on 17/3/10.
//  Copyright © 2017年 admin. All rights reserved.
//

// 销售目标的单元格

#import <UIKit/UIKit.h>

@interface CTargetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UIView *targetView;

@property (assign, nonatomic) BOOL showShadow;

@end
