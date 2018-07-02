//
//  AppDelegate.m
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "AppDelegate.h"
#import "HandleOpenUrlManager.h"
#import "WXApi.h"
#import "NSString+URLEncoding.h"
#import "MDTabBarManager.h"
#import "LSFileManage.h"
#import "MDCacheFileManager.h"
#import "MDExceptionManager.h"
#import "EncryptionMethods.h"
#import "SAMKeychain.h"
#import "ServerConfigManager.h"
#import "MDDeviceManager.h"

@interface AppDelegate() <WXApiDelegate, UIAlertViewDelegate>
{
    AFNetworkReachabilityManager *_reachablity;
}

@end

@implementation AppDelegate

//1.若用户直接启动，lauchOptions 内无数据;
//2.若由其他应用程序通过 openURL：启动，则 UIApplicationLaunchOptionsURLKey 对应的对象为启动URL（NSURL），UIApplicationLaunchOptionsSourceApplicationKey 对应启动的源应用程序的 bundle ID（NSString）；
//3.若由本地通知启动，则 UIApplicationLaunchOptionsLocalNotificationKey 对应的是为启动应用程序的的本地通知对象（UILocalNotification）；
//4.若由远程通知启动，则 UIApplicationLaunchOptionsRemoteNotificationKey 对应的是启动应用程序的的远程通知信息userInfo（NSDictionary）；
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options
{
    [self setupDeviceId];
    
    [self getDeviceIdentify];
    
    [self setupWeex];
    
    [self configWindow];
    
    [self startMonitorNetworkState];
    
    [self configAPNs];
    
    //向微信注册您的APPID，代码如下：
    [WXApi registerApp:APP_ID_WECHAT];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 由于使用听云 暂时关闭本地 crash 的捕获(v2.9.1)
        // [MDExceptionManager checkLocalException];
        //清除缓存
        [MDCacheFileManager autoReleaseLocalStorage];
        
    });
    //记录用户留存
    [[UserManager sharedInstance] recordLoginTime];
    
    //暂时关闭定位服务
    //_appLocation = [[LSLocation alloc] init];
    
    // 配置数美SDK
    [self configSMSDK];
    
    //抓取程序崩溃方法，在程序崩溃前调用 (由于使用听云 暂时关闭本地 crash 的捕获 v2.9.1)
    // NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //3D Touch
    if (IOS_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self createShortcutItem];
    }
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    // Internal error reporting
    [MDExceptionManager saveException:exception];
    DLog(@"**********************  AppDelegate -> uncaughtExceptionHandler START **********************");
    DLog(@"ExceptionName: %@", exception.name);
    DLog(@"Reason: %@", exception.reason);
    DLog(@"UserInfo: %@", exception.userInfo);
    DLog(@"Exception: %@", exception);
    DLog(@"Stack Trace: %@", [exception callStackSymbols]);
    DLog(@"**********************   AppDelegate -> uncaughtExceptionHandler END  *********************");
}

- (void)configWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = COLOR_WITH_WHITE;
    
    if ([kPerpetratingAFraud isEqualToString:@"0"]) {
        //不需要用原生的展示
        _isApproved = YES;
        [[NSUserDefaults standardUserDefaults] setBool:_isApproved forKey:kAppApproved];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self addChildControllers];
    }
    else {
        //需要用原生的展示
        _isApproved = [[NSUserDefaults standardUserDefaults] boolForKey:kAppApproved];
        if (_isApproved) {
            //审核已通过
            [self addChildControllers];
        }
        else {
            //审核ing
        }
    }
}

- (void)setupWeex
{
    // 初始化 weex 环境
//    [WXSDKEngine initSDKEnvironment];
//    [WXSDKEngine registerHandler:[MDWeexImageLoader new] withProtocol:@protocol(WXImgLoaderProtocol)];
}

- (void)getDeviceIdentify
{
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:KDeviceID];
    if (!stringIsEmpty(deviceId)) {
        DLog(@"沙河中的设备号 %@",deviceId);
        [MDDeviceManager sharedInstance].deviceIden = deviceId;
        return ;
    }
    NSError *error = nil;
    NSString *device_id = [SAMKeychain passwordForService:kService account:kAccount error:&error];
    if (!stringIsEmpty(device_id) && !error) {
        [[NSUserDefaults standardUserDefaults] setObject:device_id forKey:KDeviceID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        DLog(@"钥匙串中取设备号 %@",device_id);
        [MDDeviceManager sharedInstance].deviceIden = device_id;
    }
    else {
        NSError *saveError = nil;
        NSString *uuid = getDeveiceUUID();
        [[NSUserDefaults standardUserDefaults] setObject:filterValue(uuid) forKey:KDeviceID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MDDeviceManager sharedInstance].deviceIden = uuid;
        [SAMKeychain setPassword:filterValue(uuid) forService:kService account:kAccount error:&saveError];
        if (saveError || error) {
            NSString *errorStr = @"";
            if (saveError) {
                errorStr = [NSString stringWithFormat:@"saveDomain:%@,saveCode:%ld",saveError.domain,saveError.code];
            }
            if (error) {
                errorStr = [NSString stringWithFormat:@"%@,getDomain:%@,getCode:%ld",errorStr,error.domain,error.code];
            }
            DLog(@"钥匙串error%@",errorStr);
            [self sendKeychainSaveError:saveError getError:error];
        }
        DLog(@"钥匙串中存设备号 %@",uuid);
    }
}


