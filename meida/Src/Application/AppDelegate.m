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
#import "LocalFileManager.h"
#import "MDCacheFileManager.h"
#import "MDExceptionManager.h"
#import "EncryptionMethods.h"
#import "SAMKeychain.h"
#import "ServerConfigManager.h"
#import "MDDeviceManager.h"
#import "MediaResourcesManager.h"

@interface AppDelegate() <WXApiDelegate, UIAlertViewDelegate>
{
    AFNetworkReachabilityManager *_reachablity;
    LSLocation  *_appLocation;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options
{
    
    [self configWindow];
    
    [self startMonitorNetworkState];
    
    //向微信注册您的APPID，代码如下：
    [WXApi registerApp:APP_ID_WECHAT];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [MDCacheFileManager autoReleaseLocalStorage];
        
    });
    //记录用户留存
    [[UserManager sharedInstance] recordLoginTime];
    
    //暂时关闭定位服务
    _appLocation = [[LSLocation alloc] init];
    
    //抓取程序崩溃方法，在程序崩溃前调用
     NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
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
    
    [self addChildControllers];
}

- (void)addChildControllers
{
    if (!_rvc) {
        _rvc = [[MDTabBarController alloc] init];
        _rvc.view.backgroundColor = COLOR_WITH_WHITE;
        _navigation = [[MDNavigationController alloc] initWithRootViewController:_rvc];
        self.window.rootViewController = _navigation;
        [self.window makeKeyAndVisible];
        _rvc.tabbar.selectedIndex = 1;
    }
}



- (void)startMonitorNetworkState
{
    _reachablity = [AFNetworkReachabilityManager sharedManager];
    [_reachablity startMonitoring];
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


#pragma mark - UIApplicationDelegate -
// 深度跳转回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return YES;
    }
    
    // md://ymfashion/params?
    //NSString *const baseStrJump = @"";
    // http://ios.ymfashion.com
    NSURL *webpageURL = userActivity.webpageURL;
    [self checkUrlParamsWithUrlString:webpageURL.absoluteString];
    if (webpageURL.query) {
        //NSString *jumpString = [NSString stringWithFormat:@"%@%@", baseStrJump, webpageURL.query];
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
    //暂时关闭定位服务
    [_appLocation startUpdatingLocation];
}

//程序将要挂起时执行，如接电话、锁屏时、按home键时
- (void)applicationWillResignActive:(UIApplication *)application
{
    XLog(@"%s", __func__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    XLog(@"%s", __func__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];    //on line
    XLog(@"%s", __func__);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [MediaResourcesManager singletonDealloc];
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
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [[HandleOpenUrlManager sharedInstance] hanleOpenURL:url sourceApplication:sourceApplication];
//}

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
@end

