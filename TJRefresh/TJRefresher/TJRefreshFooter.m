//
//  TJRefreshFooter.m
//  TJRefresh
//
//  Created by TanJian on 17/5/25.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJRefreshFooter.h"
#import <CoreText/CoreText.h>
#import "UIScrollView+TJRefresher.h"

const CGFloat TJLoaderPullLen = 64.0;


@interface TJRefreshFooter ()

@property (nonatomic, weak  ) UIScrollView * scrollView;
@property (nonatomic, assign) CGFloat layerStrokenValue;

@end

@implementation TJRefreshFooter

-(instancetype)init{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, 64, 64)]) {
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
    
}



#pragma mark - Override
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        
        [self removeObserver];
        self.scrollView = (UIScrollView *)newSuperview;
        
        [self addObserver];
    }else {
        [self removeObserver];
    }
}

-(void)addObserver{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserver{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        self.layerStrokenValue = self.scrollView.contentOffset.y;
    }else if([keyPath isEqualToString:@"contentSize"]){
        
        self.center = CGPointMake(self.scrollView.bounds.size.width*0.5, self.scrollView.contentSize.height + 32);
    }
}

//外部调用方法，控layer填充比
-(void)setLayerStrokenValue:(CGFloat)layerStrokenValue{
    
    _layerStrokenValue = layerStrokenValue;
    
    CGFloat normalScrollLen = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
    if (self.scrollView.contentSize.height <= 0) {
        normalScrollLen = 0;
    }
    CGFloat value = (layerStrokenValue-normalScrollLen)/TJLoaderPullLen;
    
    //如果不是正在加载，则渐变动画
    if (!self.animating) {

        NSLog(@"footer的具体动画");
    }
    
    //如果到达临界点，则执行加载动画
    if (value > 1 && !self.animating && !self.scrollView.dragging) {
        [self startAnimation];
        if (self.handle) {
            self.handle();
        }
    }
    
}

-(void)startAnimation{
    NSLog(@"开始加载动画");
    self.animating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.bottom += TJLoaderPullLen;
        self.scrollView.contentInset = inset;
    }completion:^(BOOL finished) {
        
        
    }];
    
}

#pragma mark - Stop
- (void)endLoading {
    
    [self stopAnimation];
    NSLog(@"结束加载");
}

#pragma mark - stopAnimation
-(void)stopAnimation{
    
    NSLog(@"结束加载动画");
    if (!self.animating) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.bottom -= TJLoaderPullLen;
        self.scrollView.contentInset = inset;
        
    } completion:^(BOOL finished) {
        
        self.animating = NO;
        
    }];
    
}
#pragma mark - Stop
- (void)endRefreshing {
    
    [self stopAnimation];
    NSLog(@"结束刷新");
}





@end