- (void)sendKeychainSaveError:(NSError *)saveError getError:(NSError *)getError
{
    NSString *errorStr = @"";
    if (saveError) {
        errorStr = [NSString stringWithFormat:@"saveDomain:%@,saveCode:%ld,saveInfo:%@",saveError.domain,saveError.code,saveError.userInfo];
    }
    if (getError) {
        errorStr = [NSString stringWithFormat:@"%@,getDomain:%@,getCode:%ld,getInfo:%@",errorStr,getError.domain,getError.code,getError.userInfo];
    }
    
    NSDictionary *uploadDataInfoDict = @{@"keychainerror" : stringIsEmpty(errorStr) ? @"" : errorStr};
    
    NSString *jsonStr = @"";//[uploadDataInfoDict JSONString];
    
    NSDictionary *para = @{@"content" : stringIsEmpty(jsonStr) ? @"" : jsonStr};
    
}

- (void)addChildControllers
{
    if (!_rvc) {
//        //处理8系统的莫名崩溃
//        if (IOS_LESS_THAN(@"9.0")) {
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                _rvc = [[MDTabBarController alloc] init];
//                _rvc.view.backgroundColor = COLOR_WITH_WHITE;
//                _navigation = [[MDNavigationController alloc] initWithRootViewController:_rvc];
//                [MDDeviceManager sharedInstance].window = self.window;
//                [MDDeviceManager sharedInstance].navigation = self.navigation;
//                self.window.rootViewController = _navigation;
//                [self.window makeKeyAndVisible];
//                _rvc.tabbar.selectedIndex = 2;
//            });
//        }
//        else {
            _rvc = [[MDTabBarController alloc] init];
            _rvc.view.backgroundColor = COLOR_WITH_WHITE;
            _navigation = [[MDNavigationController alloc] initWithRootViewController:_rvc];
            [MDDeviceManager sharedInstance].window = self.window;
            [MDDeviceManager sharedInstance].navigation = self.navigation;
            self.window.rootViewController = _navigation;
            [self.window makeKeyAndVisible];
            //[self performSelector:@selector(setTabTest:) withObject:nil afterDelay:1.f];
            _rvc.tabbar.selectedIndex = 2;
//        }
    }
}



- (void)startMonitorNetworkState
{
    _reachablity = [AFNetworkReachabilityManager sharedManager];
    [_reachablity startMonitoring];
}

- (void)setupDeviceId
{
    NSString *device_id = [[NSUserDefaults standardUserDefaults] objectForKey:kCustomDeviceId];
    if (!device_id) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *string_time = [self convertDecimalTo36HexStr:time];
        NSString *string_uuid = [[Util getUUIDString] lowercaseString];
        NSString *string_1 = [NSString stringWithFormat:@"%@_%@", string_time, string_uuid];
        
        NSString *string_key = @"md_app_zues_20180101";
        NSString *string_md5 = [NSString stringWithFormat:@"%@_%@_%@", string_time, string_uuid, string_key];
        string_md5 = [Util md5:string_md5];
        
        device_id = [NSString stringWithFormat:@"%@_%@", string_1, string_md5];
        [[NSUserDefaults standardUserDefaults] setObject:device_id forKey:kCustomDeviceId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 10进制数字转换为36进制字符串
 
 @param decimal 10进制数字
 
 @return 36进制的字符串
 */
- (NSString *)convertDecimalTo36HexStr:(unsigned long long)decimal
{
    NSMutableString *dd = @"".mutableCopy;
    NSString *parma =@"0123456789abcdefghijklmnopqrstuvwxyz";
    unsigned long long i = decimal;
    while(i > 0){
        int c = i % 36;
        i = i / 36;
        char cc = [parma characterAtIndex:c];
        [dd insertString:[NSString stringWithFormat:@"%c", cc] atIndex:0];
    }
    return dd;
}


- (void)createShortcutItem
{
    //自定义icon 的初始化方法
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tabbar_home"];
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:kTouchShouYe localizedTitle:@"推荐" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tabbar_store"];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:kTouchShangCheng localizedTitle:@"商城" localizedSubtitle:nil icon:icon2 userInfo:nil];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tabbar_social"];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:kTouchSheQu localizedTitle:@"发现" localizedSubtitle:nil icon:icon3 userInfo:nil];
    
    NSArray *addArr = @[item3, item2, item1];
    [UIApplication sharedApplication].shortcutItems = addArr;
}


