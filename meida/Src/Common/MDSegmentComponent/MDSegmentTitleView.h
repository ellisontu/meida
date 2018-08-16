//
//  MDSegmentTitleView.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  SegmentTitle view 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIButton+ConentInsets.h"

#pragma mark -  通用 -> Segment title 配置class #############################################----------
typedef NS_ENUM(NSUInteger, IndicatorStyle){
    IndicatorStyleDefault,    /**< 下划线样式 */
    IndicatorStyleCover,      /**< 遮盖样式 */
    IndicatorStyleFixed,      /**< 固定样式 */
    IndicatorStyleDynamic     /**< 动态样式（仅在 IndicatorScrollStyleDefault 样式下支持） */
};

typedef NS_ENUM(NSUInteger, IndicatorScrollStyle) {
    IndicatorScrollStyleDefault,  /**<  指示器位置跟随内容滚动而改变 */
    IndicatorScrollStyleHalf,     /**<  内容滚动一半时指示器位置改变 */
    IndicatorScrollStyleEnd       /**<  内容滚动结束时指示器位置改变 */
};

typedef NS_ENUM(NSUInteger, BtnScrollStyle) {
    BtnScrollStyleStyleDefault,     /**< 默认样式 */
    BtnScrollStyleStyleCommon       /**< 通用样式 */
};

@interface MDSegmentTitleConfig : NSObject

@property (nonatomic, assign) BOOL      needBounces;            /**< PageTitleView 是否需要弹性效果，默认为 YES */
@property (nonatomic, assign) BOOL      showBottomSeparator;    /**< 是否显示底部分割线，默认为 YES */
@property (nonatomic, strong) UIColor   *bottomSeparatorColor;  /**< PageTitleView 底部分割线颜色，默认为 lightGrayColor */

@property (nonatomic, strong) UIFont    *titleFont;             /**< 标题文字字号大小，默认 15 号字体 */
@property (nonatomic, strong) UIFont    *titleSelectedFont;     /**< 标题文字选中字号大小，默认 15 号字体。* 一旦设置此属性，titleTextZoom 属性将不起作用 */
@property (nonatomic, strong) UIColor   *titleColor;            /**< 普通状态下标题按钮文字的颜色，默认为黑色 */
@property (nonatomic, strong) UIColor   *titleSelectedColor;    /**< 选中状态下标题按钮文字的颜色，默认为红色 */
@property (nonatomic, assign) BOOL      titleGradientEffect;    /**< 是否让标题按钮文字具有渐变效果，默认为 NO */
@property (nonatomic, assign) BOOL      titleTextZoom;          /**< 是否让标题按钮文字具有缩放效果，默认为 NO */
@property (nonatomic, assign) CGFloat   titleTextScaling;       /**< 标题按钮文字缩放比，默认为 0.1f，取值范围 0 ～ 0.3f */
@property (nonatomic, assign) CGFloat   spacingBetweenButtons;  /** 按钮之间的间距，默认为 20.0f */

@property (nonatomic, assign) BOOL      showIndicator;          /**< 是否显示指示器，默认为 YES */
@property (nonatomic, strong) UIColor   *indicatorColor;        /**< 指示器颜色，默认为红色 */
@property (nonatomic, assign) CGFloat   indicatorHeight;        /**< 指示器高度，默认为 2.0f */
@property (nonatomic, assign) CGFloat   indicatorAnimationTime; /**< 指示器动画时间，默认为 0.1f，取值范围 0 ～ 0.3f */
@property (nonatomic, assign) IndicatorStyle indicatorStyle;  /**< 指示器样式，默认为 IndicatorStyleDefault */
@property (nonatomic, assign) CGFloat   indicatorCornerRadius;  /**< 指示器圆角大小，默认为 0f */
@property (nonatomic, assign) CGFloat   indicatorToBottomDistance;  /**< 指示器遮盖样式外的其他样式下指示器与底部之间的距离，默认为 0f */
@property (nonatomic, assign) CGFloat   indicatorBorderWidth;   /**< 指示器遮盖样式下的边框宽度，默认为 0.0f */
@property (nonatomic, strong) UIColor   *indicatorBorderColor;  /**< 指示器遮盖样式下的边框颜色，默认为 clearColor */
@property (nonatomic, assign) CGFloat   indicatorAdditionalWidth; /**< 指示器遮盖、下划线样式下额外增加的宽度，默认为 0.0f；介于标题文字宽度与按钮宽度之间 */
@property (nonatomic, assign) CGFloat   indicatorFixedWidth;    /**< 指示器固定样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置 */
@property (nonatomic, assign) CGFloat   indicatorDynamicWidth;  /**< 指示器动态样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置 */
@property (nonatomic, assign) IndicatorScrollStyle indicatorScrollStyle;  /**< 指示器滚动位置改变样式，默认为 IndicatorScrollStyleDefault */

@property (nonatomic, assign) BtnScrollStyle    btnScrollStyle;     /**< 按钮样式 */
@property (nonatomic, assign) BOOL      showVerticalSeparator;      /**< 是否显示按钮之间的分割线，默认为 NO */
@property (nonatomic, strong) UIColor   *verticalSeparatorColor;    /**< 按钮之间的分割线颜色，默认为红色 */
@property (nonatomic, assign) CGFloat verticalSeparatorReduceHeight;/** 按钮之间的分割线额外减少的高度，默认为 0.0f */

@end

#pragma mark -  通用 -> Segment title 配置class #############################################----------


@class MDSegmentTitleView;

@protocol MDSegmentTitleViewDelegate <NSObject>
/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      PageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(MDSegmentTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex;
@end

@interface MDSegmentTitleView : UIView

@property (nonatomic, assign) NSInteger     selectedIndex;          /**< 选中标题按钮下标，默认为 0 */
@property (nonatomic, assign) NSInteger     resetSelectedIndex;     /**< 重置选中标题按钮下标（用于子控制器内的点击事件改变标题的选中下标）*/


/**
 *  对象方法创建 PageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 *  @param configure        PageTitleView 信息配置
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MDSegmentTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames configure:(MDSegmentTitleConfig *)configure;
/**
 *  设置标题图片及位置样式
 *
 *  @param images       默认图片数组
 *  @param selectedImages       选中时图片数组
 *  @param imagePositionType       图片位置样式
 *  @param spacing      图片与标题文字之间的间距
 */
- (void)setImages:(NSArray *)images selectedImages:(NSArray *)selectedImages imagePositionType:(ContentPositionStyle)imagePositionType spacing:(CGFloat)spacing;

- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;  /**< 给外界提供的方法，获取 PageContent 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)resetTitle:(NSString *)title forIndex:(NSInteger)index; /**<  根据标题下标重置标题文字 */
- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle selectedAttributedTitle:(NSMutableAttributedString *)selectedAttributedTitle forIndex:(NSInteger)index; /**< 根据标题下标设置标题的 attributedTitle 属性 */

@end

