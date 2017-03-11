//
//  CSalesTargetViewController.m
//  LFBaseFrameTwo
//
//  Created by yongda sha on 17/3/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CSalesTargetViewController.h"
#import "CTargetCell.h"
// #import "CTargetHeaderCell.h"
// #import "CTargetFooterCell.h"

#define CTargetCellID @"CTargetCellID"
#define CTargetHeaderCell @"CTargetHeaderCellID"
#define CTargetFooterCell @"CTargetFooterCellID"

#define CTargetTag 3140

@interface CSalesTargetViewController () <UITableViewDelegate, UITableViewDataSource> {

    // 用户信息单例
    // UserInformation *_userInfo;
    
    // 工具方法单例
    // SmallFunctionTool *_smallFunc;
    
    // 导航栏右边的按钮
    UIButton *_rightItem;
    
    // 表视图
    UITableView *_targetTableView;
    
    // 数据
    NSMutableArray *_showDataArray;
    
    // 是否展示cell
    BOOL isShowCell;

}

@end

@implementation CSalesTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    // _userInfo = [UserInformation sharedInstance];
    // _smallFunc = [SmallFunctionTool sharedInstance];
    _showDataArray = [NSMutableArray array];
    
    // self.view.backgroundColor = Background_Color;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //添加导航栏左右按钮
    _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    if ([_userInfo.UserType isEqualToString:@"1"]) {
//        [_rightItem setImage:[UIImage imageNamed:@"SalesTargetAdminItem"] forState:UIControlStateNormal];
//    } else {
//        [_rightItem setImage:[UIImage imageNamed:@"SalesTargetRightItem"] forState:UIControlStateNormal];
//    }
    [_rightItem setImage:[UIImage imageNamed:@"icon_gamer_target_add"] forState:UIControlStateNormal];
    _rightItem.frame = CGRectMake(0, 0, 22, 22);
    [_rightItem addTarget:self action:@selector(navRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barRight = [[UIBarButtonItem alloc] initWithCustomView:_rightItem];
    self.navigationItem.rightBarButtonItem = barRight;
    
    _targetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                    style:UITableViewStyleGrouped];
    _targetTableView.backgroundColor = [UIColor clearColor];
    _targetTableView.separatorColor = [UIColor clearColor];
    [_targetTableView registerNib:[UINib nibWithNibName:@"CTargetCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CTargetCellID];
    // [_targetTableView registerNib:[UINib nibWithNibName:@"CTargetHeaderCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:CTargetHeaderCell];
    // [_targetTableView registerNib:[UINib nibWithNibName:@"CTargetFooterCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:CTargetFooterCell];
    _targetTableView.delegate = self;
    _targetTableView.dataSource = self;
    [self.view addSubview:_targetTableView];
    
    
    
    //初始化语言
    [self changeLanguage];
    
    
    // 测试的数据
    [_showDataArray addObject:@[@"Sales target for year (2017)", @"$8,000,000", @"Closed Amount", @"0.8", @"Target Amount", @"0.7"]];
    [_showDataArray addObject:@[@"Team A", @"$2,000,000", @"Closed Amount", @"0.6", @"Target Amount", @"0.7"]];
    [_showDataArray addObject:@[@"Team B", @"$2,500,000", @"Closed Amount", @"0.6", @"Target Amount", @"0.7"]];
    [_showDataArray addObject:@[@"Team C", @"$1,500,000", @"Closed Amount", @"0.6", @"Target Amount", @"0.7"]];
    [_showDataArray addObject:@[@"Team D", @"$2,000,000", @"Closed Amount", @"0.6", @"Target Amount", @"0.7"]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    // 根据身份加载销售目标
//    if ([_userInfo.UserType isEqualToString:@"1"]) {
//        
//        // admin 171
//        NSString *method = [NSString stringWithFormat:@"GetSalesTargetList_Admin"];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [SOAPUrlSession languageVersion],@"LanguageVersion",   //语言版本(chs,cht,en)中简，中繁，英文）
//                             _userInfo.OrganizeId,@"OrganizeId",                    //公司编号(当前登录用户公司编号)
//                             @"1",@"Query",                                         //查询条件(1-公司年度目标 2-公司团队年度目标)
//                             _userInfo.UserId,@"UserId",                            //用户编号(当前登录用户编号)
//                             @"0",@"TargetYear",                                    //目标年份(默认传0，非默认传指定年份)
//                             @"1",@"Pagination",                                    //是否分页(0-不使用 1-使用)
//                             @"1",@"PageIndex",                                     //当前页数
//                             @"10",@"PageSize",                                     //每页条数
//                             nil];
//        [SOAPUrlSession SOAPDataWithMethod:method
//                                 parameter:dic
//                                   success:^(id responseObject) {
//                                       
//                                       // 返回的Code字段：200-成功，300-失败，400-无数据，500-内部服务异常
//                                       NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"Code"]];
//                                       
//                                       if ([code isEqualToString:@"200"]) {
//                                           
//                                           NSArray *dataArray = responseObject[@"Data"];
//                                           if (dataArray.count > 0) {
//                                               
//                                               // 存在数据
//                                               
//                                               
//                                           } else {
//                                               
//                                               //  没有数据
//                                               NSLog(@"没有数据");
//                                               
//                                               
//                                           }
//                                           
//                                           
//                                       } else {
//                                           
//                                           NSLog(@"内部异常");
//                                           
//                                       }
//                                       
//                                       
//                                       
//                                   } failure:^(NSError *error) {
//                                       
//                                       NSLog(@"请求失败");
//                                       
//                                   }];
//        
//    } else if ([_userInfo.UserType isEqualToString:@"2"]) {
//    
//        // 经理
//        
//    } else if ([_userInfo.UserType isEqualToString:@"3"]) {
//    
//        // 销售员
//        
//    }

}


#pragma mark - 本地化和国际化方法，切换语言是对应的文案的改变
//切换语言版本时，需要设置的label
- (void)changeLanguage {
    
    // self.navigationItem.title = kLocalizedString(@"Working_Sales_Target",@"导航栏标题/销售目标");
    // self.navigationItem.title = @"销售目标";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    title.text = @"销售目标";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
        
}

#pragma mark - 导航栏右边按钮的相应
- (void)navRightItemAction:(UIButton *)button {

    

}


#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return isShowCell ? _showDataArray.count-1 : 0;
    } else {
        return 0;
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 135.0f;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *array = _showDataArray[indexPath.row + 1];
    CTargetCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"CTargetCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImageView.image = [UIImage imageNamed:@"icon_gamer_target_user"];
    cell.nameLabel.text = array[0];
    cell.moneyLabel.text = array[1];
    if (indexPath.row < (_showDataArray.count - 2)) {
        cell.showShadow = YES;
    } else {
        cell.showShadow = NO;
    }
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSArray *dataArr = _showDataArray[0];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.layer.shadowRadius = 5;
//    headerView.layer.shadowColor = [UIColor grayColor].CGColor;
//    headerView.layer.shadowOffset = CGSizeMake(0, 5);
//    headerView.layer.shadowOpacity = .9;
    
    CALayer *layerButtom = [[CALayer alloc] init];
    layerButtom.frame = CGRectMake(0, 10, kScreenWidth, 110);
    layerButtom.backgroundColor = [UIColor whiteColor].CGColor;
    layerButtom.cornerRadius = 5;
    [headerView.layer addSublayer:layerButtom];
    if (isShowCell && section == 0) {
        layerButtom.shadowRadius = 5;
        layerButtom.shadowColor = [UIColor grayColor].CGColor;
        layerButtom.shadowOffset = CGSizeMake(0, 5);
        layerButtom.shadowOpacity = .9;
    } else {
//        layerButtom.shadowRadius = 0;
//        layerButtom.shadowColor = [UIColor grayColor].CGColor;
//        layerButtom.shadowOffset = CGSizeMake(0, 0);
//        layerButtom.shadowOpacity = .9;
    }
    
    CALayer *layerTop = [[CALayer alloc] init];
    layerTop.frame = CGRectMake(0, 0, kScreenWidth, 20);
    layerTop.backgroundColor = [UIColor whiteColor].CGColor;
    [headerView.layer addSublayer:layerTop];
    
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kScreenWidth - 40, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.text = dataArr[0];
    [headerView addSubview:titleLabel];
    
    // 金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 20)];
    moneyLabel.font = [UIFont boldSystemFontOfSize:20];
    moneyLabel.text = dataArr[1];
    [headerView addSubview:moneyLabel];
    
    // Close Amount
    UILabel *CloseLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 120, 20)];
    CloseLabel.font = [UIFont systemFontOfSize:15];
    CloseLabel.text = dataArr[2];
    [headerView addSubview:CloseLabel];
    CALayer *closeLayer = [[CALayer alloc] init];
    closeLayer.frame = CGRectMake(120 + 20, 75, kScreenWidth - (120 + 20 + 20) - 30, 10);
    closeLayer.backgroundColor = [UIColor greenColor].CGColor;
    [headerView.layer addSublayer:closeLayer];
    
    
    
    // Target Amount
    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 120, 20)];
    targetLabel.font = [UIFont systemFontOfSize:15];
    targetLabel.text = dataArr[4];
    [headerView addSubview:targetLabel];
    CALayer *targetLayer = [[CALayer alloc] init];
    targetLayer.frame = CGRectMake(120 + 20, 95, kScreenWidth - (120 + 20 + 20), 10);
    targetLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [headerView.layer addSublayer:targetLayer];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    CALayer *layerTop = [[CALayer alloc] init];
    layerTop.frame = CGRectMake(10, 0, kScreenWidth - 20, 20);
    // layer.backgroundColor = Publie_Color.CGColor;
    layerTop.backgroundColor = [UIColor purpleColor].CGColor;
    // layerTop.cornerRadius = 5;
    [footerView.layer addSublayer:layerTop];
    
    CALayer *layerButtom = [[CALayer alloc] init];
    layerButtom.frame = CGRectMake(10, 10, kScreenWidth - 20, 30);
    layerButtom.backgroundColor = [UIColor purpleColor].CGColor;
    layerButtom.cornerRadius = 5;
    [footerView.layer addSublayer:layerButtom];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gamer_target_down"]];
    downImageView.center = CGPointMake(kScreenWidth/2.0, 20);
    [footerView addSubview:downImageView];
    if (isShowCell) {
        downImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        downImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenWidth, 40);
    button.tag = CTargetTag + section;
    [button addTarget:self action:@selector(footerAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    return footerView;
}

- (void)footerAction:(UIButton *)button {

    NSLog(@"%ld", button.tag);
    
    if (button.tag - CTargetTag == 0) {
        isShowCell = !isShowCell;
        
        [_targetTableView reloadSections:[NSIndexSet indexSetWithIndex:(button.tag - CTargetTag)]
                        withRowAnimation:UITableViewRowAnimationFade];
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    

}






















































@end
