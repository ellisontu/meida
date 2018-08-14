//
//  MDSegmentScrollView.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  SegmentScroll view

#import <UIKit/UIKit.h>
@class MDSegmentScrollView;

@protocol MDSegmentScrollViewDelegate <NSObject>
@optional
/**
 *  联动 MDSegmentTitleView 的方法
 *
 *  @param segmentScrollView        segmentScrollView
 *  @param progress                 segmentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex            原始视图所在下标
 *  @param targetIndex              目标视图所在下标
 */
- (void)segmentScrollView:(MDSegmentScrollView *)segmentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  给 MDSegmentScrollView 所在控制器提供的方法（根据偏移量来处理返回手势的问题）
 *
 *  @param segmentScrollView        segmentScrollView
 *  @param offsetX                  segmentScrollView 内部视图的偏移量
 */
- (void)segmentScrollView:(MDSegmentScrollView *)segmentScrollView offsetX:(CGFloat)offsetX;

@end




@interface MDSegmentScrollView : UIView

@property (nonatomic, weak) id<MDSegmentScrollViewDelegate> delegateSegmentView;
@property (nonatomic, assign) BOOL isScrollEnabled;
/**
 *  对象方法创建 SGPageContentScrollView
 *
 *  @param frame            frame
 *  @param superControl     当前控制器
 *  @param subControls      子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame superControl:(UIViewController *)superControl subControls:(NSArray *)subControls;
- (void)setSegmentScrollViewCurrentIndex:(NSInteger)currentIndex; /** 给外界提供的方法，根据 MDSegmentTitleView 标题选中时的下标并显示相应的子控制器 */

@end
