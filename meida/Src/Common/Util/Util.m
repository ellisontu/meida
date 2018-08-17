//
//  Util.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "Util.h"
#import <MBProgressHUD.h>
#import "NSDate+DateTools.h"
#import <math.h>
#import "EncryptionMethods.h"
#import "Themes.h"
#import "Photos/Photos.h"
#import "MDTopLoadingView.h"
#import "LocalFileManager.h"
//#import "GeTuiSdk.h"
#import "NSString+URLEncoding.h"
#import "MDDeviceManager.h"
#import "ServerConfigManager.h"
#import "MDLoginControl.h"

@implementation Util

+ (BOOL)isFirstInstallation
{
    // @"isFirstInstallation" 经用于识别是否第一次安装
    NSString *firstInstallation = @"isFirstInstallation";
    NSString *firstInstallationStr = [SAMKeychain passwordForService:kService account:firstInstallation];
    if (stringIsEmpty(firstInstallationStr)) {
        // 保存识别
        [SAMKeychain setPassword:firstInstallation forService:kService account:firstInstallation];
        // 第一次装载
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)md5:(NSString *)input {
    
    NSString *output = [EncryptionMethods getMd5_32Bit_String:input];
    
    return  output;
}

+ (NSString *)getCurrentTime {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld", [NSNumber numberWithDouble:time].longValue];
    
    return timeString;
}

+ (NSString *)getToken:(NSString *)password atTime:(NSString *)time byUser:(NSString *)uid {
    NSString *token = [Util md5:([NSString stringWithFormat:@"%@%@%@", password, time, kSeed])];
    return [NSString stringWithFormat:@"%@ %@ %@", uid, token, time];
}

+ (NSString *)decimalNumberConvertToStringWithNumber:(NSNumber *)conversionValue
{
    if (!conversionValue) {
        return @"0.00";
    }
    double doubleValue = [conversionValue doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (NSDictionary *)getDeviceInfo
{
    NSString *uid = LOGIN_USER ? [LOGIN_USER uid] : @"未知";
    if (stringIsEmpty(uid)) {
        uid = @"未知";
    }
    NSString *dateAdd = [Util getCurrentTime];
    NSArray *deveiceModelAry = getDeveiceModelName();
    NSString *telephoneType = @"未知";
    if (!arrayIsEmpty(deveiceModelAry)) {
        telephoneType = [deveiceModelAry firstObject];
    }
    NSString *networkType = @"未知";
    if (deveiceModelAry.count == 2) {
        networkType = [deveiceModelAry lastObject];
    }
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *cid = @"";//[GeTuiSdk clientId] ? [GeTuiSdk clientId] : @"未知";
    NSDictionary *dic = @{
                          @"platform"   :@"iOS",
                          @"uid"        :uid,
                          @"date_add"   :dateAdd,
                          @"cid"        :cid,
                          @"R"          :getDeveiceResolution(),
                          @"D"          :getDeveicePPI(),
                          @"C"          :getDeveiceCPU(),
                          @"M"          :getDeveiceMemory(),
                          @"V"          :getDeveiceSystemVersion(),
                          @"I"          :[Util getUUIDString],
                          @"IDFA"       :getDeveiceIDFA(),
                          @"T"          :telephoneType,
                          @"N"          :networkType,
                          @"CV"         :currentAppVersion
                          };
    
    return dic;
}

+ (NSString *)getUUIDString
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return getDeveiceUUID();
}

+ (NSDictionary *)getUserLoginInfoWithMobile:(NSString *)mobile password:(NSString *)password
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    // 账号
    if (!stringIsEmpty(mobile)) {
        [para setObject:mobile forKey:@"mobile"];
    }
    
    // 鉴权码
    if (!stringIsEmpty(password)) {
        [para setObject:[Util md5:password] forKey:@"password"];
    }
    
    // 版本
    [para setObject:kAppVersion forKey:@"app_version"];
    
    // UUID
    [para setObject:filterValue([MDDeviceManager sharedInstance].deviceIden) forKey:@"device_id"];
    
    // 设备号
    if (getDeveiceModelName()) {
        NSMutableArray *deviceArr = [NSMutableArray arrayWithArray:getDeveiceModelName()];
        NSString *device = nil;
        if (arrayIsEmpty(deviceArr)) {
            device = [deviceArr firstObject];
            [para setObject:device forKey:@"device_name"];
        }
    }
    // 位置(早已关闭定位服务)
    double lat = [MDDeviceManager sharedInstance].appLocation.latitude;
    double lng = [MDDeviceManager sharedInstance].appLocation.longitude;
    if (lat) {
        [para setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
    }
    if (lng) {
        [para setObject:[NSNumber numberWithDouble:lng] forKey:@"lng"];
    }
    
    return para;
}

+ (BOOL)isIncludeChinese:(NSString *)string
{
    if (stringIsEmpty(string)) {
        return NO;
    }
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        //DLog(@"cString.len = %lu", strlen(cString));
        if (strlen(cString) == 1) {
            // cString 不是汉字
        }
        else if (strlen(cString) == 3) {
            // cString 是汉字
            return YES;
        }
    }
    return NO;
}

+ (void)showAlertMsg:(NSString *)msg
{
    [Util showAlert:NSLocalizedString(@"tip", nil) withMessage:msg];
}

+ (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles: nil];
    [alert show];
}

