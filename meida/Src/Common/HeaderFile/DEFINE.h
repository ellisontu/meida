//
//  DEFINE.h
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  本文件用于 判断系统屏幕大小、版本、机型、系统默认控件高度等系统信息
#import <Foundation/Foundation.h>

#ifndef meida_DEFINE_h
#define meida_DEFINE_h

#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBuild   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kAppName    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


#pragma mark - ------------------ 手机系统版本 ------------------
// =
#define IOS_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
// >
#define IOS_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
// >=
#define IOS_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// <
#define IOS_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
// <=
#define IOS_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#pragma mark - ------------------ 机型 ------------------

#define IS_IPHONE               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH       (MAX(SCR_WIDTH, SCR_HEIGHT))
#define SCREEN_MIN_LENGTH       (MIN(SCR_WIDTH, SCR_HEIGHT))
#define IS_IPHONE_4_OR_LESS     (IS_IPHONE && SCREEN_MAX_LENGTH <  568.0)
#define IS_IPHONE_5_OR_LESS     (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5_OR_MORE     (IS_IPHONE && SCREEN_MAX_LENGTH >= 568.0)
#define IS_IPHONE_5             (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6             (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6_OR_MORE     (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)
#define IS_IPHONE_6P            (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6P_OR_MORE    (IS_IPHONE && SCREEN_MAX_LENGTH >= 736.0)


#pragma mark - ------------------ 手机屏幕 ------------------

#define kScreenScale    ([UIScreen mainScreen].scale)
#define SCR_WIDTH       [[UIScreen mainScreen] bounds].size.width
#define SCR_HEIGHT      [[UIScreen mainScreen] bounds].size.height
// 是否高清屏
#define isRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? !CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : YES)

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark ------------------ block，若引用 ------------------
//block
typedef void (^MDBlock)(void);
typedef void (^MDIndexBlock)(id sender, NSInteger idx);
typedef void (^MDStatusBlock)(id sender, NSInteger state);

#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180)

// 👎引用
#define MDWeakPtr(weakPtr, obj) __block __weak typeof (&*obj) weakPtr = obj;
// 👍引用
#define STRONGSELF  __strong typeof(weakPtr) strongSelf = weakPtr;


// 1像素高度
#define OnePixScale (1.0f / [UIScreen mainScreen].scale)


#pragma mark ------------------ 日志输出 ------------------

//根据Debug和Release状态的变化来屏蔽日志输出
#ifdef DEBUG
#define DLog(format, ...) printf("%s\n\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(format, ...)
#endif

// 出输出类名 方法 行数 👉 信息
#ifdef DEBUG
//#define XLog(format, ...) NSLog((@"%s \n[Line %d] 👉 " format), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
# define XLog(format, ...) printf("%s \n[Line %d] 👉 %s \n\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#define XLog(format, ...)
#endif


#pragma mark ------------------ 系统控件默认高度 ------------------

#define LINESPACE               (4.f)
#define kOffset                 (10.f)
// 状态栏高度 (适配时可直接使用此宏)
#define kStatusBarHeight        (iPhoneX ? 44.f : 20.f)
// 导航高度 固定
#define kNavigationBarHeight    (44.f)
// 顶部高度
#define kHeaderHeight           (kStatusBarHeight + kNavigationBarHeight)
// tabbar 以下高度(适配时可直接使用此宏  例: x + kTabBarBottomHeight)
#define kTabBarBottomHeight     (iPhoneX ? 34.f : 0.f)
// tabbar 高度
#define kTabBarHeight           (49.f + kTabBarBottomHeight)


// 默认内容返回数量
#define kContentDefaultCount    20

#endif



