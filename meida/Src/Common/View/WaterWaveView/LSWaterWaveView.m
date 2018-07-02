//
//  LSWaterWaveView.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import "LSWaterWaveView.h"

@interface LSWaterWaveView ()
{
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    
    float variable;     /**< 可变参数 更加真实 模拟波纹 */
    BOOL increase;      /**< 增减变化 */
}
@property (nonatomic, strong) CADisplayLink *waveDisplaylink;

@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;

@end

@implementation LSWaterWaveView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

- (void)setContainerSize:(CGSize)containerSize
{
    _containerSize = containerSize;
    waterWaveWidth = containerSize.width;
    waterWaveHeight = containerSize.height / 2.f;
}

- (void)setUp
{
    waterWaveHeight = 40.f/2.f;
    waterWaveWidth  = 40.f;
    
    if (waterWaveWidth > 0) {
        _waveCycle = 1.3f * M_PI / waterWaveWidth;
    }
    
    if (_currentWavePointY <= 0) {
        _currentWavePointY = _containerSize.height;
    }
    
    _firstWaveColor = [UIColor colorWithRed:223/255.0 green:83/255.0 blue:64/255.0 alpha:1];
    _secondWaveColor = [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:1];
    
    _waveGrowth = 0.6f;
    _waveSpeed = 0.4f/M_PI;
    
    [self resetProperty];
}

- (void)resetProperty
{
    _currentWavePointY = waterWaveHeight*2;
    
    variable = 1.6f;
    increase = NO;
    
    _offsetX = 0;
}

- (void)setFirstWaveColor:(UIColor *)firstWaveColor
{
    _firstWaveColor = firstWaveColor;
    _firstWaveLayer.fillColor = firstWaveColor.CGColor;
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor
{
    _secondWaveColor = secondWaveColor;
    _secondWaveLayer.fillColor = secondWaveColor.CGColor;
}

- (void)setPercent:(CGFloat)percent
{
    // 下降
    if (percent < _percent) {
        _waveGrowth = _waveGrowth > 0 ? -_waveGrowth : _waveGrowth;
    }
    // 上升
    else if (percent > _percent) {
        _waveGrowth = _waveGrowth > 0 ? _waveGrowth : -_waveGrowth;
    }
    _percent = percent;
}

- (void)startWave
{
    if (_firstWaveLayer == nil) {
        // 创建第一个波浪Layer
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (_secondWaveLayer == nil) {
        // 创建第二个波浪Layer
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        [self.layer addSublayer:_secondWaveLayer];
    }
    
    if (_waveDisplaylink == nil) {
        // 启动定时调用
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)reset
{
    [self stopWave];
    [self resetProperty];
    
    if (_firstWaveLayer) {
        [_firstWaveLayer removeFromSuperlayer];
        _firstWaveLayer = nil;
    }
    
    if (_secondWaveLayer) {
        [_secondWaveLayer removeFromSuperlayer];
        _secondWaveLayer = nil;
    }
}

- (void)animateWave
{
    if (increase) {
        variable += 0.01;
    }
    else {
        variable -= 0.01;
    }
    
    if (variable <= 1) {
        increase = YES;
    }
    
    if (variable >= 1.6) {
        increase = NO;
    }
    
    _waveAmplitude = variable*2;
}

- (void)getCurrentWave:(CADisplayLink *)displayLink
{
    [self animateWave];
    
    if (_waveGrowth > 0 && _currentWavePointY > 2 * waterWaveHeight * (1-_percent)) {
        // 波浪高度未到指定高度 继续上涨
        _currentWavePointY -= _waveGrowth;
    }
    else if (_waveGrowth < 0 && _currentWavePointY < 2 * waterWaveHeight * (1-_percent)) {
        _currentWavePointY -= _waveGrowth;
    }
    
    // 波浪位移
    _offsetX += _waveSpeed;
    
    [self setCurrentFirstWaveLayerPath];
    
    [self setCurrentSecondWaveLayerPath];
}

- (void)setCurrentFirstWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= waterWaveWidth; x++) {
        // 正弦波浪
        y = _waveAmplitude * sin(_waveCycle * x + _offsetX) + _currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)setCurrentSecondWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪
        y = _waveAmplitude * cos(_waveCycle * x + _offsetX) + _currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)stopWave
{
    if (_waveDisplaylink) {
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
    }
}

- (void)dealloc
{
    [self reset];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
