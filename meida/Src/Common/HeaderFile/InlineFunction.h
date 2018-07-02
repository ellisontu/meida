//
//  InlineFunction.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <mach/mach.h>
#import <mach-o/arch.h>
#import <sys/sysctl.h>
//获取 IDFA 需导入
#import <AdSupport/AdSupport.h>
//为判断网络制式的主要文件
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//添加获取客户端运营商支持
#import "CoreTelephony/CTCarrier.h"
#import <mach/mach_time.h>
#import "UIImage+Resize.h"
#import "SAMKeychain.h"

#pragma mark - ****** 判断非空 ****** -

CG_INLINE BOOL cStrIsEmpty(const char *c) {
    if (c[0] == '\0') {
        return YES;
    }
    if (c == NULL) {
        return YES;
    }
    return NO;
}

CG_INLINE BOOL stringIsEmpty(NSString *string) {
    if ([string isKindOfClass:[NSNumber class]]) {
        NSNumber *stringNumber = (NSNumber *)string;
        string = [stringNumber stringValue];
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    //去除两头的空格和回车
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text length] == 0) {
        return YES;
    }
    return NO;
}

CG_INLINE NSString *filterValue(NSString *value) {
    if (stringIsEmpty(value)){
        return @"";
    }
    return value;
}

CG_INLINE BOOL dictionaryIsEmpty(NSDictionary *dic) {
    if ([dic isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (dic && [dic count] > 0){
        return NO;
    }
    return YES;
}

CG_INLINE BOOL arrayIsEmpty(NSArray *array) {
    if ([array isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (![array isKindOfClass:[NSArray class]]) {
        return YES;
    }
    if (array && [array count] > 0){
        return NO;
    }
    return YES;
}

CG_INLINE BOOL dictionaryIsNull(NSDictionary *dic) {
    if ([dic isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (!dic){
        return YES;
    }
    return NO;
}

CG_INLINE BOOL arrayIsNull(NSArray *array) {
    if ([array isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (!array){
        return YES;
    }
    return NO;
}

#pragma mark - ****** 计算字体高度 ******
CG_INLINE NSDictionary *getAttributeDictionary(UIFont *font, CGFloat lineSpacing) {
    
    if (!font) {
        font = [UIFont systemFontOfSize:14.f];
    }
    if (lineSpacing < 0) {
        lineSpacing = 0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    return dic;
}

CG_INLINE NSAttributedString *getAttributedString(NSString *string, NSDictionary *dic) {
    
    if (stringIsEmpty(string)) {
        return nil;
    }
    if (dictionaryIsEmpty(dic)) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:style};
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:dic];
    return attrStr;
}

CG_INLINE CGSize getStringSize(NSString *string, CGSize maxSize, UIFont *font) {
    
    if (stringIsEmpty(string)) {
        return CGSizeMake(0, 0);
    }
    
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

CG_INLINE CGSize getAttributeStringSize(NSString *string, CGSize maxSize, NSDictionary *attributeDic) {
    
    if (stringIsEmpty(string)) {
        return CGSizeMake(0, 0);
    }
    if (dictionaryIsEmpty(attributeDic)) {
        
        attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f]};
    }
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
    
    return size;
}

CG_INLINE UIViewController *getAppRootViewController() {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

CG_INLINE UIImage *getImageByNameAndType(NSString *imageName, NSString *imageType) {
    if (stringIsEmpty(imageType)) {
        imageType = @"png";
    }
    if (stringIsEmpty(imageName)) {
        return nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}


CG_INLINE NSData *reduceImageFileSize(NSData *imageData, CGFloat size) {
    
    while (imageData.length > size) {
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        UIImage *reduceImage = [image resizedImageToSize:CGSizeMake(image.size.width*0.8, image.size.height*0.8)];
        imageData = UIImageJPEGRepresentation(reduceImage, 0.7);
    }
    
    return imageData;
}

#pragma mark - ****** 时间格式化 ****** -

CG_INLINE NSString *getRemainingTime(NSTimeInterval time, NSInteger timeType) {
    NSString *remainingTime = nil;
    int day = 0;
    int hour = 0;
    int min = 0;
    int sec = 0;
    if (time >= 60*60*24) {
        day = time/3600/24;
        hour = (time - day*3600*24)/3600;
        min = (time - day*3600*24 - hour*3600)/60;
        sec = (time - day*3600*24-hour*3600-min*60);
        if (timeType == 1) {
            remainingTime = [NSString stringWithFormat:@"%02d天%02d小时%02d分%02d秒", day, hour, min, sec];
        }
        else if (timeType == 2) {
            remainingTime = [NSString stringWithFormat:@"%02d天%02d小时%02d分%02d秒后", day, hour, min, sec];
        }
        
    }
    else if (time >= 60*60) {
        hour = time/3600;
        min = (time-hour*3600)/60;
        sec = time-hour*3600-min*60;
        if (timeType == 1) {
            remainingTime = [NSString stringWithFormat:@"%02d小时%02d分%02d秒", hour, min, sec];
        }
        else if (timeType == 2) {
            remainingTime = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
        }
        
    }
    else if (time >= 60) {
        min = time/60;
        sec = time-min*60;
        if (timeType == 1) {
            remainingTime = [NSString stringWithFormat:@"%02d分%02d秒", min, sec];
        }
        else if (timeType == 2) {
            remainingTime = [NSString stringWithFormat:@"00:%02d:%02d", min, sec];
        }
        
    }
    else if (time > 0) {
        sec = time;
        if (timeType == 1) {
            remainingTime = [NSString stringWithFormat:@"%02d秒", sec];
        }
        else if (timeType == 2) {
            remainingTime = [NSString stringWithFormat:@"00:00:%02d", sec];
        }
        
    }

    return remainingTime;
}

//获取一个随机整数，范围在[from,to]，包括from，包括to
CG_INLINE NSInteger getRandomNumber(NSInteger fromNB, NSInteger toNB) {
    return (NSInteger)(fromNB + (arc4random() % (toNB - fromNB + 1)));
}

/**
 *  修改图片颠倒问题
 */
CG_INLINE CGImageRef imageCorrection (CGImageRef im) {
    
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, [UIScreen mainScreen].scale);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    
    UIGraphicsEndImageContext();
    
    return result;
}


#pragma mark - **************** 获取设备相关信息 **************** -

#define DEVEICE_UUID        @"DEVEICE_UUID"
#define DEVEICE_MODEL_NAME  @"DEVEICE_MODEL_NAME"
#define DEVEICE_RESOLUTION  @"DEVEICE_RESOLUTION"
#define DEVEICE_PX          @"DEVEICE_PX"
#define DEVEICE_PPI         @"DEVEICE_PPI"
#define DEVEICE_CPU         @"DEVEICE_CPU"
#define DEVEICE_MEMORY      @"DEVEICE_MEMORY"

//获取设备当前系统版本
CG_INLINE NSString *getDeveiceSystemVersion()
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    return [NSString stringWithFormat:@"iOS %@", version];
}

//获取设备唯一标示符(uuid每次都会变)
CG_INLINE NSString *getDeveiceUUID()
{
    NSString *uuid = nil;
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return filterValue(uuid);
}

//获取广告标示符（IDFA-identifierForIdentifier）
CG_INLINE NSString *getDeveiceIDFA()
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return !stringIsEmpty(adId) ? adId : @"未知";
}

//获取设备型号
CG_INLINE NSArray *getDeveiceModelName()
{
    NSArray *modelNameAry = [[NSUserDefaults standardUserDefaults] objectForKey:DEVEICE_MODEL_NAME];
    if (arrayIsEmpty(modelNameAry)) {
        struct utsname systemInfo;  //这是 LINUX 系统放硬件版本的信息的地方
        uname(&systemInfo);
        
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        //列表最新对照表 https://www.theiphonewiki.com/wiki/Models
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DeviceConstantInfo" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSDictionary *deveiceModelName = [dic objectForKey:@"deveiceModelName"];
        modelNameAry = [deveiceModelName objectForKey:deviceString];
    
        //保存为设备型号
        [[NSUserDefaults standardUserDefaults] setObject:modelNameAry forKey:DEVEICE_MODEL_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    //NSLog(@"----设备类型--- %@", modelNameString);
    return modelNameAry;
}

//获取设备物理内存RAM(以 G 为单位)
CG_INLINE NSString *getDeveiceMemory()
{
    NSString *memoryString = [[NSUserDefaults standardUserDefaults] objectForKey:DEVEICE_MEMORY];
    
    if (stringIsEmpty(memoryString)) {
        unsigned long long physicalMemory = 0.f;
        double unit = 1024 * 1024 * 1024;
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        physicalMemory = [processInfo physicalMemory];
        // iOS 6 之后弃用
        //physicalMemory = NSRealMemoryAvailable();
        physicalMemory = ceil(physicalMemory / unit);
        memoryString = [NSString stringWithFormat:@"%.llu", physicalMemory];
        
        [[NSUserDefaults standardUserDefaults] setObject:memoryString forKey:DEVEICE_MEMORY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return filterValue(memoryString);
}

//获取设备分辨率(像素)
CG_INLINE NSString *getDeveiceResolution()
{
    NSString *resolutionString = [[NSUserDefaults standardUserDefaults] objectForKey:DEVEICE_RESOLUTION];
    
    if (stringIsEmpty(resolutionString)) {
        CGFloat scale = [UIScreen mainScreen].scale;
        resolutionString = [NSString stringWithFormat:@"%.f x %.f px", SCR_WIDTH*scale, SCR_HEIGHT*scale];
        //NSLog(@"resolutionString = %@", resolutionString);
        
        [[NSUserDefaults standardUserDefaults] setObject:resolutionString forKey:DEVEICE_RESOLUTION];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return filterValue(resolutionString);
}

//获取设备像素密度PPI (单位:即像素/英寸)
CG_INLINE NSString *getDeveicePPI()
{
    NSString *ppiString = [[NSUserDefaults standardUserDefaults] objectForKey:DEVEICE_PPI];
    
    if (stringIsEmpty(ppiString)) {
        //像素密度（像素/英寸）
        CGFloat ppi = 0.f;
        //屏幕尺寸（英寸）
        CGFloat size = 0.f;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat total = (SCR_WIDTH*scale)*(SCR_WIDTH*scale)+(SCR_HEIGHT*scale)*(SCR_HEIGHT*scale);
        if (SCR_HEIGHT*scale == 480) {
            size = 3.5f;
            //ppi = 163.0f;
            //逻辑分辨率(point)：320 * 480
            //物理分辨率(pixel)：320 * 480
            //机型：iPhone3GS
        }
        else if (SCR_HEIGHT*scale == 960) {
            size = 3.5f;
            //ppi = 326.f;
            //逻辑分辨率(point)：320 * 480
            //物理分辨率(pixel)：640 * 960
            //机型：iPhone4、iPhone4S
        }
        else if (SCR_HEIGHT*scale == 1136) {
            size = 4.f;
            //ppi = 326.f;
            //逻辑分辨率(point)：320 * 568
            //物理分辨率(pixel)：640 * 1136
            //机型：iPhone5、iPhone5C、iPhone5S、iPhoneSE
        }
        else if (SCR_HEIGHT*scale == 1334) {
            size = 4.7f;
            //ppi = 326.f;
            //逻辑分辨率(point)：375 * 667
            //物理分辨率(pixel)：750 * 1334
            //机型：iPhone6、iPhone6S、iPhone7、iPhone8
        }
        else if (SCR_HEIGHT*scale == 2208) {
            size = 5.5f;
            total = (1080*1080)+(1920*1920);
            //ppi = 401.f;
            //逻辑分辨率(point)：414 * 736
            //物理分辨率(pixel)：1080 * 1920 (<-- 1242 * 2208)
            //机型：iPhone6 Plus、iPhone6S Plus、iPhone7 Plus、iPhone8 Plus
        }
        else if (SCR_HEIGHT*scale == 2436) {
            size = 5.8f;
            //ppi = 458.f;
            //逻辑分辨率(point)：375 * 812
            //物理分辨率(pixel)：1125 * 2436
            //机型：iPhoneX
        }
        ppi = ceilf(sqrtf(total) / size);
        ppiString = [NSString stringWithFormat:@"%.f ppi", ppi];
        //NSLog(@"PPI = %@", ppiString);
        [[NSUserDefaults standardUserDefaults] setObject:ppiString forKey:DEVEICE_PPI];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return filterValue(ppiString);
}

//获取设备CPU型号
CG_INLINE NSString *getDeveiceCPU()
{
    NSString *cpuString = [[NSUserDefaults standardUserDefaults] objectForKey:DEVEICE_CPU];
    cpuString = nil;
    if (stringIsEmpty(cpuString)) {
        NSMutableString *cpuStr = [[NSMutableString alloc] init];
        //方法一：(引入头文件：#import <mach-o/arch.h>)
        const NXArchInfo *archInfo = NXGetLocalArchInfo();
        cpu_type_t type = archInfo -> cputype;
        cpu_subtype_t subtype = archInfo -> cpusubtype;
        //NSLog(@"cputype = %d, subtype = %d", type, subtype);
        if (type == CPU_TYPE_X86) {//模拟器
            [cpuStr appendString:@"X86"];
        }
        else if (type == CPU_TYPE_ARM64) {//真机
            [cpuStr appendString:@"ARM_"];
            switch (subtype) {
                case CPU_SUBTYPE_ARM_V4T:
                    [cpuStr appendString:@"V4T"];
                    break;
                case CPU_SUBTYPE_ARM_V6:
                    [cpuStr appendString:@"V6"];
                    break;
                case CPU_SUBTYPE_ARM_V5TEJ:
                    [cpuStr appendString:@"V5TEJ"];
                    break;
                case CPU_SUBTYPE_ARM_XSCALE:
                    [cpuStr appendString:@"XSCALE"];
                    break;
                case CPU_SUBTYPE_ARM_V7:
                    [cpuStr appendString:@"V7"];
                    break;
                case CPU_SUBTYPE_ARM_V7F:
                    [cpuStr appendString:@"V7F"];
                    break;
                case CPU_SUBTYPE_ARM_V7S:
                    [cpuStr appendString:@"V7S"];
                    break;
                case CPU_SUBTYPE_ARM_V7K:
                    [cpuStr appendString:@"V7K"];
                    break;
                case CPU_SUBTYPE_ARM_V6M:
                    [cpuStr appendString:@"V6M"];
                    break;
                case CPU_SUBTYPE_ARM_V7M:
                    [cpuStr appendString:@"V7M"];
                    break;
                case CPU_SUBTYPE_ARM_V7EM:
                    [cpuStr appendString:@"V7EM"];
                    break;
                case CPU_SUBTYPE_ARM_V8:
                    [cpuStr appendString:@"V8"];
                    break;
                case CPU_SUBTYPE_ARM64_V8:
                    [cpuStr appendString:@"ARM64_V8"];
                    break;
                case CPU_SUBTYPE_ARM64_ALL:
                    [cpuStr appendString:@"ARM64_ALL"];
                    break;
                default:
                    [cpuStr appendString:@"UNKNOWN"];
                    break;
            }
            cpuString = [NSString stringWithString:cpuStr];
            //NSLog(@"cpuString = %@", cpuString);
            [[NSUserDefaults standardUserDefaults] setObject:cpuString forKey:DEVEICE_CPU];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        //方法二：（引入头文件：#import <sys/sysctl.h>）
        /*
        NSMutableString *cpu = [[NSMutableString alloc] init];
        size_t size;
        cpu_type_t type;
        cpu_subtype_t subtype;
        size = sizeof(type);
        sysctlbyname("hw.cputype", &type, &size, NULL, 0);
        
        size = sizeof(subtype);
        sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
        
        // values for cputype and cpusubtype defined in mach/machine.h
        if (type == CPU_TYPE_X86) {
            [cpu appendString:@"x86 "];
            // check for subtype ...
            
        } 
         else if (type == CPU_TYPE_ARM) {
            [cpu appendString:@"ARM"];
            [cpu appendFormat:@",Type:%d",subtype];
        }
        NSLog(@"cpu = %@", cpu);
         */
    }
    
    return filterValue(cpuString);
}

//获取设备当前手机卡网络制式
CG_INLINE NSString *getDeveiceNetworkType() {
    //创建一个CTTelephonyNetworkInfo对象
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
    //获取当前网络描述
    NSString *currentStatus = networkStatus.currentRadioAccessTechnology;
    NSString *networkType = @"未知";
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
        //GPRS网络
        networkType = @"2G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
         //2.75G的EDGE网络
        networkType = @"2.75G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]) {
        //3G WCDMA网络
        networkType = @"3G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]) {
        //3.5G网络
        networkType = @"3.5G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]) {
        //3.5G网络
        networkType = @"3.5G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        //CDMA2G网络
        networkType = @"2G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
        //CDMA的EVDORev0(应该算3G吧?)
        networkType = @"3G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
        //CDMA的EVDORevA(应该也算3G吧?)
        networkType = @"3G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        //CDMA的EVDORev0(应该还是算3G吧?)
        networkType = @"3G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        //eHRPD网络(电信)
        networkType = @"4G";
    }
    else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]) {
         //LTE4G网络
        networkType = @"4G";
    }
    return networkType;
}

//获取设备当前网络运营商
CG_INLINE NSString *getDeveiceNetworkName() {
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *currentCarrier = networkStatus.subscriberCellularProvider;
    //参照表https://en.wikipedia.org/wiki/Mobile_country_code
    NSString *carrierName = currentCarrier.carrierName;
    //MCC(中国：460)
    //NSString *mobileCountryCode = currentCarrier.mobileCountryCode;
    //MNC(中国移动：00、02、07  中国联通：01、06、09  中国电信：03、05、11  中国铁通：20  Global Star Satellite：04)
    //NSString *mobileNetworkCode = currentCarrier.mobileNetworkCode;
    
    //NSDictionary *dic = @{@"carrierName":carrierName, @"mobileCountryCode":mobileCountryCode, @"mobileNetworkCode":mobileNetworkCode};
    if (stringIsEmpty(carrierName)) {
        carrierName = @"未知";
    }
    return carrierName;
}


//获取 APP 详情信息
CG_INLINE NSDictionary *getAppInfoByAppID(NSString *appID) {
    //eg:1001244846  931449079  917670924
    NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID]; //id = iTunes connect 中的Apple ID(也是下面字典中的trackId)
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSData *jsonData = [results dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        dic = nil;
    }
    //NSDictionary *dic = [results objectFromJSONString];
    //NSLog(@"dic = %@", dic);
    return dic;
}

CG_INLINE CGFloat MDTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
}


#pragma mark - 获取 Xcode 项目配置信息 -
/**
 *  获取 BundleId
 */
CG_INLINE NSString *getProjectBundleIdentifier() {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *result = [infoDictionary valueForKey:@"CFBundleIdentifier"];
    
    return result;
}

/**
 *  获取 Version 版本号
 */
CG_INLINE NSString *getProjectVersionString() {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *result = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
    
    return result;
}

/**
 *  获取 build 号
 */
CG_INLINE NSString *getProjectBuildString() {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *result = [infoDictionary valueForKey:@"CFBundleVersion"];
    
    return result;
}

/**
 *  获取显示的名字
 */
CG_INLINE NSString *getProjectDisplayName() {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *result = [infoDictionary valueForKey:@"CFBundleDisplayName"];
    
    return result;
}






