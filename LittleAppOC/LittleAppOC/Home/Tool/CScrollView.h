//
//  CScrollView.h
//  LittleAppOC
//
//  Created by CaoYicheng on 2017/1/29.
//  Copyright © 2017年 CYC. All rights reserved.
//

#import <UIKit/UIKit.h>

// 当一个滑动视图里还有其他子滑动视图，那么可以设定滑动视图的类型，以在调用代理方法的时候区分
typedef enum : NSUInteger {
    CScrollViewSuper,   // 父视图
    CScrollViewSub,     // 子视图
    CScrollViewThird    // 超子视图
} CScrollViewType;

@interface CScrollView : UIScrollView

@property (assign, nonatomic) CScrollViewType *scrollType;


@end
