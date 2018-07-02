//
//  UserAnalyticsModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

static NSString *const UserAnalyticsTableName_user_play_video = @"user_play_video"; /**< 视频详情页数据埋点 */
static NSString *const UserAnalyticsTableName_user_click      = @"user_click";      /**< 点击事件埋点（eg:关注） */
static NSString *const UserAnalyticsTableName_goods_access    = @"goods_access";    /**< 商品详细页埋点 */
static NSString *const UserAnalyticsTableName_page_duration   = @"page_duration";   /**< 页面留存时间 */
static NSString *const UserAnalyticsTableName_link            = @"link";            /**< h5 进入 APP 埋点 */


@interface UserAnalyticsModel : BaseModel

//公共记录信息
@property (nonatomic, strong) NSString *uid;           /**< 用户id , -1为未登录 */
@property (nonatomic, strong) NSString *app_version;   /**< app 版本号 @"v1.0.2.3" */
@property (nonatomic, strong) NSString *timestamp;     /**< 时间戳 @“1460100749” */
@property (nonatomic, strong) NSString *country;       /**< 国家 */
@property (nonatomic, strong) NSString *province;      /**< 省会 */
@property (nonatomic, strong) NSString *city;          /**< 城市 */
@property (nonatomic, strong) NSString *manufacturer;  /**< 制造商 @“"Apple"” */
@property (nonatomic, strong) NSString *model;         /**< 型号 @"iphone6" */
@property (nonatomic, strong) NSString *dev;           /**< 设备id @"设备串号" */
@property (nonatomic, strong) NSString *os;            /**< 系统 @"ios" */
@property (nonatomic, strong) NSString *os_version;    /**< 系统版本号 @"9.3" */
@property (nonatomic, strong) NSString *screen_height; /**< 屏幕高度 @"568" */
@property (nonatomic, strong) NSString *screen_width;  /**< 屏幕宽度 @"320" */
@property (nonatomic, strong) NSString *wifi;          /**< wifi环境 @"1" */
@property (nonatomic, strong) NSString *carrier;       /**< 运营商 @"中国电信" */
@property (nonatomic, strong) NSString *network_type;  /**< 网络环境 @"4G" */

@property (nonatomic, strong) NSString *tableName;     /**< 表名 @"user_play_video" @"user_click" @"goods_access" */


//
#pragma mark - 视频详情页数据埋点 (tableName:user_play_video 当用户观看视频超过1秒,触发)
@property (nonatomic, strong) NSString *vid;           /**< 视频 id */
@property (nonatomic, strong) NSString *playtime;      /**< 视频播放时长 */
@property (nonatomic, strong) NSString *duration;      /**< 视频总时长 */
@property (nonatomic, strong) NSString *track_info;    /**< 记录来源信息: recommend:trace_id, search_click:key */
#pragma mark - 用户点击事件埋点 (tableName:user_click eg:点击首页关注 点击首页banner等)
@property (nonatomic, assign) BOOL     isReact;        /**< 标记是否是在react上的点击 */
@property (nonatomic, strong) NSDictionary *clickDic;  /**< 在react上的点击传来的参数 */
@property (nonatomic, strong) NSString *action;        /**< 按纽名称 (关注, video, image, live, tag_video, tag_image, shop(商城), hots(每日热榜), exchange(唇印兑换), more) */
@property (nonatomic, strong) NSString *source;        /**< 来源 eg:home_page */
@property (nonatomic, strong) NSString *source_info;   /**< 暂时无用，预留 */
@property (nonatomic, strong) NSString *module;        /**< 模块 (banner, icon, video_list(达人招募), live(直播), show_order(晒单), custom_video_featured(视频精选), custom_praise_goods(口碑好物), api_lovely(接口-猜你喜欢)) */
@property (nonatomic, strong) NSString *action_id;     /**< 内容id eg:videoId、goodsId */
@property (nonatomic, strong) NSString *position;      /**< 位置 eg:瀑布流里的位置index */
#pragma mark - 商品详细页埋点 (tableName:goods_access 进入商品详细页展示商品完成后记录)
@property (nonatomic, strong) NSString *g_id;          /**< 商品 id */
@property (nonatomic, strong) NSString *referer;       /**< 来源类型 shopcart order video mall topic other */
#pragma mark - 页面留存时长埋点 (tableName:page_duration 记录页面留存时长)
@property (nonatomic, strong) NSNumber *page_duration; /**< 页面留存时长 整型 */
@property (nonatomic, strong) NSString *page_name;     /**< 页面name eg:home */

#pragma mark - 发布视频/晒单 信息统计
@property (nonatomic, strong) NSString *type;           /**< 内容类型 */
@property (nonatomic, strong) NSString *upload_target;  /**< 上传服务器位置(视频资源暂用此字段区分类型,其实现在这个字段可以改名了) */
@property (nonatomic, strong) NSString *time;           /**< 上传时长 */
@property (nonatomic, strong) NSString *question;       /**< 失败原因 成功此字段为空 */

#pragma mark - 编辑视频
@property (nonatomic, strong) NSString *phase;          /**< 当前所处的编辑阶段 */

#pragma mark - 晒单发布(记录内存警告)
@property (nonatomic, strong) NSString *m_w_sd_index;   /**< 晒单内存警告位置 */

#pragma mark - 下面是一些调用的方法
/**
 *  根据 tableName 生成一个 message dictionary {table:"表名", content:{}}  并保存到本地
 *
 *  @return message = {table:"tableName", content:{}}
 */
- (NSDictionary *)configLogMessageDictionary;

/**
 *  获取公共埋点信息（react需要）
 *
 *  @return dic
 */
- (NSDictionary *)getShareAnlayzeInfo;

/**
 *  发布视频/晒单 反馈信息
 */
- (NSDictionary *)getUploadDataInfo;

/**
 *  编辑视频 反馈信息
 */
- (NSDictionary *)uploadEditVideoInfo;

/**
 *  编辑 视频/晒单/新晒单 反馈信息
 *  phase: 编辑阶段(当为 nil 时为'未知'状态)
 *  subPhase: 下分子功能(当为 nil 时为'0' 未选择其他编辑功能)
 *  functionType: 1. 晒单  2. 视频  3. 新晒单
 */
- (void)uploadEditVideoAndPhotoInfoWithPhase:(NSString *)phase subPhase:(NSString *)subPhase functionType:(NSInteger)functionType;

/**
 *  编辑图片 内存警告反馈信息
 */
- (NSDictionary *)uploadPublishShareBuyMemoryWarning;

@end