+ (void)showMessage:(NSString *)msg inView:(UIView *)view {
    [Util showMessage:msg forDuration:1.5 inView:view];
}

+ (void)showMessage:(NSString *)msg forDuration:(float)duration inView:(UIView *)view{
    if (!msg || ![msg isKindOfClass:[NSString class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.label.text = [NSString stringWithFormat:@"%@", msg];
        hud.label.numberOfLines = 0;
        hud.label.font = FONT_SYSTEM_NORMAL(14.f);
        hud.contentColor = COLOR_WITH_WHITE;
        hud.bezelView.color = [COLOR_TOAST_BACK colorWithAlphaComponent:0.8f];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.mode = MBProgressHUDModeCustomView;
        
        [hud hideAnimated:YES afterDelay:duration];
    });
}

+ (void)showErrorMessage:(NSObject *)object forDuration:(float)duration
{
    if ([object isKindOfClass:[MDErrorModel class]]) {
        MDErrorModel *errorModel = (MDErrorModel *)object;
        if (errorModel.errMsg) {
            [Util showMessage:errorModel.errMsg forDuration:duration inView:MDAPPDELEGATE.window];
        }
    }
}

+ (void)showRemindView:(NSString *)remindText DelayTime:(CGFloat)delayTime
{
    [[MDTopLoadingView shareInstance] showTopViewInViewWithtitle:remindText delayTime:delayTime];
}

+ (NSString *)timeAgoSinceDateTimeStamp:(NSTimeInterval)timestamp {
    NSTimeInterval secondToToday = [[NSDate dateWithTimeIntervalSince1970:timestamp] timeIntervalSinceNow];
    NSString *timeString =  [NSDate timeAgoSinceDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    if (secondToToday < -4*24*60*60) {
        timeString = @"";
    } else if ( secondToToday > -2*24*60*60 && secondToToday < -24*60*60) {
        timeString = @"1天前";
    }
    return timeString;
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (BOOL)isSameDay:(NSString *)time1 :(NSString *)time2
{
    if(!time1 || !time2){
        return NO;
    }
    
    NSTimeInterval interval1 = time1.doubleValue;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:interval1];
    NSString *date1Str = [date1 formattedDateWithFormat:@"yyyy-MM-dd"];
    
    NSTimeInterval interval2 = time2.doubleValue;
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:interval2];
    NSString *date2Str = [date2 formattedDateWithFormat:@"yyyy-MM-dd"];
    
    if([date1Str isEqualToString:date2Str]){
        return YES;
    }
    return NO;
}

+ (NSString *)changeTimeToString:(float)time
{
    NSString* timeend;
    NSString* timestr=[NSString stringWithFormat:@"%f",time];
    int inttime=[timestr intValue];
    int minute=inttime/60;
    int second=inttime%60;
    //int msecond=(int)([timestr floatValue] * 10) % 10;
    NSString* secondstr=[NSString stringWithFormat:@"%d",second];
    if ([secondstr length]==1)
        timeend=[NSString stringWithFormat:@"%d:0%d",minute,second];
    else
        timeend=[NSString stringWithFormat:@"%d:%d",minute,second];
    return timeend;
}

/*
 * 四舍五入
 */
+ (NSString *)getNumberFormatWithRoundingIncrement:(float)roundingIncrement numberValue:(double)numberValue
{
    NSNumber *number = [NSNumber numberWithDouble:numberValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.roundingIncrement = [NSNumber numberWithDouble:roundingIncrement];
    //小数形式
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    //小数位最多位数
    formatter.maximumFractionDigits = 2;
    NSString *valueString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:number]];
    //用此方法处理超过千位的时候会有逗号（，）测试（康绰）说去了
    // 但是 “法语的系统” 货币格式出来是有问题的， 只有逗号和空格， trimm掉了之后就多了小数点后就变成个位
    // 这里加一层判断，只有大于1000 才去trimm , 大多数货币格式都支持，法语
    if (numberValue >= 1000) {
        return [valueString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    return valueString;
}

/*
 * 弹出一个带确定按钮的alert view
 */
+ (void)showOptionWarning:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

/*
 *弹出一个带确定按钮的alert view
 */
+ (void)showOptionWarning:(NSString *)msg delegate:(id)delegate tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    alert.tag = tag;
    [alert show];
}

/*
 *展示一个载入动画，常规情况下需要配合 hideLoadingVw 方法来隐藏该动画
 */
+ (void) showLoadingVwInView:(UIView *)view withText:(NSString *)text
{
    if ([MDNetWorking sharedClient].isReachable)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MDLoadingView shareInstance] hide:NO];
            [[MDLoadingView shareInstance] showInView:view withText:text animated:YES];
        });
    }
}

