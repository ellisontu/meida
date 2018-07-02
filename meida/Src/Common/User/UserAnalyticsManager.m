//
//  UserAnalyticsManager.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UserAnalyticsManager.h"
//#import "JSONKit.h"
#import "MDDeviceManager.h"

@implementation UserAnalyticsManager

+ (UserAnalyticsManager *)sharedAnalyticsManager
{
    static UserAnalyticsManager *manager = nil;
    static dispatch_once_t managerToken;
    dispatch_once(&managerToken, ^{
        manager = [[UserAnalyticsManager alloc] init];
        //改为每条都发送，现在服务器返回值也是1
        manager.maxLogMessageCount = 1;
    });
    return manager;
}


+ (void)recordStoreGoodsClickWithModelId:(NSNumber *)modelId source:(NSString *)source
{
    //dev:0,//设备类型 1 ios 2 android 3 web
    NSDictionary *dic = @{@"dev":@1, @"devid":filterValue([MDDeviceManager sharedInstance].deviceIden), @"source":source};
}


+ (void)analyzeBannerClickByModelId:(NSNumber *)modelId locationTag:(NSNumber *)locationTag source:(NSString *)source
{
}


+ (void)saveAnalyzeDataWithMessageJsonString:(NSString *)mesageStr
{
    // 将埋点获取的信息保存到本地
    //[UserAnalyticsManager cleanAnalyzeData];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kUserAnalyticsMessageArray]];
    [array addObject:mesageStr];
    NSInteger maxCount = [UserAnalyticsManager sharedAnalyticsManager].maxLogMessageCount;
    if (array.count >= maxCount) {
        //向服务器发送表单数据
        [UserAnalyticsManager sendUserAnalyzeFormDataWithArray:array];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kUserAnalyticsMessageArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+ (void)cleanAnalyzeData
{
    // 清空本地存储的埋点数据
    NSMutableArray *array = [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kUserAnalyticsMessageArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getAnalyzeDataCount
{
    // 获取本地存储的埋点数据条数
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kUserAnalyticsMessageArray]];
    return array.count;
}


+ (void)sendUserAnalyzeFormDataWithArray:(NSMutableArray *)formArray
{
}


@end




