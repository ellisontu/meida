//
//  MDRefreshGifFooter.m
//  meida
//
//  Created by ToTo on 2018/6/25.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDRefreshGifFooter.h"

@implementation MDRefreshGifFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    
    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    self.stateLabel.textColor = kDefaultSeparationLineColor;
    
    //    // 设置普通状态的动画图片
    //    NSMutableArray *idleImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i < 13; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%zd", i]];
    //        [idleImages addObject:image];
    //    }
    //    [self setImages:idleImages forState:MJRefreshStateIdle];
    //
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    NSMutableArray *refreshingImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i < 13; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%zd", i]];
    //        [refreshingImages addObject:image];
    //    }
    //    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    //
    //    // 设置正在刷新状态的动画图片
    //    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

#pragma mark 在这里设置子控件的位置和尺寸
//- (void)placeSubviews
//{
//    [super placeSubviews];
//
//    self.gifView.center = CGPointMake(self.mj_w * 0.2, self.mj_h - self.gifView.mj_h * 0.5);
//}

@end
