//
//  UserAnalyticsManager.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kUserAnalyticsMessageArray @"kUserAnalyticsMessageArray"

//商品点击来源
static NSString *const GoodsClickSource_shopcart = @"shopcart"; /**< 购物车 */
static NSString *const GoodsClickSource_order    = @"order";    /**< 订单 */
static NSString *const GoodsClickSource_video    = @"video";    /**< 视频 */
static NSString *const GoodsClickSource_mall     = @"mall";     /**< 商城首页 */
static NSString *const GoodsClickSource_topic    = @"topic";    /**< 商城专题 */
static NSString *const GoodsClickSource_vip      = @"vip_no";   /**< 会员模块下的非会员页面 */
static NSString *const GoodsClickSource_other    = @"other";    /**< 其他 */

//banner点击来源
static NSString *const BannerClickSource_index         = @"index";      /**< 首页广告位 */
static NSString *const BannerClickSource_goods         = @"goods";      /**< 商城首页 */
static NSString *const BannerClickSource_topic         = @"topic";      /**< 商品专题 */
static NSString *const BannerClickSource_video         = @"video";      /**< 首页视频 */
static NSString *const BannerClickSource_tab_home      = @"tab_home";   /**< tab_首页 */
static NSString *const BannerClickSource_tab_community = @"tab_comm";   /**< tab_社区 */
static NSString *const BannerClickSource_tab_store     = @"tab_store";  /**< tab_商城 */
//static NSString *const BannerClickSource_tab_shoot     = @"tab_shoot";  /**< tab_拍摄 */    // 拍摄被干掉
static NSString *const BannerClickSource_tab_vip       = @"tab_vip";    /**< tab_会员 */
static NSString *const BannerClickSource_tab_mine      = @"tab_mine";   /**< tab_我的 */



@interface UserAnalyticsManager : NSObject

@property (nonatomic, assign) NSInteger maxLogMessageCount; /**< 本地记录数据最大条数（从服务器获取 默认：20） */

+ (UserAnalyticsManager *)sharedAnalyticsManager;

/**
 *  记录商品点击次数及点击来源
 *
 *  @param modelId 商品id
 *  @param source  点击来源（购物车：shopcart，订单：order，视频：video，商城首页：mall，商城专题：topic，其他：other）
 */
+ (void)recordStoreGoodsClickWithModelId:(id)modelId source:(NSString *)source;


/**
 *  首页广告位 banner  商城首页 banner  商城专题页 banner 和底部 tabbar 的点击统计
 *
 *  @param modelId     modelId
 *  @param locationTag banner位置
 *  @param source      点击来源(首页广告位@"index"  商城首页@"goods"  商品专题@"topic"  首页视频@"video" ,
 *  下面五个Tabbar统计👉 首页@"tab_home", 商城@"tab_store", 拍摄@"tab_shoot", 社区@"tab_community", 我的@"tab_mine";)
 */
+ (void)analyzeBannerClickByModelId:(NSNumber *)modelId locationTag:(NSNumber *)locationTag source:(NSString *)source;


/**
 *  保存埋点信息到本地
 *
 *  @param mesageDic 用户操作信息
 */
+ (void)saveAnalyzeDataWithMessageJsonString:(NSString *)mesageStr;

/**
 *  清除本地埋点信息所有记录数据
 */
+ (void)cleanAnalyzeData;

/**
 *  获取本地埋点信息所有记录数据条数
 *
 *  @return 所有记录条数
 */
+ (NSInteger)getAnalyzeDataCount;



@end