/*
 *视频编辑载入动画
 */
+ (MDLoadingView *) multiMediaLoadingInView:(UIView *)view withText:(NSString *)text withloadingMode:(LoadingMode)mode
{
    MDLoadingView *loadingVw = [MDLoadingView shareInstance];
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingVw hide:NO];
        [loadingVw multiMediaShowInView:view withText:text progress:0.0 withloadingMode:ProgressLoadingMode];
    });
    return loadingVw;
}

/*
 *隐藏载入动画
 */
+ (void) hideLoadingVw
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MDLoadingView shareInstance] hide:YES];
    });
}

/*
 *麦克风访问授权状态
 */
+ (MDDeviceAuth) checkMicrophoneAuthorityStatus:(MDStatusBlock)callBack
{
    AVAudioSessionRecordPermission status = [[AVAudioSession sharedInstance] recordPermission];
    if (status == AVAudioSessionRecordPermissionGranted)
    {
        DLog(@"麦克风已授权");
        return DeviceAuthorized;
    }
    else if(status == AVAudioSessionRecordPermissionUndetermined)
    {
        DLog(@"麦克风授权未定");
        return DeviceAuthNotDetermined;
    }
    else
    {
        DLog(@"麦克风权限被拒绝");
        return DeviceAuthDenied;
    }
}

/*
 *摄像头访问授权状态
 */
+ (MDDeviceAuth) checkCameraAuthorityStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized)
    {
        DLog(@"摄像头已授权");
        return DeviceAuthorized;
    }
    else if(status == AVAuthorizationStatusNotDetermined)
    {
        return DeviceAuthNotDetermined;
    }
    return DeviceAuthDenied;
}

/*
 *照片访问授权状态
 */
+ (MDDeviceAuth) checkPhotoAuthorityStatus
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized)
    {
        return DeviceAuthorized;
    }
    else if(status == PHAuthorizationStatusNotDetermined)
    {
        return DeviceAuthNotDetermined;
    }
        
    return DeviceAuthDenied;
}

/*
 *向系统提出权限请求（让系统弹框）
 */
+ (void) requestDeviceAuthorityForCamera
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        DLog(@"麦克风请求弹窗%d",granted);
    }];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        DLog(@"视频请求弹窗%d",granted);
    }];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        DLog(@"照片请求弹窗%ld",status);
    }];
}

