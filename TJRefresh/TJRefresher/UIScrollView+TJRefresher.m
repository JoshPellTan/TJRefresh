//
//  UIScrollView+TJRefresher.m
//  TJRefresh
//
//  Created by TanJian on 17/5/24.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "UIScrollView+TJRefresher.h"
#import "TJRefreshHeader.h"
#import "TJRefreshFooter.h"
#import <objc/runtime.h>

@implementation UIScrollView (TJRefresher)

- (void)addRefreshHeaderWithHandle:(void (^)())handle {
    TJRefreshHeader * header = [[TJRefreshHeader alloc]init];
    header.handle = handle;
    self.header = header;
    
}

-(void)addLoadMoreFooterWithHandle:(void (^)())handle{
    TJRefreshFooter * footer = [[TJRefreshFooter alloc]init];
    footer.handle = handle;
    self.footer = footer;
}

#pragma mark - Associate
static const void *TJRefreshHeaderKey = &TJRefreshHeaderKey;
- (void)setHeader:(TJRefreshHeader *)header {
    
    if (self.header != header) {
        [self.header removeFromSuperview];
        [self insertSubview:header atIndex:0];
    }
    objc_setAssociatedObject(self, TJRefreshHeaderKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TJRefreshHeader *)header {
    return objc_getAssociatedObject(self, &TJRefreshHeaderKey);
}

static const void *TJRefreshFooterKey = &TJRefreshFooterKey;
-(void)setFooter:(TJRefreshFooter *)footer{
    
    if (self.footer != footer) {
        [self.footer removeFromSuperview];
        [self insertSubview:footer atIndex:0];

    }
    objc_setAssociatedObject(self, TJRefreshFooterKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(TJRefreshFooter *)footer{
    return objc_getAssociatedObject(self, &TJRefreshFooterKey);
}

@end
