//
//  SongCell.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/2/24.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "SongCell.h"
#import "SongModel.h"
#import "CThemeLabel.h"
#import "ThemeManager.h"
#import "UIImageView+WebCache.h"

@implementation SongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 查看模式
    _songNameLabel.textColor = CTHEME.themeType == CDayTheme ? C_MAIN_TEXTCOLOR : [UIColor whiteColor];
    
    _singerNameLabel.adjustsFontSizeToFitWidth = YES;
    _number.adjustsFontSizeToFitWidth = YES;
    _albumImageView.layer.cornerRadius = 25;
    _albumImageView.clipsToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    
}

- (void)setSongModel:(SongModel *)songModel {

    _songModel = songModel;
    
    _number.text = songModel.number;
    [_albumImageView sd_setImageWithURL:[NSURL URLWithString:songModel.albumpic_small]];
    _songNameLabel.text = songModel.songname;
    _singerNameLabel.text = songModel.singername;
    
    // 前三名的排名颜色是红色(else是必须的，不然会有复用)
    if ([songModel.number integerValue] <= 3) {
        _number.textColor = CRGB(255, 96, 77, 1);
    } else {
        _number.textColor = CRGB(105, 105, 105, 1);
    }
    
    

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    
}







































@end
