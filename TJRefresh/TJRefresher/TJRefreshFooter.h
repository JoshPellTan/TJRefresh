//
//  TJRefreshFooter.h
//  TJRefresh
//
//  Created by TanJian on 17/5/25.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJRefreshFooter : UIView

@property (nonatomic, copy) void(^handle)();

//header是否正在刷新
@property (nonatomic, assign) BOOL animating;

-(void)startAnimation;
-(void)endLoading;

@end
