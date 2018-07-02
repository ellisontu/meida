//
//  UserManager.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

#define LOGIN_USER  [[UserManager sharedInstance] loginUser]

typedef NS_ENUM(NSUInteger, SaveTypes) {
    SaveTheNickType,            /**< 昵称 */
    SaveTheIconType,            /**< 头像 */
    SaveTheDescriptionsType,    /**< 简介 */
    SaveTheSexType,             /**< 性别 */
    SaveTheBackGroundType,      /**< 背景 */
    SaveTheFollowType,          /**< 关注 */
    SaveTheReleaseType,         /**< 发布 */
    SaveTheColloectType,        /**< 收藏 */
    SaveTheMessageType,         /**< 消息 */
    SaveTheLipPrintType,        /**< 唇印 */
};

typedef NS_ENUM(NSUInteger, BrowseTypes) {
    SaveTheSearchContentVideoType,  /**< 视频 */
    SaveTheSearchContentPhotoType,  /**< 晒单 */
    SaveTheSearchContentOtherType   /**< 其他 */
};

@interface UserManager : NSObject

@property (nonatomic, strong) UserModel      *loginUser;
@property (nonatomic, strong) NSString       *loginUID;
@property (nonatomic, assign) MDSourceType  sourceType;
@property (nonatomic, strong) NSMutableArray *likeArray;

+ (UserManager *)sharedInstance;

#pragma mark - 用户信息
/**
 退出登录
 */
- (void)logOut;
/**
 *  保存用户信息到偏好
 */
+ (void)saveUserInfo:(id)jsonObj;

/**
 *  归档
 */
- (void)archivertUserInfo;

/**
 *  更新用户信息
 */
+ (void)updateUserInfoWithType:(SaveTypes)types Info:(id)info;

#pragma mark - 视频相关
/**
 *  是否开启自动播放
 */
- (BOOL)isAutoPlay;

/**
 *  设置自动播放
 */
- (void)setAutoPlay:(BOOL) isauto;

/**
 *  设置通知 PS: 天(S)才(B)产品说，只用来管理个推
 */
- (void)setAppGeTuiNotify:(BOOL)isOn;

/**
 * 获取是否开启了通知
 */
- (BOOL)getAppGeTuiNotifyStatus;

/**
 *  添加 发布视频水印数量?
 */
- (void)addPublishWatermarkShowedCnt;

/**
 *  是否显示水印或添加水印?
 */
- (BOOL)needShowWatermarkTip;


#pragma mark - 搜索浏览记录
/**
 *  保存用户浏览的搜索结果(内容)
 */
- (void)saveUserBrowseRecordWithSearchContentID:(NSNumber *)contentID contentType:(BrowseTypes)contentType;

/**
 *  获取用户浏览的搜索结果(内容)
 */
- (NSMutableArray *)acquireUserBrowseRecordWithSearchContentType:(BrowseTypes)contentType;

#pragma mark - 推送消息

/**
 *  活跃统计
 */
- (void)recordLoginTime;

//#pragma mark - 记录4G下用户已经允许视频播放
///**
// *  视频播放，用户已经在app中允许视频播放了，记录这个状态
// */
//- (void)setAllowUseViaWWAN:(BOOL)isAllow;
//- (BOOL)isAllowUseViaWWAN;

@end
