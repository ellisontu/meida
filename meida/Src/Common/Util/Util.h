//
//  Util.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDLoadingView.h"

typedef NS_ENUM(NSInteger, MDDeviceAuth)
{
    DeviceAuthorized,
    DeviceAuthNotDetermined,
    DeviceAuthDenied
};

typedef enum {  // 获取图片的格式
    IMAGE_STYLE_SMALL   = 1,
    IMAGE_STYLE_MID,
    IMAGE_STYLE_BIG,
    IMAGE_STYLE_ICON,
    IMAGE_STYLE_AVATARS,
    IMAGE_STYLE_POSTER
} ENUM_IMAGE_STYLE;

@interface Util : NSObject

+ (NSString *)md5:(NSString *)input;
+ (NSString *)getCurrentTime;
+ (NSString *)getToken:(NSString *)password atTime:(NSString *)time byUser:(NSString *)uid;


/**
 number 类型数据转为字符串（解决iOS解析 Number 类型数据，精度丢失问题）

 @param conversionValue 需要做转换的数据
 @return 字符串类型数据
 */
+ (NSString *)decimalNumberConvertToStringWithNumber:(NSNumber *)conversionValue;

/**
 获取当前设备信息
 //接口：URL_USER_LOGIN_TIME 和 URL_GET_UPLOADVIDEO 会用到
 @return dic
 */
+ (NSDictionary *)getDeviceInfo;

/**
 *  获取登录用户的各项参数
 */
+ (NSDictionary *)getUserLoginInfoWithMobile:(NSString *)mobile password:(NSString *)password;

+ (BOOL)isIncludeChinese:(NSString *)string;
+ (void)showAlertMsg:(NSString *)msg;
+ (void)showAlert:(NSString *)title withMessage:(NSString *)msg;
+ (void)showMessage:(NSString *)msg inView:(UIView *)view;
+ (void)showMessage:(NSString *)msg forDuration:(float)duration inView:(UIView *)view;

/**
 *  是否为第一次安装(v2.9.0)
 */
+ (BOOL)isFirstInstallation;

/**
 *  新的网络请求失败时需要显示错误信息时用
 */
+ (void)showErrorMessage:(NSObject *)object forDuration:(float)duration;

/**
 *  网络出错时，顶部显示提示语
 */
+ (void)showRemindView:(NSString *)remindText DelayTime:(CGFloat)delayTime;

+ (NSString *)timeAgoSinceDateTimeStamp:(NSTimeInterval)timestamp;

+ (NSString *)getUUIDString;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (BOOL)isSameDay:(NSString *)time1 :(NSString *)time2;

/**
 *  将数字格式化 （四舍五入法，小数点后并保留n位有效数字，若最后结果小数点后全为0，则只保留整数部分）
 *
 *  @param roundingIncrement 舍入增量  0.1:小数点后保留1位有效数字  0.01:2位  0.03:3位
 *
 *  @return 格式化的数字字符串
 */
+ (NSString *)getNumberFormatWithRoundingIncrement:(float)roundingIncrement numberValue:(double)numberValue;

/*
 *弹出一个带确定按钮的alert view
 */
+ (void)showOptionWarning:(NSString *)msg;

/*
 *弹出一个带确定按钮的alert view
 */
+ (void)showOptionWarning:(NSString *)msg delegate:(id)delegate tag:(NSInteger)tag;

/*
 *展示一个载入动画，常规情况下需要配合 hideLoadingVw 方法来隐藏该动画
 */
+ (void) showLoadingVwInView:(UIView *)view withText:(NSString *)text;

/*
 *视频编辑载入动画
 */
+ (MDLoadingView *) multiMediaLoadingInView:(UIView *)view withText:(NSString *)text withloadingMode:(LoadingMode)mode;

/*
 *隐藏载入动画
 */
+ (void) hideLoadingVw;

/*
 *麦克风访问授权状态
 */
+ (MDDeviceAuth) checkMicrophoneAuthorityStatus:(MDStatusBlock)callBack;

/*
 *摄像头访问授权状态
 */
+ (MDDeviceAuth) checkCameraAuthorityStatus;

/*
 *照片访问授权状态
 */
+ (MDDeviceAuth) checkPhotoAuthorityStatus;

/*
 *向系统提出权限请求（让系统弹框）
 */
+ (void) requestDeviceAuthorityForCamera;

/**
 *  进入本APP的系统设置页面
 */
+ (void)goToAppSystemSettings;

#pragma mark - 认证鉴权
+ (NSString *) calculateCheckValue:(NSString *)url timeStamp:(NSString *)timeStamp;
//
///**
// *  更换登陆后 鉴权调用  在网络请求中返回用户授权信息错误调用 (这块的注释是金莲打的 我看不大明白 她给自己带盐)
// *
// *  @param isLaunch 新版本第一次打开的时候调用为 YES  在网络库中调用为 NO
// */
//+ (void)permissionToChangeWithUserLogin:(BOOL)isLaunch;

/**
 *  检测手机号码是否正确
 */
+ (BOOL)isPhoneNumber:(NSString *)phone;

#pragma mark - 需要讨论的韩束  巨补水
// 秒转成时间，用于拼接视频
+ (NSString *)changeTimeToString:(float)time;

/**
 *  获取指定样式图片
 */
+ (NSString *)getImageStyleUrl:(NSString *)url style:(ENUM_IMAGE_STYLE)style;

/**
 * encoding标签的跳转url
 */
+ (NSString *)encodingTagsJumpUrl:(NSString *)tagWord;

/**
 *  获取当前栈信息
 */
+ (NSString *)getCurrentStackInfo;

/**
 * 获取当前控制器
 */
+ (UIViewController *)getCurrentVC;


/**
 检查是否有参数 s (打开APP用户的上级参数标示) , 有则保存

 @param urlString H5 传过来的带有参数s，分享信息的 url
 */
+ (void)checkUrlParamsWithUrlString:(NSString *)urlString;

#pragma mark - 省市区 json to plist (仅做参考) -
+ (void)areaJsonToPlist;


#pragma mark - 新版本的 trace_info 传递公用方法
/**
 path : /api2/client/event_track
 客户端 事件统计 接口
 @param params dict
 */
+ (void)clientEventTrackWithParams:(NSDictionary *)params;

#pragma mark - 获取用户通讯录
+ (void)getAddressBook:(NSInteger )start size:(NSInteger) size complete:(void (^)(NSDictionary *))complete;

@end
