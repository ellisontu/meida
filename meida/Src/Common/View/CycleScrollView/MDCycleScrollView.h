//
//  MDCycleScrollView.h
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollViewContolAliment) {
    ContolAlimentRight,     /**< 居右对齐 */
    ContolAlimentCenter     /**< 居中对齐 */
};

typedef NS_ENUM(NSInteger, ScrollViewContolStyle) {
    ContolStyleClassic,        /**< 系统自带经典样式 */
    ContolStyleAnimated,       /**< 动画效果pagecontrol */
    ContolStyleNone            /**< 不显示pagecontrol */
};

@class MDCycleScrollView;

@protocol MDCycleScrollViewDelegate <NSObject>

@optional

- (void)cycleScrollView:(MDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index; /** 点击图片回调 */
- (void)cycleScrollView:(MDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;     /** 图片滚动回调 */

- (Class)customCollectionViewCellClassForCycleScrollView:(MDCycleScrollView *)view; /** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(MDCycleScrollView *)view;   /** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */

@end

@interface MDCycleScrollView : UIView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<MDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;   /** 初始轮播图（推荐使用） */

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLStringsGroup;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup;  /** 本地图片轮播初始化方式 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup;    /** 本地图片轮播初始化方式2,infiniteLoop:是否无限循环 */

@property (nonatomic, strong) NSArray   *imageURLStringsGroup;        /** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray   *titlesGroup;                 /** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray   *localizationImageNamesGroup; /** 本地图片数组 */

@property (nonatomic, assign) CGFloat   autoScrollTimeInterval;     /** 自动滚动间隔时间,默认2s */
@property (nonatomic,assign) BOOL       infiniteLoop;               /** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL       autoScroll;                 /** 是否自动滚动,默认Yes */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;  /** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, weak) id<MDCycleScrollViewDelegate> delegate;
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);    /** block方式监听点击 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);    /** block方式监听滚动 */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;   /** 可以调用此方法手动控制滚动到哪一个index */
- (void)adjustWhenControllerViewWillAppera;/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode; /** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, strong) UIImage           *placeholderImage;  /** 占位图，用于网络未加载到图片时 */
@property (nonatomic, assign) BOOL              showPageControl;    /** 是否显示分页控件 */
@property(nonatomic,  assign) BOOL              hidesForSinglePage; /** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property (nonatomic, assign) BOOL              onlyDisplayText;    /** 只展示文字轮播 */

@property (nonatomic, assign) ScrollViewContolStyle ControlStyle;   /** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) ScrollViewContolAliment ControlAliment;/** 分页控件位置 */
@property (nonatomic, assign) CGFloat   pageControlBottomOffset;      /** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat   pageControlRightOffset;   /** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGSize    pageControlDotSize;        /** 分页控件小圆标大小 */
@property (nonatomic, strong) UIColor   *currentPageDotColor;     /** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor   *pageDotColor;            /** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIImage   *currentPageDotImage;     /** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage   *pageDotImage;            /** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIColor   *titleLabelTextColor;     /** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIFont    *titleLabelTextFont;     /** 轮播文字label字体大小 */
@property (nonatomic, strong) UIColor   *titleLabelBackgroundColor; /** 轮播文字label背景颜色 */
@property (nonatomic, assign) CGFloat   titleLabelHeight;       /** 轮播文字label高度 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;  /** 轮播文字label对齐方式 */

- (void)disableScrollGesture;   /** 滚动手势禁用（文字轮播较实用） */
+ (void)clearImagesCache;       /** 清除图片缓存（此次升级后统一使用MDWebImage管理图片加载和缓存）  */
- (void)clearCache;             /** 清除图片缓存（兼容旧版本方法） */

@end


@interface MDCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor           *titleLabelTextColor;
@property (nonatomic, strong) UIFont            *titleLabelTextFont;
@property (nonatomic, strong) UIColor           *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat           titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment   titleLabelTextAlignment;
@property (nonatomic, assign) BOOL              hasConfigured;
@property (nonatomic, assign) BOOL              onlyDisplayText;    /**< 只展示文字轮播 */

@end