/**
 *  进入本APP的系统设置页面
 */
+ (void)goToAppSystemSettings
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *urlString = [NSString stringWithFormat:@"prefs:root=%@", BUNDLE_ID];
        if (IOS_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    });
}


+ (BOOL)isPhoneNumber:(NSString *)phone
{
    if (phone.length > 0)
    {
        if (([[phone substringToIndex:1] integerValue] == 1) && (phone.length == 11)) {
            return YES;
        }
        return NO;
    }
    return NO;
    // 本地只进行简单的正则判断，其他在服务端进行判断
    
//    NSString *mobileRegex = @"^((13[0-9])|(110)|(147)|(170)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
//    
//    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
//    
//    BOOL n = [mobileTest evaluateWithObject:phone];
//    return n;
}

#pragma mark - 认证鉴权
+ (NSString *)calculateCheckValue:(NSString *)url timeStamp:(NSString *)timeStamp
{
    /*
     //url 请求的路径　包括query部分　比如　/a/b?c=d&e=f
     check = md5(prefix + "_" + url + "_" + timestamp)
     for hash_times - 1:
     check = md5(prefix + "_" + check + "_" + timestamp)
     */
    /*
    if (!LOGIN_USER.prefix || !LOGIN_USER.token || !LOGIN_USER.hashTimes) {
        return @" ";
    }
    
    NSString *initString = [NSString stringWithFormat:@"%@_%@_%@", LOGIN_USER.prefix, url, timeStamp];
    //DLog(@"initString:%@", initString);
    
    NSString *md5String = [EncryptionMethods getMd5_32Bit_String:initString];
    //DLog(@"md5 1st:%@", md5String);
    
    NSInteger hashTime =  [LOGIN_USER.hashTimes integerValue];
    while (hashTime > 1) {
        md5String = [NSString stringWithFormat:@"%@_%@_%@", LOGIN_USER.prefix, md5String, timeStamp];
        //DLog(@"md5 %ld init:%@", hashTime, md5String);
        
        md5String = [EncryptionMethods getMd5_32Bit_String:md5String];
        //DLog(@"md5 %ld md5:%@", hashTime, md5String);
        
        hashTime--;
    }
     */
    return @"";//md5String;
}

/**
 *  更换登陆后 鉴权调用  在网络请求中返回用户授权信息错误调用 (这块的注释是金莲打的 我看不大明白 她给自己带盐)
 *
 *  @param isLaunch 新版本第一次打开的时候调用为 YES  在网络库中调用为 NO
 */
//+ (void)permissionToChangeWithUserLogin:(BOOL)isLaunch
//{
//    // 1. 必须是曾经登陆过的用户
//    // 2. 验证信息
//    if (LOGIN_USER && (isLaunch ? [self verify] : YES)) {
//
//        if (!stringIsEmpty(LOGIN_USER.mobile)) {
//            NSDictionary *parameters = @{
//                                         @"mobile"      : stringIsEmpty(LOGIN_USER.mobile) ? @"" : LOGIN_USER.mobile,
//                                         @"password"    : stringIsEmpty(LOGIN_USER.password) ? @"" : LOGIN_USER.password,
//                                         @"device_id"   : filterValue([MDDeviceManager sharedInstance].deviceIden),
//                                         };
//        }
//        else
//        {
//            // 这是第三方登陆 并且没有绑定手机号
//            [[UserManager sharedInstance] logOut];
//            [Util showMessage:@"亲爱的唇蜜,由于第三方账号登录失效,请重新登录您的账号,感谢您长久以来的翻牌" inView:MDAPPDELEGATE.window];
//        }
//    }
//}

+ (BOOL)verify
{
    // 这几个如果有一个不存在 则不能通过验证 需要重新登陆
    return @"";//(stringIsEmpty(LOGIN_USER.prefix) || stringIsEmpty(LOGIN_USER.token) || !LOGIN_USER.hashTimes);
}

/**
 *  获取指定类型的图片
 *
 *  @param url   图片 url
 *  @param style  要获取的样式
 *
 *  @return  image
 */
