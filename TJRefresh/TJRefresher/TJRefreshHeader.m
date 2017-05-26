//
//  TJRefreshHeader.m
//  TJRefresh
//
//  Created by TanJian on 17/5/23.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJRefreshHeader.h"
#import <CoreText/CoreText.h>
#import "CALayer+TJFrame.h"
#import "UIScrollView+TJRefresher.h"

const CGFloat TJRefreshPullLen = 64.0;
const CGFloat TJRefreshHeaderHeight = 30.0;
const CGFloat TJCornerRadius = 4;
const CGFloat TJMargin = 3;
const CGFloat TJSquareW = 10;

const CGFloat shortLineWidth = TJRefreshHeaderHeight-TJSquareW-TJMargin*3;

@interface TJRefreshHeader ()

@property (nonatomic, weak  ) UIScrollView * scrollView;
@property (nonatomic, assign) CGFloat layerStrokenValue;

@property (nonatomic, strong) CAShapeLayer *draftShapeLayer;
@property (nonatomic, strong) CAShapeLayer *squareShapeLayer;
@property (nonatomic, strong) CAShapeLayer *lineShapeLayer1;//区分长短线
@property (nonatomic, strong) CAShapeLayer *lineShapeLayer2;//区分长短线
@property (nonatomic, strong) CALayer *draftLayer;
@property (nonatomic, strong) CALayer *squareLayer;
@property (nonatomic, strong) CALayer *lineLayer1;//区分长短线
@property (nonatomic, strong) CALayer *lineLayer2;//区分长短线

@property (nonatomic, strong) CALayer *containerLayer;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSInteger animationStateNum;
@property (nonatomic, strong) NSArray *squeraLayerFramesArr;
@property (nonatomic, strong) NSArray *line1LayerFramesArr;
@property (nonatomic, strong) NSArray *line2LayerFramesArr;

//文字demolayer
@property (nonatomic, strong) CAShapeLayer *wordsShapeLayer;
@property (nonatomic, strong) CALayer *wordsLayer;

@end

@implementation TJRefreshHeader

-(instancetype)init{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, TJRefreshPullLen, TJRefreshPullLen)]) {
        [self setup1];//今日头条下拉效果
        //[self setup2];//文字书写下拉效果
        
    }
    return self;
    
}

