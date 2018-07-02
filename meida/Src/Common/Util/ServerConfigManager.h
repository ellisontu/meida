//
//  ServerConfigManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ServerConfigModel -
@interface ServerConfigModel : BaseModel

@property (nonatomic, strong) NSDictionary *comment;            /**< 评论字数限制信息 */
@property (nonatomic, strong) NSNumber     *limit;              /**< 评论字数限制数 */
@property (nonatomic, strong) NSDictionary *ad;                 /**< 登录位广告信息 */
@property (nonatomic, strong) NSString     *login;              /**< 登录位广告字符串，不需要判断非空（可以为空）*/
@property (nonatomic, strong) NSString     *telephone;          /**< 客服电话 */
@property (nonatomic, strong) NSDictionary *person_active;      /**< 登录位广告信息 */
@property (nonatomic, strong) NSString     *title;              /**< 老拉新 活动标题（LOGIN_USER.title） */
@property (nonatomic, strong) NSString     *url;                /**< 老拉新 活动url（LOGIN_USER.actUrl） */
@property (nonatomic, strong) NSDictionary *oss_video_upload;   /**< 上传阿里的获取权限接口（LOGIN_USER.aliAccess）*/
@property (nonatomic, strong) NSDictionary *styles;             /**< severconfig 获取的图片信息 */
@property (nonatomic, strong) NSDictionary *version;            /**< 版本信息 */
@property (nonatomic, strong) NSString     *customer;           /**< 客服信息 */
@property (nonatomic, strong) NSNumber     *vip;                /**< 会员信息（LOGIN_USER.vipInfo） */
@property (nonatomic, strong) NSDictionary *person_invitation;  /**< 邀请好友开会员 */
@property (nonatomic, strong) NSString     *person_income;      /**< 会员收益 */
@property (nonatomic, strong) NSString     *person_member;      /**< 会员个人中心 */
@property (nonatomic, strong) NSDictionary *tabbar;             /**< tabbar活动图标zip下载地址 */
@property (nonatomic, assign) BOOL          star;               /**< 是否弹出评价给星 */

@end


#pragma mark - ServerConfigManager -
@interface ServerConfigManager : NSObject

@property (nonatomic, strong) ServerConfigModel *model;


+ (instancetype)sharedInstance;

/**
 根据请求 URL_GET_SERVERCONFIG 接口 返回的对象初始化 ServerConfigManager

 @param model ServerConfigModel
 */
+ (void)initServerConfigManagerWithModel:(ServerConfigModel *)model;


@end







