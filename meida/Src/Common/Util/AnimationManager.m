//
//  AnimationManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "AnimationManager.h"
#import <POP.h>

static NSString * const kAnimationWithKeyPathRotation_X = @"transform.rotation.x";      /**< The rotation, in radians, in the x axis. */
static NSString * const kAnimationWithKeyPathRotation_Y = @"transform.rotation.y";      /**< The rotation, in radians, in the y axis. */
static NSString * const kAnimationWithKeyPathRotation_Z = @"transform.rotation.z";      /**< The rotation, in radians, in the z axis. */
static NSString * const kAnimationWithKeyPathRotation   = @"transform.rotation";        /**< The rotation, in radians, in the z axis. This is identical to setting the rotation.z field */
static NSString * const kAnimationWithKeyPathScale_X    = @"transform.scale.x";         /**< Scale factor for the x axis. */
static NSString * const kAnimationWithKeyPathScale_Y    = @"transform.scale.y";         /**< Scale factor for the y axis. */
static NSString * const kAnimationWithKeyPathScale_Z    = @"transform.scale.z";         /**< Scale factor for the z axis. */
static NSString * const kAnimationWithKeyPathScale      = @"transform.scale";           /**< Average of all three scale factors */
static NSString * const kAnimationWithKeyPathTranslation_X = @"transform.translation.x";/**< Translate in the x axis */
static NSString * const kAnimationWithKeyPathTranslation_Y = @"transform.translation.y";/**< Translate in the y axis */
static NSString * const kAnimationWithKeyPathTranslation_Z = @"transform.translation.z";/**< Translate in the z axis */
static NSString * const kAnimationWithKeyPathTranslation   = @"transform.translation";  /**< Translate in the x and y axis. Value is an CGPoint*/
static NSString * const kAnimationWithKeyPathOpacity    = @"opacity";       /**< 闪烁 */
static NSString * const kAnimationWithKeyPathPosition   = @"position";      /**< 路径 */
static NSString * const kAnimationWithKeyPathTransform  = @"transform";     /**< 旋转 */



@implementation AnimationManager

#pragma mark ====== 闪烁的动画 ======
+ (CABasicAnimation *)opacityForever_Animation:(CGFloat)time repeatCount:(CGFloat)repeatCount
{
    // time:闪烁间隔  repeatCount = MAXFLOAT（永久闪烁）
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //这是透明度值得变化。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    //是否自动倒退
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount =  repeatCount;
    //动画执行完毕之后不删除动画
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //没有的话是均匀的动画。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

#pragma mark ====== 横向、纵向移动 ======
+ (CABasicAnimation *)moveX:(CGFloat)time X:(NSNumber *)x
{
    // .y 的话就向下移动。
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x" ];
    
    animation.toValue = x;
    
    animation.duration = time;
    //是否删除动画（若为 YES 则动画完成后返回设定的 frame）
    animation.removedOnCompletion = NO;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

+ (CABasicAnimation *)moveY:(CGFloat)time Y:(NSNumber *)y
{
    // .y 的话就向下移动。
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y" ];
    
    animation.toValue = y;
    
    animation.duration = time;
    //是否删除动画（若为 YES 则动画完成后返回设定的 frame）
    animation.removedOnCompletion = NO;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

#pragma mark ====== 缩放 ======
+ (CABasicAnimation *)scale:(NSNumber *)multiple orgin:(NSNumber *)orginMultiple durTimes:(CGFloat)time Rep:(CGFloat)repertTimes
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale" ];
    
    animation.fromValue = multiple;
    
    animation.toValue = orginMultiple;
    //是否自动倒退
    animation.autoreverses = YES;
    
    animation.repeatCount = repertTimes;
    
    animation.duration = time; // 不设置时候的话，有一个默认的缩放时间.
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

#pragma mark ====== 组合动画 ======
+ (CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(CGFloat)time Rep:(CGFloat)repeatTimes
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    
    animation.animations = animationAry;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;
    
    animation.repeatCount = repeatTimes;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

#pragma mark ====== 路径动画 ======
+ (CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(CGFloat)time Rep:(CGFloat)repeatTimes
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path = path;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //是否自动倒退
    animation.autoreverses = NO;
    
    animation.duration = time;
    
    animation.repeatCount = repeatTimes;
    
    return animation;
}

#pragma mark ====== 旋转动画 ======
+ (CABasicAnimation *)rotation:(CGFloat)time degree:(CGFloat)degree direction:(CGFloat)direction repeatCount:(CGFloat)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    
    animation.duration = time;
    //是否自动倒退
    animation.autoreverses = NO;
    
    animation.cumulative = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.repeatCount = repeatCount;
    
    //animation.delegate = self;
    
    return animation;
}


+ (void)goToLikeAnimationWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint superView:(UIView *)superView finished:(void (^)(BOOL finished))isFinished
{
    UIImageView *_kissImageView = [[UIImageView alloc] initWithImage:IMAGE(@"video_kiss_zan")];
    _kissImageView.frame = CGRectMake(0, 0, 43, 43);
    _kissImageView.center = startPoint;
    //_kissImageView.hidden = YES;
    [superView addSubview:_kissImageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        _kissImageView.alpha = 1;
        _kissImageView.width = 86.f;
        _kissImageView.height = 86.f;
        _kissImageView.center = startPoint;
    } completion:^(BOOL finished) {
        CGRect bounds = _kissImageView.bounds;
        bounds.size.width = bounds.size.width - 20;
        bounds.size.height = bounds.size.height - 20;
        _kissImageView.center = startPoint;
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
        animation.springSpeed = 40;
        animation.springBounciness = 20;
        animation.toValue = [NSValue valueWithCGRect:bounds];
        animation.removedOnCompletion = NO;
        [animation setCompletionBlock:^(POPAnimation *animation, BOOL flag) {
            [UIView animateWithDuration:1.f animations:^{
                _kissImageView.width = 28.f;
                _kissImageView.height = 28.f;
                _kissImageView.center = endPoint;
                //_kissImageView.frame = CGRectMake(0, 0, 33, 29);
                _kissImageView.alpha = 0.5f;
            } completion:^(BOOL finished) {
                [_kissImageView removeFromSuperview];
                if (isFinished) {
                     isFinished(YES);
                }
            }];
            
            CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];
            CGMutablePathRef aPath = CGPathCreateMutable();
            CGPathMoveToPoint(aPath, nil, startPoint.x, startPoint.y);
            CGPathAddCurveToPoint(aPath, nil, superView.width * 3/4 + 70, superView.width * 1/4 - 70, superView.width + 70, startPoint.y, endPoint.x, endPoint.y);
            ani.path = aPath;
            CGPathRelease(aPath);
            ani.duration = 1.f;
            ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [_kissImageView.layer addAnimation:ani forKey:@"position"];
        }];
        [_kissImageView.layer pop_addAnimation:animation forKey:@"bounds"];
    }];
}



#pragma mark - CAAnimationDelegate -
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}