//仿今日头条下拉加载
-(void)setup1{

    self.backgroundColor = [UIColor greenColor];
    [self.layer addSublayer:self.containerLayer];
    //外框贝塞尔曲线
    UIBezierPath *draftPath = [[UIBezierPath alloc]init];
    
    [draftPath moveToPoint:CGPointMake(self.containerLayer.width-TJCornerRadius, 0)];
    
    [draftPath addLineToPoint:CGPointMake(TJCornerRadius, 0)];//添加直线
    [draftPath addArcWithCenter:CGPointMake(TJCornerRadius, TJCornerRadius) radius:TJCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];//添加圆弧
    
    [draftPath addLineToPoint:CGPointMake(0, self.containerLayer.height-TJCornerRadius)];
    [draftPath addArcWithCenter:CGPointMake(TJCornerRadius, self.containerLayer.height - TJCornerRadius) radius:TJCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    [draftPath addLineToPoint:CGPointMake(self.containerLayer.width-TJCornerRadius, self.containerLayer.height)];
    [draftPath addArcWithCenter:CGPointMake(self.containerLayer.width - TJCornerRadius, self.containerLayer.height - TJCornerRadius) radius:TJCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    
    [draftPath addLineToPoint:CGPointMake(self.containerLayer.width, TJCornerRadius)];
    [draftPath addArcWithCenter:CGPointMake(self.containerLayer.width - TJCornerRadius, TJCornerRadius) radius:TJCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    
    self.draftShapeLayer = [CAShapeLayer new];
    self.draftLayer = [CALayer new];
    self.draftLayer.frame = CGRectMake( 0, 0, self.containerLayer.width, self.containerLayer.height);
    [self setupLayer:self.draftLayer shapeLayer:self.draftShapeLayer  path:draftPath.CGPath];
    
    //方框贝塞尔曲线
    UIBezierPath *squarPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, TJSquareW, TJSquareW) cornerRadius:1];
    
    self.squareShapeLayer = [CAShapeLayer new];
    self.squareLayer = [CALayer new];
    self.squareLayer.frame = CGRectMake( TJMargin, TJMargin, TJSquareW, TJSquareW);
    [self setupLayer:self.squareLayer shapeLayer:self.squareShapeLayer path:squarPath.CGPath];
    
    //三条短横线部分
    CGFloat shortLineLeft = TJMargin*2 + TJSquareW;
    CGFloat longLineW = self.containerLayer.width - TJMargin*2;
    CGFloat shortLineW = self.containerLayer.width - TJMargin*3-self.squareLayer.width;
    CGFloat lineMargin = (TJSquareW-3)/2;//有时候除不尽，系统在设置frame时会取整，导致不准确，下面加个0.5解决
    
    UIBezierPath *linePath1 = [[UIBezierPath alloc]init];
    for (int i = 0; i<3; i++) {
        
        [linePath1 moveToPoint:CGPointMake(0,0.5+i*(lineMargin+1))];
        [linePath1 addLineToPoint:CGPointMake(longLineW, 0.5+i*(lineMargin+1))];
    }
    self.lineShapeLayer1 = [CAShapeLayer new];
    self.lineLayer1 = [CALayer new];
    self.lineLayer1.masksToBounds = YES;
    self.lineLayer1.frame = CGRectMake(shortLineLeft, TJMargin, shortLineW, TJSquareW);
    [self setupLayer:self.lineLayer1 shapeLayer:self.lineShapeLayer1 path:linePath1.CGPath];
    
    //长横线部分
    CGFloat longLineLeft = TJMargin;
    UIBezierPath *linePath2 = [[UIBezierPath alloc]init];
    
    for (int i = 0; i<3; i++) {
        
        [linePath2 moveToPoint:CGPointMake(0, 0.5+i*(lineMargin+1))];
        [linePath2 addLineToPoint:CGPointMake(longLineW, 0.5+i*(lineMargin+1))];
    }
    
    self.lineShapeLayer2 = [CAShapeLayer new];
    self.lineLayer2 = [CALayer new];
    self.lineLayer2.masksToBounds = YES;
    self.lineLayer2.frame = CGRectMake(longLineLeft, TJMargin*2+TJSquareW,longLineW, TJSquareW);
    [self setupLayer:self.lineLayer2 shapeLayer:self.lineShapeLayer2 path:linePath2.CGPath];
    
}


//文字通过贝塞尔曲线绘制
-(void)setup2{
    
    [self.layer addSublayer:self.containerLayer];
    //文字layer
    UIBezierPath *wordPath = [self bezierPathWithString:@"WithWith"];
    self.wordsShapeLayer = [CAShapeLayer new];
    self.wordsShapeLayer.geometryFlipped = YES;
    self.wordsShapeLayer.frame = CGRectMake(0, self.containerLayer.height*0.5-20, self.containerLayer.width, 40);
    [self setupLayer:self.wordsLayer shapeLayer:self.wordsShapeLayer path:wordPath.CGPath];
    
}

//文字贝塞尔曲线
-(UIBezierPath *)bezierPathWithString:(NSString *)string{
    
    CGMutablePathRef paths = CGPathCreateMutable();
    
    NSAttributedString *atrStr = [[NSAttributedString alloc]initWithString:string attributes:@{(__bridge NSString *)kCTFontAttributeName:[UIFont systemFontOfSize:21]}];
    CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)atrStr);
    CFArrayRef wordArrRef = CTLineGetGlyphRuns(lineRef);
    
    for (int wordIndex = 0; wordIndex < CFArrayGetCount(wordArrRef); wordIndex++) {
        
        const void *word = CFArrayGetValueAtIndex(wordArrRef, wordIndex);
        CTRunRef runRef = (CTRunRef)word;
        
        const void *CTFontName = kCTFontAttributeName;
        
        const void *wordFontC = CFDictionaryGetValue(CTRunGetAttributes(runRef), CTFontName);
        CTFontRef wordFontRef = (CTFontRef)wordFontC;
        
        CGFloat width =  self.bounds.size.width;
        
        int temp = 0;
        CGFloat offset = 0;
        
        for (int i = 0; i < CTRunGetGlyphCount(runRef); i++) {
            
            CFRange range = CFRangeMake(i, 1);
            CGGlyph glyph = 0;
            CTRunGetGlyphs(runRef, range, &glyph);
            CGPoint position = CGPointZero;
            CTRunGetPositions(runRef, range, &position);
            
            CGFloat tempX = position.x;
            int tempW = (int)tempX/width;
            CGFloat temp1 = 0;
            
            if (tempW > temp1) {
                temp = tempW;
                offset = position.x - (CGFloat)temp;
            }
            
            CGPathRef path = CTFontCreatePathForGlyph(wordFontRef, glyph, nil);
            CGFloat x = position.x - (CGFloat)temp*width - offset;
            CGFloat y = position.y - (CGFloat)temp*80;
            CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
            CGPathAddPath(paths, &transform, path);
            
            CGPathRelease(path);
            
        }
        
        CFRelease(runRef);
        CFRelease(wordFontRef);
        
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath  appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
    
    CGPathRelease(paths);
    
    return bezierPath;
    
}

