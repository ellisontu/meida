//
//  UserModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

#define md_MALE 1
#define MD_FEMALE 2
#define MD_UNKNOWN 0
//1qq2微信3sina微博
typedef NS_ENUM(NSInteger, MDSourceType) {
    SourceTypeQQ = 1,
    SourceTypeWeChat,
    SourceTypeSina
};


@interface UserModel : BaseModel

@property (nonatomic, strong) NSString *uid;            /**< userId */
@property (nonatomic, strong) NSString *accessToken;    /**< deprecated */ 
@property (nonatomic, strong) NSString *nick;           /**< 昵称 */
@property (nonatomic, assign) NSInteger sex;            /**< 性别 1:男性 2:女性 3:未知 */
@property (nonatomic, strong) NSString *desc;           /**< 简介 */
@property (nonatomic, strong) NSString *password;       /**< 密码 */
@property (nonatomic, strong) NSString *background;     /**< 用户的背景 */
@property (nonatomic, strong) NSString *fans;           /**< 粉丝数 */
@property (nonatomic, strong) NSString *Attention;      /**< 关注数 */
@property (nonatomic, strong) NSString *phone;         /**< 手机号 */
@property (nonatomic, strong) NSString *icon_url;       /**< 头像 */
@property (nonatomic, strong) NSString *icon;           /**< 老版本接口头像 */
@property (nonatomic, strong) NSString *videos;         /**< 视频数 */
@property (nonatomic, assign) BOOL is_attention;        /**< 是否关注该用户 */
@property (nonatomic, assign) BOOL is_attention_me;     /**< 是否关注我 */
@property (nonatomic, strong) NSString *collections;    /**< 该用户频道被订阅数 */
@property (nonatomic, strong) NSString *tags;           /**< 频道数 */
@property (nonatomic, assign) NSInteger red;            /**< 唇印 */
@property (nonatomic, strong) NSNumber *is_new_user;    /**< 动态登录时判断是不是新用户 */

@property (nonatomic, strong) NSString *weibo_id;       /**< 用于新浪微博查找 */
@property (nonatomic, strong) NSString *weibo_friends;
@property (nonatomic, strong) NSString *date_add;       /**< 粉丝关注时间 */
@property (nonatomic, assign) CGFloat maxShootDuration; /**< 视频最大拍摄时长（不同类型的用户不一样） */

@property (nonatomic, strong) NSString *openId;         /**< (仅微信登录是unionId，否则均为 openId) */ 
@property (nonatomic, strong) NSString *tag;            /**< 以前的 openId(仅微信登录) */
@property (nonatomic, assign) NSInteger sourceType;     /**< 第三方标示 1qq2微信3sina微博 */
@property (nonatomic, strong) NSString *videoToken;     /**< 七牛视频上传凭据 */
@property (nonatomic, strong) NSString *imageToken;     /**< 七牛图片上传凭据 */

@property (nonatomic, strong) NSNumber *recommend;      /**< 是否关注 */
@property (nonatomic, strong) NSString *recommend_time; /**< 推荐时间 */
@property (nonatomic, strong) NSString *local;
@property (nonatomic, strong) NSString *geo;

// 新版个人页频道字段
@property (nonatomic, strong) NSNumber *my_tags;        /**< 我的频道数 */
@property (nonatomic, strong) NSNumber *all_tags;       /**< 所有频道数 */
@property (nonatomic, strong) NSString *video_collections;/**< 我的收藏数 */

@property (nonatomic, strong) NSString *messageCount;   /**< 我的消息数 */
@property (nonatomic, strong) NSString *redbagCount;    /**< 待领红包个数 */

#pragma mark - 请求头包含内容
@property (nonatomic, strong) NSString *token;          /**< 请求权限鉴定的标识 */
@property (nonatomic, strong) NSString *prefix;         /**< 每个用户随机的前缀 */
@property (nonatomic, strong) NSNumber *hashTimes;      /**< 验证计算的hash次数 */

#pragma mark - 发布 token 获取的接口
@property (nonatomic, strong) NSDictionary *aliAccess;  /**< 上传阿里的获取权限接口 */

#pragma mark - 老拉新
@property (nonatomic, strong) NSString *title;          /**< 活动标题 */
@property (nonatomic, strong) NSString *actUrl;         /**< 活动url */
@property (nonatomic, strong) NSNumber *limit;          /**< 评论字数限制 */

#pragma mark - VIP信息 -
@property (nonatomic, strong) NSNumber *vipInfo;        /**< VIP信息（0:非会员 1:普通会员 9:过期会员 1--8:其它会员） */

// 分页字段
@property (nonatomic, strong) NSNumber *rank;

@property (nonatomic, assign) NSInteger customer;       /**< 1为智齿， 0为七鱼 */

// 新头像字段
@property (nonatomic, strong) NSString *avatar;
// 新粉丝
@property (nonatomic, strong) NSNumber *fans_count;
// 新 id
@property (nonatomic, strong) NSString *id;
// 新是否关注
@property (nonatomic, strong) NSNumber *is_follow;

@property (nonatomic, strong) NSString *track_info; /**< 老版本的track_info */
// 新加url,里面包含 跳转信息和track_info
@property (nonatomic, strong) NSString  *jump_url;   /**< 新版本的track_info */


#pragma mark - 2017.6.20 团购免单券数
@property (nonatomic, strong) NSString  *bulkbuy_free_ticket_count; /**< 团购免单券数量 */

+ (NSMutableArray *)decodeJsonArray:(id)json;

- (BOOL)isPhoneBinded;

@end
