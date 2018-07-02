//
//  MDSegmentView.h
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSegmentView : UIView

/**
 *  带数据初始化
 *  titleArr : 标题数组
 */
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

/**
 *  隐藏底部分割线
 */
@property (nonatomic, assign) BOOL hideBottomLine;

/**
 *  切换事件
 */
@property (nonatomic, strong) void (^segmentViewChangeBlock) (NSInteger index);

/**
 *  设置选中
 */
- (void)selectedSegmentViewPage:(NSInteger)page;

/**
 *  设置未读角标
 *
 *  index : 位置
 *  hide : 控制显隐
 */
- (void)setupSegmentViewUnreadBtnWithIndex:(NSInteger)index hide:(BOOL)isHide;

@end
