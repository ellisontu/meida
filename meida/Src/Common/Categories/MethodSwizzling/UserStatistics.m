//
//  UserStatistics.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UserStatistics.h"

@interface UserStatistics ()

@property (nonatomic, strong) NSMutableDictionary *startTimeDic;

@end


@implementation UserStatistics

/**
 *  初始化配置，一般在launchWithOption中调用
 */
+ (void)configure
{
    
}

+ (UserStatistics *)sharedInstance
{
    static UserStatistics *userStatistics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userStatistics = [[UserStatistics alloc] init];
        userStatistics.startTimeDic = [NSMutableDictionary dictionary];
    });
    return userStatistics;
}

#pragma mark -- 页面统计部分
+ (void)enterPageViewWithPageID:(NSString *)pageID
{
    //进入页面
    DLog(@"*** [进入页面]事件，页面ID:%@------Enter------", pageID);
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [[UserStatistics sharedInstance].startTimeDic setObject:@(startTime) forKey:pageID];
}

+ (void)leavePageViewWithPageID:(NSString *)pageID
{
    //离开页面
    DLog(@"*** [离开页面]事件，页面ID:%@------Leave------", pageID);
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[UserStatistics sharedInstance].startTimeDic];
    NSInteger startTime = [[dic objectForKey:pageID] integerValue];
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger sumTime = endTime - startTime;
    DLog(@"*** [停留时间]:%zd 秒，页面ID:%@", sumTime, pageID);
    [[UserStatistics sharedInstance] addUserAnalyzeDataByPageName:pageID pageDuration:sumTime];
}

#pragma mark -- 自定义事件统计部分
+ (void)sendEventToServer:(NSString *)eventId
{
    //在这里发送event统计信息给服务端
    DLog(@"*** 发送统计事件给服务端，事件ID: %@", eventId);
}


- (void)addUserAnalyzeDataByPageName:(NSString *)pageName pageDuration:(NSInteger)pageDuration
{
    //暂时只添加首页推荐界面留存时间
    if ([pageName isEqualToString:@"GHomeRecommendVC"]) {
        pageName = @"home";
        UserAnalyticsModel *model = [[UserAnalyticsModel alloc] init];
        model.tableName = UserAnalyticsTableName_page_duration;
        model.page_duration = @(pageDuration);
        model.page_name = pageName;
        [model configLogMessageDictionary];
    }
    else if ([pageName isEqualToString:@"LipsDaySignVC"]) {
        pageName = @"beautySign";
        UserAnalyticsModel *model = [[UserAnalyticsModel alloc] init];
        model.tableName = UserAnalyticsTableName_page_duration;
        model.page_duration = @(pageDuration);
        model.page_name = pageName;
        [model configLogMessageDictionary];
    }
}


- (NSMutableDictionary *)startTimeDic
{
    if (!_startTimeDic) {
        _startTimeDic = [NSMutableDictionary dictionary];
    }
    return _startTimeDic;
}

@end
