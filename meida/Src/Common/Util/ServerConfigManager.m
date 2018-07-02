//
//  ServerConfigManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "ServerConfigManager.h"


#pragma mark - ServerConfigModel -
@implementation ServerConfigModel

- (void)setComment:(NSDictionary *)comment
{
    _comment = comment;
    _limit = [_comment objectForKey:@"limit"];
}

- (void)setAd:(NSDictionary *)ad
{
    _ad = ad;
    _login = [ad objectForKey:@"login"];
}

- (void)setPerson_active:(NSDictionary *)person_active
{
    _person_active = person_active;
    _title = [_person_active objectForKey:@"title"];
    _url = [_person_active objectForKey:@"url"];
}

@end

#pragma mark - ServerConfigManager -
@implementation ServerConfigManager

+ (instancetype)sharedInstance
{
    static ServerConfigManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerConfigManager alloc] init];
    });
    return manager;
}

+ (void)initServerConfigManagerWithModel:(ServerConfigModel *)model
{
    [ServerConfigManager sharedInstance].model = model;
    
    //老拉新活动
    LOGIN_USER.title = model.title;
    LOGIN_USER.actUrl = model.url;
    
    // 上传位置信息
    if (model.oss_video_upload) {
        // 阿里云
        LOGIN_USER.aliAccess = model.oss_video_upload;
    }
    else {
        // 清空本地存储的发布上传 位置信息
        LOGIN_USER.aliAccess = nil;
    }

    [[UserManager sharedInstance] archivertUserInfo];
    
    // 会员信息
    if (LOGIN_USER && model.vip) {
        LOGIN_USER.vipInfo = model.vip;
    }
}



@end