#pragma mark ====== 直播点赞动画 ======
+ (CAEmitterLayer *)LiveRoomThumbUpAnimationEmitterPosition:(CGPoint)emitterPosition
{
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    //发射位置
    fireworksEmitter.emitterPosition = emitterPosition;
    //发射源的z坐标位置
    fireworksEmitter.emitterZPosition = -20.f;
    //发射源的大小
    fireworksEmitter.emitterSize	= CGSizeMake(10.f, 10.f);
    //决定粒子形状的深度联系
    //fireworksEmitter.emitterDepth   = 30.f;
    //发射模式
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    //发射源的形状
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    //渲染模式
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    //用于初始化随机数产生的种子 (1 -- 10)
    //fireworksEmitter.seed = (arc4random()%10)+1;
    //自旋转速度
    fireworksEmitter.spin = 0.f;
    //粒子的缩放比例
    fireworksEmitter.scale = 1.f;
    //粒子速度
    fireworksEmitter.velocity = 1.f;
    
    
    // Create the rocket
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 5.0;
    //周围发射角度
    rocket.emissionRange	= M_PI/6;  // some variation in angle
    rocket.velocity			= 300;
    //粒子的速度范围
    //rocket.velocityRange	= 400;
    //粒子y方向的加速度分量
    rocket.yAcceleration	= 275;
    rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
    
    
    NSString *imageName = [NSString stringWithFormat:@"liveRoom_zan_da_%zd", getRandomNumber(1, 12)];
    rocket.contents			= (id) [[UIImage imageNamed:imageName] CGImage];
    rocket.scale			= 0.3;
    //rocket.color			 = [[UIColor redColor] CGColor];
    //rocket.greenRange		 = 1.0;         // different colors
    //rocket.redRange		 = 1.0;
    //rocket.blueRange		 = 1.0;
    rocket.spinRange		= M_PI/2;		// slow spin
    rocket.alphaRange       = 1.0;
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell *burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    //burst.scale			 = 2.5;
    
    //粒子 red 在生命周期内的改变速度
    //burst.redSpeed		 = -1.5;
    //burst.blueSpeed		 = +1.5;
    //burst.greenSpeed		= +1.0;
    burst.lifetime			= 1.35;
    burst.alphaSpeed        = -2.3;
    
    // putting it together
    //fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    //rocket.emitterCells			= [NSArray arrayWithObject:burst];
    
    return fireworksEmitter;
}


#pragma mark - UIView的，翻转、旋转、偏移、翻页、缩放、取反的动画效果 -
//翻转
- (void)animationFlipWithView:(UIView *)animationView
{
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:1];
    //设置动画淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    //设置翻转方向
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:animationView cache:YES];
    [UIView commitAnimations];
}

//旋转
- (void)animationRotateWithView:(UIView *)animationView
{
    //创建一个CGAffineTransform  transform对象
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(animationView.transform, M_PI/6.0);
    [UIView beginAnimations:@"rotate" context:nil ];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [animationView setTransform:transform];
    [UIView commitAnimations];
}

//偏移
-(void)animationMoveWithView:(UIView *)animationView
{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    //改变它的frame的x,y的值
    animationView.frame = CGRectMake(100, 100, 120, 100);
    [UIView commitAnimations];
}

//翻页
-(void)animationCurlUpWithView:(UIView *)animationView
{
    [UIView beginAnimations:@"curlUp" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//指定动画曲线类型，该枚举是默认的，线性的是匀速的
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    //设置翻页的方向
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:animationView cache:YES];
    [UIView commitAnimations];
}

//缩放
-(void)animationScaleWithView:(UIView *)animationView
{
    CGAffineTransform  transform;
    transform = CGAffineTransformScale(animationView.transform, 1.2, 1.2);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    [animationView setTransform:transform];
    [UIView commitAnimations];
}

//取反的动画效果是根据当前的动画取他的相反的动画
-(void)animationInvertWithView:(UIView *)animationView
{
    CGAffineTransform transform;
    transform=CGAffineTransformInvert(animationView.transform);
    
    [UIView beginAnimations:@"Invert" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    //获取改变后的view的transform
    [animationView setTransform:transform];
    [UIView commitAnimations];
}

@end



