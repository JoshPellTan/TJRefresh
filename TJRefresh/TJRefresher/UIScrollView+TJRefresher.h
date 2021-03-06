//
//  UIScrollView+TJRefresher.h
//  TJRefresh
//
//  Created by TanJian on 17/5/24.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJRefreshHeader;
@class TJRefreshFooter;

@interface UIScrollView (TJRefresher)

@property (nonatomic, strong, readonly) TJRefreshHeader * header;

@property (nonatomic, strong, readonly) TJRefreshFooter * footer;

- (void)addRefreshHeaderWithHandle:(void (^)())handle;
- (void)addLoadMoreFooterWithHandle:(void (^)())handle;


@end
