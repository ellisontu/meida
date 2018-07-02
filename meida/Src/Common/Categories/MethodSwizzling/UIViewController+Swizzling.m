//
//  UIViewController+Swizzling.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import "HookUtility.h"
#import "UserStatistics.h"
//#import "MethodSwizzling.h"

@interface UIViewController ()

@end

@implementation UIViewController (Swizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector_1 = @selector(viewWillAppear:);
        SEL swizzledSelector_1 = @selector(swiz_viewWillAppear:);
        [HookUtility swizzlingInClass:[self class] originalSelector:originalSelector_1 swizzledSelector:swizzledSelector_1];
        //[MethodSwizzling swizzlingInClass:[self class] originalSelector:originalSelector_1 swizzledSelector:swizzledSelector_1];
        
        SEL originalSelector_2 = @selector(viewDidDisappear:);
        SEL swizzledSelector_2 = @selector(swiz_viewWillDisappear:);
        [HookUtility swizzlingInClass:[self class] originalSelector:originalSelector_2 swizzledSelector:swizzledSelector_2];
        //[MethodSwizzling swizzlingInClass:[self class] originalSelector:originalSelector_2 swizzledSelector:swizzledSelector_2];
        
    });
}

- (void)configNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationWillEnterForegroundNotification
{
    NSString *currentClassName = [UserStatistics sharedInstance].currentClassName;
    NSString *pageID = [self pageEventID:YES];
    if ([currentClassName isEqualToString:pageID]) {
        [self inject_viewWillAppear];
    }
}

- (void)applicationDidEnterBackgroundNotification
{
    NSString *currentClassName = [UserStatistics sharedInstance].currentClassName;
    NSString *pageID = [self pageEventID:YES];
    if ([currentClassName isEqualToString:pageID]) {
        [self inject_viewWillDisappear];
    }
}

#pragma mark - Method Swizzling -
- (void)swiz_viewWillAppear:(BOOL)animated
{
    //插入需要执行的代码
    [self inject_viewWillAppear];
    [self swiz_viewWillAppear:animated];
    //添加进入后台和前台通知
    [self configNotification];
}

- (void)swiz_viewWillDisappear:(BOOL)animated
{
    [self inject_viewWillDisappear];
    [self swiz_viewWillDisappear:animated];
}

//利用hook 统计所有页面的停留时长
- (void)inject_viewWillAppear
{
    NSString *pageID = [self pageEventID:YES];
    if (pageID) {
        [UserStatistics sharedInstance].currentClassName = pageID;
        //[[UserStatistics sharedInstance] enterPageViewWithPageID:pageID];
        [UserStatistics enterPageViewWithPageID:pageID];
        //[UserStatistics sendEventToServer:pageID];
    }
}

- (void)inject_viewWillDisappear
{
    NSString *pageID = [self pageEventID:YES];
    if (pageID) {
        //[[UserStatistics sharedInstance] leavePageViewWithPageID:pageID];
        [UserStatistics leavePageViewWithPageID:pageID];
        //[UserStatistics sendEventToServer:pageID];
    }
}

- (NSString *)pageEventID:(BOOL)bEnterPage
{
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    return configDict[selfClassName][@"PageEventIDs"];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}




@end
