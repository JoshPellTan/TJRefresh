//
//  TJRefreshAnimation.h
//  TJRefresh
//
//  Created by TanJian on 17/5/23.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TJRefreshAnimation : UIView

@property (nonatomic, copy) void(^handle)();


//header是否正在刷新
@property (nonatomic, assign) BOOL animating;

#pragma mark - 开始动画
-(void)startAnimation;
#pragma mark - 停止动画
- (void)endRefreshing;

@end