+ (NSString *)getImageStyleUrl:(NSString *) url style:(ENUM_IMAGE_STYLE) style
{
    if (stringIsEmpty(url)) {
        return @"";
    }
    
    //当为GIF图时不作处理
    if ([url hasSuffix:@".gif"]) {
        return url;
    }
    
    NSMutableString *str = [NSMutableString stringWithString:url];
    NSString *replace = @"-[A-Za-z0-9]+$";
    NSString *check = @"/F.{27}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:replace options:0 error:nil];
    NSRegularExpression *regexCheck = [NSRegularExpression regularExpressionWithPattern:check options:0 error:nil];
    
    //非28位自动编码的图片并且有样式后缀的去除后缀
    if([regexCheck numberOfMatchesInString:str options:0 range:NSMakeRange(0, [str length])] == 0
       && [regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, [str length])] > 0)
    {
        [regex replaceMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    }
    
    // 读取本地
    NSString *scaleStr = @"2";
    if (SCR_WIDTH > 375) {
        scaleStr = @"3";
    }
    NSString *imageAppendStr = @"";
    NSDictionary *stylesDic = [ServerConfigManager sharedInstance].model.styles;
    NSString *newStr = @"";
    switch (style)
    {
        case IMAGE_STYLE_SMALL:
        {
            newStr = [NSString stringWithFormat:@"small%@x", scaleStr];
        }
            break;
        case IMAGE_STYLE_MID:
        {
            newStr = [NSString stringWithFormat:@"mid%@x", scaleStr];
        }
            break;
        case IMAGE_STYLE_BIG:
        {
            newStr = [NSString stringWithFormat:@"big%@x", scaleStr];
        }
            break;
        case IMAGE_STYLE_ICON:
        {
            newStr = [NSString stringWithFormat:@"icon%@x", scaleStr];
        }
            break;
        case IMAGE_STYLE_AVATARS:
        {
            newStr = [NSString stringWithFormat:@"avatars%@x", scaleStr];
        }
            break;
        case IMAGE_STYLE_POSTER:
        {
            newStr = [NSString stringWithFormat:@"poster"];
        }
            break;
        default:
            break;
    }
    
    if (stylesDic && stylesDic[newStr]) {
        imageAppendStr = stylesDic[newStr];
    }
    else {
        imageAppendStr = [NSString stringWithFormat:@"-%@.webp",newStr];
    }
    [str appendString:imageAppendStr];
    
    return str;
}

/**
  encoding 标签的跳转url
 */
+ (NSString *)encodingTagsJumpUrl:(NSString *)tagWord
{
    if (!stringIsEmpty(tagWord)) {
        
        tagWord = [tagWord URLEncodedString];
        
        NSString *info_url = [NSString stringWithFormat:@"%@/search_es/video_and_sharebuy_count_v2?words=%@",BASEURL ,tagWord];
        NSString *data_url = [NSString stringWithFormat:@"%@/search_es/video_and_sharebuy_list_v2?words=%@",BASEURL ,tagWord];
        
        info_url = [info_url URLEncodedString];
        data_url = [data_url URLEncodedString];
        
        NSString *jump_url = [NSString stringWithFormat:@"md://ymfashion/params?channelId=0&info=%@&data=%@",info_url ,data_url];
        
        return jump_url;
    }
    return nil;
}

