//
//  LSWaterWaveView.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LSWaterWaveView : UIView

@property (nonatomic, strong) UIColor *firstWaveColor;      /**< 第一个波浪颜色 */
@property (nonatomic, strong) UIColor *secondWaveColor;     /**< 第二个波浪颜色 */
@property (nonatomic, assign) CGFloat percent;              /**< 百分比 */
@property (nonatomic, assign) CGSize  containerSize;        /**< 波浪容器尺寸(默认:W:40 H:40) */
@property (nonatomic, assign) CGFloat waveAmplitude;        /**< 波纹振幅(默认:variable*2) */
@property (nonatomic, assign) CGFloat waveCycle;            /**< 波纹周期(默认:1.3f) */
@property (nonatomic, assign) CGFloat waveSpeed;            /**< 波纹速度(默认:0.4f/M_PI) */
@property (nonatomic, assign) CGFloat waveGrowth;           /**< 波纹上升速度(默认:0.6f) */
@property (nonatomic, assign) CGFloat offsetX;              /**< 波浪x位移(默认:0.f) */
@property (nonatomic, assign) CGFloat currentWavePointY;    /**< 当前波浪上限高度Y（高度从大到小 坐标系向下增长，即值越大，波浪越低 ）*/

- (void)startWave;

- (void)stopWave;

- (void)reset;

@end


/**************** 波浪动画核心思想 ****************
 
 要做出这个效果首先要懂得正弦函数
 y = A sin（ωx+φ）+ C
 A 表示振幅，也就是使用这个变量来调整波浪的高度
 ω 表示周期，也就是使用这个变量来调整在屏幕内显示的波浪的数量
 φ 表示波浪横向的偏移，也就是使用这个变量来调整波浪的流动
 C 表示波浪纵向的位置，也就是使用这个变量来调整波浪在屏幕中竖直的位置。
 
 y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
 
**************** 波浪动画核心思想 ****************/
