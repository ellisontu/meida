//
//  MDBaseViewController.h
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>
#import "MDRefreshGifHeader.h"
#import "MDRefreshGifFooter.h"

typedef NS_ENUM(NSInteger, MDNavigationType)
{
    NavHide = 330,               /**< 隐藏顶部导航栏 */
    NavOnlyShowBack,             /**< 仅显示回退按钮 */
    NavShowBackAndTitle,         /**< 显示左侧回退按钮及标题 */
    NavOnlyShowRight,            /**< 仅显示右侧按钮 */
    NavShowTitleAndRiht,         /**< 显示标题与右侧按钮 */
    NavOnlyShowTitle,            /**< 尽显示标题 */
    NavShowBackAndTitleAndRight, /**< 显示左侧回退按钮及右侧按钮 */
    NavCustom                    /**< 定制：可设置左右侧按钮及标题，不显示回退按钮 */
};

typedef NS_ENUM(NSUInteger, MDNetStatus) {
    
    NetworkStatusUnknown = 0,
    NetworkStatusNotReachable = 1,
    NetworkStatusReachableWWAN = 2,
    NetworkStatusReachableWiFi = 3,
};


@interface MDBaseViewController : UIViewController

@property (nonatomic, assign) BOOL      isAlwaysHideBackToTopBtn;   /**< 是否总是隐藏返回顶部按钮 */
@property (nonatomic, assign) BOOL      banCanLeft;                 /**< 是否禁掉左滑 YES表示禁掉  如无需禁掉则不需要设置*/
@property (nonatomic, assign) CGFloat   backToTopBtn_bottomOffset;  /**< 底部有类似tabbar或输入框时，返回顶部按钮的偏移量(被减的值) */
@property (nonatomic, strong, nonnull) NSURLSessionDataTask *cancelTask; /**< 用于取消网络请求 */
#pragma mark - 继承类实例化部分
@property (nonatomic, strong, nullable) UITableView         *tableView;
@property (nonatomic, strong, nullable) UIScrollView        *scrollView;
@property (nonatomic, strong, nullable) UICollectionView    *collectionView;
@property (nonatomic, strong, nullable) MDRefreshGifHeader  *refreshHeader;
@property (nonatomic, strong, nullable) MDRefreshGifFooter  *refreshFooter;
#pragma mark - 埋点部分
@property (nonatomic, strong, nullable) NSString            *track_info;    /**< 基类持有 埋点信息 */
@property (nonatomic, strong, nullable) NSString            *stack_info;    /**< 基类持有 栈信息 */

/**
 * 设置顶部导航栏样式：默认无导航栏
 */
- (void)setNavigationType:(MDNavigationType)navType;

/**
 * 获取自定义导航栏view
 */
- (UIView * _Nonnull)getBaseNaviagtionVw;

/**
 *  获取右边按钮
 */
- (UIButton * _Nullable)getRightBtn;

/**
 *  设置导航栏右侧按钮样式
 */
- (void)setRightBtnWith:(NSString *_Nullable)title image:(UIImage *_Nullable)img;

/**
 *  设置导航栏左侧按钮样式 ： 左侧按钮与返回按钮不要混淆
 */
- (void)setLeftBtnWith:(NSString *_Nullable)title image:(UIImage *_Nullable)img;

/**
 *  设置导航栏右侧按钮样式 ： 文本设置
 */
- (void)setRightBtnWithTitle:(NSString *_Nullable)title titleColor:(UIColor *_Nullable)titleColor titleSize:(CGFloat)titleSize;

/**
 *  设置导航栏右侧按钮样式 ： 文本设置(加粗)
 */
- (void)setRightBtnWithTitle:(NSString *_Nullable)title titleColor:(UIColor *_Nullable)titleColor titleFont:(UIFont *_Nullable)titleFont;

/**
 *  设置背景底部线条
 */
-(void)setupLineView:(BOOL)show;

/**
 *  设置导航栏标题
 */
- (void)setTitle:(NSString *_Nullable)title;

/**
 *  显示返回顶部按钮
 */
- (void)showBackToTopBtn;

/**
 *  隐藏返回顶部按钮
 */
- (void)hideBackToTopBtn;

/**
 *  显示右边按钮
 */
- (void)showRigntBtn;

/**
 *  隐藏右边按钮
 */
- (void)hideRightBtn;

/*
 回退：继承类可自己覆盖此方法以实现特殊需求
 */
- (void) back:(id _Nullable)sender;

/*
 * 左侧按钮失效/有效
 */
- (void) disableLeftBtn;
- (void) enableLeftBtn;
/*
 * 右侧按钮失效/有效
 */
- (void) disableRightBtn;
- (void) enableRightBtn;

/**
 *  导航栏左右按钮的相应方法需要继承类根据需要自行覆盖
 */
- (void) rightBtnTapped:(id _Nullable)sender;
- (void) leftBtnTapped:(id _Nullable)sender;

/**
 *  获取网络状态的变化
 */
- (void) networkReachabilityStatusDidChange:(AFNetworkReachabilityStatus) status;

/**
 *  当继承类重些此方法时便于执行 [super scrollViewDidScroll:scrollView];
 */
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;

/**
 *  tab bar control 双击
 */
- (void)tabbarDoubleClick;

@end