#pragma mark - 省市区 json to plist 生成一份 plist 文件 (仅做参考) -
+ (void)areaJsonToPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Area.json" ofType:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray *array_new = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *provinceDic_new = [NSMutableDictionary dictionary];
        NSMutableArray *city_array_new = [NSMutableArray array];
        //省
        NSDictionary *provinceDic = array[i];
        NSString *province_name = [provinceDic objectForKey:@"name"];
        NSArray *city_array = nil;
        if ([province_name isEqualToString:@"北京市"] || [province_name isEqualToString:@"上海市"] || [province_name isEqualToString:@"天津市"] || [province_name isEqualToString:@"重庆市"] || [province_name isEqualToString:@"其它"]) {
            city_array = @[provinceDic];
        }
        else {
            city_array = [provinceDic objectForKey:@"child"];
        }
        for (int i = 0; i < city_array.count; i++) {
            NSMutableDictionary *cityDic_new = [NSMutableDictionary dictionary];
            NSMutableArray *area_array_new = [NSMutableArray array];
            //市
            NSDictionary *cityDic = city_array[i];
            NSString *city_name = [cityDic objectForKey:@"name"];
            NSArray *area_array = [cityDic objectForKey:@"child"];
            for (int i = 0; i < area_array.count; i++) {
                //区
                NSDictionary *areaDic = area_array[i];
                NSString *area_name = [areaDic objectForKey:@"name"];
                [area_array_new addObject:area_name];
            }
            //市的信息导入新的市字典
            [cityDic_new setObject:city_name forKey:@"city"];       //市
            [cityDic_new setObject:area_array_new forKey:@"areas"]; //区（数组）
            //把市的字典信息加到新的市数组
            [city_array_new addObject:cityDic_new];
        }
        [provinceDic_new setObject:province_name forKey:@"state"];  //省
        [provinceDic_new setObject:city_array_new forKey:@"cities"];//市（数组）
        //把省的字典信息加到新的省数组
        [array_new addObject:provinceDic_new];
    }
    //此路径需要在Mac环境下运行才是桌面路径，否则是在手机下
    NSString *desktopPath = [NSString stringWithFormat:@"%@/Desktop", NSHomeDirectoryForUser(NSUserName())];
    NSString *newPath = [desktopPath stringByAppendingPathComponent:@"Area.plist"];
    DLog(@"newPath = %@", newPath);
    //将数组写入文件
    if ([array_new writeToFile:newPath atomically:YES]) {
        DLog(@"数据写入成功");
    }
    else {
        DLog(@"数据写入失败");
    }
}

+ (NSString *)getCurrentStackInfo
{
    NSArray *stackArr = MDAPPDELEGATE.navigation.childViewControllers;
    NSString *stackInfo = [NSString string];
    for (NSInteger index = 0; index < stackArr.count; index++) {
        UIViewController *vc = stackArr[index];
        NSString *vcName = NSStringFromClass([vc class]);
        stackInfo = [stackInfo stringByAppendingString:vcName];
    }
    stackInfo = [Util md5:stackInfo];
    stackInfo = [stackInfo URLEncodedString];
    return stackInfo;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *viewController = MDAPPDELEGATE.navigation ? MDAPPDELEGATE.navigation : [[[UIApplication sharedApplication] keyWindow] rootViewController];
    return [Util getCurrentViewController:viewController];
}

+ (UIViewController *)getCurrentViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0 ) {
            return [Util getCurrentViewController:(UIViewController *)svc.viewControllers.lastObject];
        }
        else {
            return vc;
        }
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        if (nvc.viewControllers.count > 0) {
            return [Util getCurrentViewController: (UIViewController *)nvc.topViewController];
        }
        else {
            return vc;
        }
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabvc = (UITabBarController *)vc;
        if (tabvc.viewControllers.count > 0 ) {
            return [Util getCurrentViewController: (UIViewController *)tabvc.selectedViewController];
        }
        else {
            return vc;
        }
    }
    else {
        return vc;
    }
}


+ (void)checkUrlParamsWithUrlString:(NSString *)urlString
{
    //检查是否有参数 s (打开APP用户的上级参数标示) , 有则保存
    NSURL *URL = [NSURL URLWithString:urlString];
    NSString *params = [URL query];
    NSArray *keyValueArray = [params componentsSeparatedByString:@"&"];
    for (NSString *subStr in keyValueArray) {
        NSArray *parpamArray = [subStr componentsSeparatedByString:@"="];
        if (parpamArray.count == 2) {
            if ([parpamArray.firstObject isEqualToString:@"s"]) {
                [[NSUserDefaults standardUserDefaults] setObject:parpamArray.lastObject forKey:kSuperiorParameter];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

+ (void)checkLoginState
{
    if (stringIsEmpty(LOGIN_USER.uid)) {
        MDLoginControl *vc = [[MDLoginControl alloc] init];
        [MDAPPDELEGATE.navigation presentViewController:vc animated:YES completion:nil];
    }
}

@end