#pragma mark 配置layer

-(void)setupLayer:(CALayer *)layer shapeLayer:(CAShapeLayer *)shapeLayer path:(CGPathRef )path{
 
    shapeLayer.path = path;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0;
    
    [layer addSublayer:shapeLayer];
    [self.containerLayer addSublayer:layer];
}

//外部调用方法，控layer填充比
-(void)setLayerStrokenValue:(CGFloat)layerStrokenValue{
    
    _layerStrokenValue = layerStrokenValue;
    CGFloat value = (layerStrokenValue-(TJRefreshPullLen-TJRefreshHeaderHeight)*0.5)/((TJRefreshPullLen+TJRefreshHeaderHeight)*0.5);
    
    //如果不是正在刷新，则渐变动画
    if (!self.animating) {
        
        self.draftShapeLayer.strokeEnd = value;
        self.squareShapeLayer.strokeEnd = value;
        self.lineShapeLayer1.strokeEnd = value*2;
        self.lineShapeLayer2.strokeEnd = (value-0.5)*2;
        self.wordsShapeLayer.strokeEnd = value;

    }
    //如果到达临界点，则执行刷新动画
    if (value > 1 && !self.animating && !self.scrollView.dragging) {
        [self startAnimation];
        if (self.handle) {
            self.handle();
        }
    }
    
}

#pragma mark - Override
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        
        [self removeObserver];
        self.scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(self.scrollView.bounds.size.width*0.5, -TJRefreshPullLen*0.5);
       
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
        
        self.layerStrokenValue = - self.scrollView.contentOffset.y - self.scrollView.contentInset.top;
    }else if ([keyPath isEqualToString:@"contentSize"]){
        NSLog(@"%f",self.scrollView.contentInset.top);
        
    }
}

#pragma mark - startAnimation
-(void)startAnimation{
    NSLog(@"开始刷新动画");
    self.animating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top += TJRefreshPullLen;
        self.scrollView.contentInset = inset;
    }completion:^(BOOL finished) {
        
        _animationStateNum = 0;
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animationTimerAction) userInfo:nil repeats:YES];
        
    }];
    
}

-(void)animationTimerAction{
    
    _animationStateNum++;
    
    [self checkFrameWithAnimationStateNum:_animationStateNum];
    
}