- (void)configSMSDK
{
//    SmOption *option = [[SmOption alloc] init];
//    //传入 organization，不要传入 accessKey.
//    [option setOrganization:SM_ORGANIXSTION];
//    // 传入渠道标识
//    [option setChannel:@"appStore"];
//    // 可选的异步处理，设置回调监听 拉取服务端 deviceId 的事件，
//    // 本地 deviceId 与服务器端 deviceId 同步是需要一点时间的
//    [option setCallback:^(NSString *serverId) {
//        DLog(@"server id:%@", serverId);
//
//    }];
//
//    [[SmAntiFraud shareInstance] create:option];
    // 不要缓存 deviceId，在真正注册或登录事件发生时调用下面接口获得 deviceId
    // 因为本地 deviceId 与服务器端 deviceId 同步是需要一点时间的
    
    // getDeviceId()接口在真正需要 DeviceId 时再进行调用。
    // 不要再 create 后立即调用。也不要缓存调用的结果，getDeviceId 在 sdk 内部会 做缓存和更新处理。
    // (create 后立即调用会返回本地生成的没有和 server 同步的 ID)
    //NSString *deviceId = [[SmAntiFraud shareInstance] getDeviceId];
}

- (NSString *)getSMDeviceId
{
    // 不要缓存 deviceId，在真正注册或登录事件发生时调用下面接口获得 deviceId
    // 因为本地 deviceId 与服务器端 deviceId 同步是需要一点时间的
    
    // getDeviceId()接口在真正需要 DeviceId 时再进行调用。
    // 不要再 create 后立即调用。也不要缓存调用的结果，getDeviceId 在 sdk 内部会 做缓存和更新处理。
    // (create 后立即调用会返回本地生成的没有和 server 同步的 ID)
    NSString *sm_deviceId = @"";//[[SmAntiFraud shareInstance] getDeviceId];
    if (stringIsEmpty(sm_deviceId)) {
        sm_deviceId = @"未知";
    }
    return sm_deviceId;
}

#pragma mark - UIApplicationDelegate -
// 深度跳转回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return YES;
    }
    
    // md://ymfashion/params?
    //FOUNDATION_EXTERN NSString *const baseStrJump;
    NSString *const baseStrJump = @"";
    // http://ios.ymfashion.com
    NSURL *webpageURL = userActivity.webpageURL;
    [self checkUrlParamsWithUrlString:webpageURL.absoluteString];
    if (webpageURL.query) {
        NSString *jumpString = [NSString stringWithFormat:@"%@%@", baseStrJump, webpageURL.query];
        //[[[BaseJumpModel alloc] initWithUrlString:jumpString] handelJump];
    }
    
    return YES;
}

- (void)checkUrlParamsWithUrlString:(NSString *)urlString
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

//程序将要从后台恢复挂起的时候调用每次启动的时候也会调用
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (LOGIN_USER && [LOGIN_USER uid]) {
        [self requestMaxShootDuration];
    }
    else {
        [self refreshUploadInfo];
    }
    
    [self requestSeverConfig];
//    [[ApnsService sharedInstance] bindGetuiIfNeed];
//    [[AppNotificationManager sharedInstance] collectApnsInfoIfNeed];
    
    //暂时关闭定位服务
    //[_appLocation startUpdatingLocation];
}

- (void)requestSeverConfig
{
    NSDictionary *dic = [Util getDeviceInfo];
    
    // 获取上传位置信息
}


- (void)refreshUploadInfo
{
    // 清空本地存储的发布上传 位置信息
    [[UserManager sharedInstance] loginUser].aliAccess = nil;
    [[UserManager sharedInstance] archivertUserInfo];
}

//程序将要挂起时执行，如接电话、锁屏时、按home键时
- (void)applicationWillResignActive:(UIApplication *)application
{
    XLog(@"%s", __func__);
    //[[PlayerManager shareManager] cancelAllIsPostNotification:NO];
    
    //[[ApnsService sharedInstance] stopService];
    
    //暂时关闭定位服务
    //[_appLocation stopUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    XLog(@"%s", __func__);
    
    //[[PlayerManager shareManager] pauseAllIsPostNotification:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];    //on line
    XLog(@"%s", __func__);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //[MediaResourcesManager singletonDealloc];
    XLog(@"%s", __func__);
}

//程序将要终止时执行
- (void)applicationWillTerminate:(UIApplication *)application
{
    XLog(@"%s", __func__);
}


