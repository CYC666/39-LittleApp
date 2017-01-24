//
//  GamerCell.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CThemeLabel;

@interface GamerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;
@property (weak, nonatomic) IBOutlet CThemeLabel *gameNameLabel;

@end
