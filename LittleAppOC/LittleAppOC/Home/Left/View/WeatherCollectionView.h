//
//  WeatherCollectionView.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/18.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherCollectionView : UICollectionView

@property (strong, nonatomic) NSArray *weatherArray;
@property (assign, nonatomic) NSInteger currentPage;

@end