#pragma mark - Application Remote Notifications 远程推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[ApnsService sharedInstance] registerDeviceToken:deviceToken];
//    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
//    [[AppNotificationManager sharedInstance] collectApnsInfoIfNeed];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    XLog(@"注册远程推送通知失败: %@", error);
    //[[ApnsService sharedInstance] registerDeviceToken:nil];
}

/** APP已经接收到“远程”通知(静默推送) - 透传推送消息（在后台点击通知跳转进来） */
// iOS7-iOS9点击消息进入app，走此方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if (userInfo && application.applicationState == UIApplicationStateActive) {
        //这是程序运行的时候，收到通知[这时推送直接调此方法]
        DLog(@"在前台");
    }
    else if (userInfo && application.applicationState == UIApplicationStateInactive) {
        //[[AppNotificationManager sharedInstance] handleReceiveRemoteNotification:userInfo];
    }
    else if (userInfo&&application.applicationState == UIApplicationStateBackground) {
        DLog(@"在后台");
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - handleOpenURL -
//iOS 9 弃用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[HandleOpenUrlManager sharedInstance] hanleOpenURL:url sourceApplication:sourceApplication];
}

//iOS 9 Later Method
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSString *sourceApp = [options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey];
    return [[HandleOpenUrlManager sharedInstance] hanleOpenURL:url sourceApplication:sourceApp];
}

#pragma mark - 本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    XLog(@"didReceiveLocalNotification：%@", notification);
}

#pragma mark - 3D Touch -
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    //判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:kTouchShouYe]) {
        [self.rvc.selectedViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        if ([self.rvc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = self.rvc.selectedViewController;
            [nvc popToRootViewControllerAnimated:NO];
        }
        _rvc.tabbar.selectedIndex = 0;
    }
    else if ([shortcutItem.type isEqualToString:kTouchShangCheng]) {
        [self.rvc.selectedViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        if ([self.rvc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = self.rvc.selectedViewController;
            [nvc popToRootViewControllerAnimated:NO];
        }
        _rvc.tabbar.selectedIndex = 2;
    }
    else if ([shortcutItem.type isEqualToString:kTouchSheQu]) {
        [self.rvc.selectedViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        if ([self.rvc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = self.rvc.selectedViewController;
            [nvc popToRootViewControllerAnimated:NO];
        }
        _rvc.tabbar.selectedIndex = 3;
    }
}

//end of AppDelegate Methods

#pragma mark - 对外接口
- (void)setTabBarSeletedIndex:(NSInteger)seletedIndex
{
    _rvc.tabbar.selectedIndex = seletedIndex;
}

#pragma mark - 获取最大拍摄时长 -
- (void)requestMaxShootDuration
{
}

#pragma mark - private methods
- (void)configAPNs
{
    // 进入app，把后台Badge数设置为0
//    [[MessageManager defaultManager] cleanRemoteBadge];
//
//    [ApnsService sharedInstance].delegate = [AppNotificationManager sharedInstance];
//    if ([[UserManager sharedInstance] getAppGeTuiNotifyStatus]) {
//        [[ApnsService sharedInstance] startService];
//    }
//    else {
//        [[ApnsService sharedInstance] unbindAlias:[LOGIN_USER uid]];
//        [[ApnsService sharedInstance] stopService];
//    }
}

// end of ApnsServiceDelegate
#pragma mark - public methods
- (void)apnsRegisterAlias:(NSString *)alias
{
    //[[ApnsService sharedInstance] bindAlias:alias];
}

- (BOOL)isClipFutureTipShowed
{
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"clip_future_tip_showed"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"clip_future_tip_showed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return result;
}

- (BOOL)canShowRecordStepTip
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"record_step_tip"];
    if(dict){
        NSInteger count = [dict[@"count"] integerValue];
        NSInteger time = [dict[@"time"] integerValue];
        NSNumber *currentTime = @([[NSDate date] timeIntervalSince1970]);
        if(currentTime.integerValue - time > 7 * 24 * 60 * 60){
            count = 0;
            NSDictionary *newDict = @{@"count":@0,@"time":currentTime};
            [[NSUserDefaults standardUserDefaults] setObject:newDict forKey:@"record_step_tip"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if(count < 7){
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
}

- (void)addRecordStepTipShowCount
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"record_step_tip"];
    NSNumber *currentTime = @([[NSDate date] timeIntervalSince1970]);
    if(!dict){
        dict = @{@"count":@0,@"time":currentTime};
    }
    NSInteger count = [dict[@"count"] integerValue] + 1;
    NSDictionary *newDict = @{@"count":@(count),@"time":currentTime};
    [[NSUserDefaults standardUserDefaults] setObject:newDict forKey:@"record_step_tip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

