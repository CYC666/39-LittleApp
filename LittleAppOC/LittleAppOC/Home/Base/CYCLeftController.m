//
//  CYCLeftController.m
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/15.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import "CYCLeftController.h"

#define CYCLeftControllerCellID @"CYCLeftControllerCellID"  // 单元格重用标识符

@interface CYCLeftController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *tableViewTitles;     // 表视图的title
@property (strong, nonatomic) NSArray *tableViewIcons;      // 表视图的icon

@end

@implementation CYCLeftController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatSubviews];
}

#pragma mark - 懒加载
- (UIImageView *)headImageView {

    if (_headImageView == nil) {
        
    }
    return _headImageView;

}
// ------------------------------------------------------UI创建-------------------------------------------------------
#pragma mark - 创建子视图
- (void)creatSubviews {

    // 头部背景图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths firstObject] stringByAppendingString:@"/leftControllerHeadImage.jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image;
    if (imageData == nil) {
        image = [UIImage imageNamed:@"image_leftControllerHeadImage"];
    } else {
        image = [UIImage imageWithData:imageData];
    }
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cLeftControllerWidth, cLeftControllerHeadImageHeight)];
    _headImageView.image = image;
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    [_headImageView addGestureRecognizer:headTap];
    [self.view addSubview:_headImageView];
    
    // 表视图显示功能
    _tableViewTitles = @[@"曹老师",
                         @"第三方",
                         @"功能介绍",
                         @"建议反馈"];
    _tableViewIcons = @[@"icon_leftCtrl_user",
                        @"icon_leftCtrl_Third",
                        @"icon_leftCtrl_function",
                        @"icon_leftCtrl_feedBack"];
    _middleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cLeftControllerHeadImageHeight + 15,
                                                                     cLeftControllerWidth, kScreenHeight - cLeftControllerHeadImageHeight - 49 - 15)
                                                    style:UITableViewStylePlain];
    _middleTableView.separatorColor = [UIColor clearColor];
    [_middleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CYCLeftControllerCellID];
    _middleTableView.delegate = self;
    _middleTableView.dataSource = self;
    [self.view addSubview:_middleTableView];
    // 夜间模式开关
    
    // 天气
    

}




// ------------------------------------------------------动作响应区----------------------------------------------------
#pragma mark - 点击了头部的背景图片,更换图片
- (void)headTapAction:(UITapGestureRecognizer *)tap {


}








// -----------------------------------------------------代理协议方法-----------------------------------------------------
#pragma mark - 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CYCLeftControllerCellID];
    cell.textLabel.text = _tableViewTitles[indexPath.row];
    cell.textLabel.font = C_MAIN_FONT(17);
    cell.textLabel.textColor = C_MAIN_TEXTCOLOR;
    cell.imageView.image = [UIImage imageNamed:_tableViewIcons[indexPath.row]];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // 点击之后取消高亮状态
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    

}






















@end
