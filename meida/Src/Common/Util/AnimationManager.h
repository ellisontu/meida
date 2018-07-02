//
//  AnimationManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationManager : NSObject <CAAnimationDelegate>

/*  闪烁动画
 *  time:闪烁间隔
 *  repeatCount = MAXFLOAT（永久闪烁）重复次数
 */
+ (CABasicAnimation *)opacityForever_Animation:(CGFloat)time repeatCount:(CGFloat)repeatCount;

/*  横向、纵向移动
 *  time:
 *  x,y : 终点
 */
+ (CABasicAnimation *)moveX:(CGFloat)time X:(NSNumber *)x;

+ (CABasicAnimation *)moveY:(CGFloat)time Y:(NSNumber *)y;

/*  缩放
 *  time:
 *  Multiple: fromValue
 *  orginMultiple: toValue
 *  repeatTimes: 重复次数
 */
+ (CABasicAnimation *)scale:(NSNumber *)multiple orgin:(NSNumber *)orginMultiple durTimes:(CGFloat)time Rep:(CGFloat)repertTimes;

/*  组合动画
 *  time:
 *  animationAry: 动画组
 *  repeatTimes: 重复次数
 */
+ (CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(CGFloat)time Rep:(CGFloat)repeatTimes;

/*  路径动画
 *  path: 路径
 *  time:
 *  repeatTimes: 重复次数
 */
+ (CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(CGFloat)time Rep:(CGFloat)repeatTimes;

/*  旋转动画
 *  time:
 *  degree: 角度
 *  direction: 方向
 *  repeatTimes: 重复次数
 */
+ (CABasicAnimation *)rotation:(CGFloat)time degree:(CGFloat)degree direction:(CGFloat)direction repeatCount:(CGFloat)repeatCount;

/**
 *  点赞动画
 *
 *  @param startPoint 起始点
 *  @param endPoint   结束点
 *  @param superView  父view
 *  @param flag       动画完成后回调
 */
+ (void)goToLikeAnimationWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint superView:(UIView *)superView finished:(void (^)(BOOL finished))flag;


#pragma mark - 粒子动画 -
/**
 *  直播点赞动画
 *
 *  @param emitterPosition 粒子发射器位置
 *
 *  @return CAEmitterLayer
 */
+ (CAEmitterLayer *)LiveRoomThumbUpAnimationEmitterPosition:(CGPoint)emitterPosition;




@end