-(void)checkFrameWithAnimationStateNum:(NSInteger)animationStateNum{
    
    NSInteger temp = animationStateNum%4;
    NSLog(@"%ld",temp);
    NSValue *squeraRectValue = self.squeraLayerFramesArr[temp];
    CGRect squeraRect = [squeraRectValue CGRectValue];
    NSValue *line1RectValue = self.line1LayerFramesArr[temp];
    CGRect line1Rect = [line1RectValue CGRectValue];
    NSValue *line2RectValue = self.line2LayerFramesArr[temp];
    CGRect line2Rect = [line2RectValue CGRectValue];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.squareLayer.frame = squeraRect;
        self.lineLayer1.frame = line1Rect;
        self.lineLayer2.frame = line2Rect;
        
    }];
}


#pragma mark - stopAnimation
-(void)stopAnimation{
    NSLog(@"结束刷新动画");
    if (!self.animating) {
        return;
    }

    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top -= TJRefreshPullLen;
        self.scrollView.contentInset = inset;
    } completion:^(BOOL finished) {
        
        self.animating = NO;
        [self.animationTimer invalidate];
        
        [self checkFrameWithAnimationStateNum:0];
        
    }];

}

#pragma mark - Stop
- (void)endRefreshing {
    
    [self stopAnimation];
    NSLog(@"结束刷新");
}

#pragma mark lazy
-(CALayer *)containerLayer{
    
    if (!_containerLayer) {
        _containerLayer = [CALayer new];
        CGFloat x = (TJRefreshPullLen-TJRefreshHeaderHeight)*0.5;
        CGFloat y = x;
        _containerLayer.frame = CGRectMake(x, y, TJRefreshHeaderHeight, TJRefreshHeaderHeight);
        
    }
    
    return _containerLayer;
}
-(NSArray *)squeraLayerFramesArr{
    if (!_squeraLayerFramesArr) {
        _squeraLayerFramesArr = @[[NSValue valueWithCGRect:CGRectMake( TJMargin, TJMargin, TJSquareW, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJRefreshHeaderHeight-TJMargin-TJSquareW, TJMargin, TJSquareW, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJRefreshHeaderHeight-TJMargin-TJSquareW, TJRefreshHeaderHeight-TJMargin -TJSquareW, TJSquareW, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJMargin, TJRefreshHeaderHeight-TJMargin-TJSquareW, TJSquareW, TJSquareW)]];
    }
    return _squeraLayerFramesArr;
}
-(NSArray *)line1LayerFramesArr{
    if (!_line1LayerFramesArr) {
        _line1LayerFramesArr = @[[NSValue valueWithCGRect:CGRectMake( TJRefreshHeaderHeight-TJMargin-shortLineWidth, TJMargin, shortLineWidth, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJMargin, TJRefreshHeaderHeight-TJMargin-TJSquareW, TJRefreshHeaderHeight-TJMargin*2, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJMargin,  TJRefreshHeaderHeight-TJMargin-TJSquareW, shortLineWidth, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJMargin, TJMargin, TJRefreshHeaderHeight-TJMargin*2, TJSquareW)]];
    }
    return _line1LayerFramesArr;
}
-(NSArray *)line2LayerFramesArr{
    if (!_line2LayerFramesArr) {
        _line2LayerFramesArr = @[[NSValue valueWithCGRect:CGRectMake( TJMargin, TJRefreshHeaderHeight-TJMargin-TJSquareW, TJRefreshHeaderHeight-TJMargin*2, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJMargin,  TJMargin, shortLineWidth, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJMargin, TJMargin, TJRefreshHeaderHeight-TJMargin*2, TJSquareW)],[NSValue valueWithCGRect:CGRectMake( TJRefreshHeaderHeight-TJMargin-shortLineWidth, TJRefreshHeaderHeight-TJMargin-TJSquareW, shortLineWidth, TJSquareW)]];
    }
    return _line2LayerFramesArr;
}

@end
