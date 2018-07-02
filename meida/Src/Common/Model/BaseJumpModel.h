//
//  BaseJumpModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  这个只做跳转使用！ 这里只处理 scheme = 

#import "BaseModel.h"
@class YMWebViewVC;

typedef NS_ENUM(NSInteger, BaseJumpModelType) {
    BaseJumpModelTypeChannel,           /**< 频道（视频、晒单） */
    BaseJumpModelTypeUser,              /**< 用户 */
    BaseJumpModelTypeProductList,       /**< 抢购商品列表,唇印兑换 */
    BaseJumpModelTypeProductDetail,     /**< 抢购商品详情 */
    BaseJumpModelTypeVideo,             /**< 视频 */
    BaseJumpModelTypeHtml,              /**< HTML */
    BaseJumpModelTypeStoreAggr,         /**< 商品聚合页 */
    BaseJumpModelTypeStoreList,         /**< 商城列表 */
    BaseJumpModelTypeStoreCart,         /**< 商城购物车 */
    BaseJumpModelTypeStoreDetail,       /**< 商城商品详情 */
    BaseJumpModelTypeStoreBulkDetail,   /**< 团购商品详情页 */
    BaseJumpModelTypeStoreTopic,        /**< 商城商品专题 */
    BaseJumpModelTypeStoreRoom,         /**< 商城仓库专区（以前的专题页） */
    BaseJumpModelTypeActivity,          /**< 商城活动 */
    BaseJumpModelTypeStoreSearch,       /**< 商城搜索 */
    BaseJumpModelTypeStoreSearchResult, /**< 商城搜索结果 */
    BaseJumpModelTypeCoupon,            /**< 我的优惠券 */
    BaseJumpModelTypeStoreOrderDetail,  /**< 商城订单详情 */
    BaseJumpModelTypeStoreGroupOrderDetail, /**< 商城团购订单详情 */
    BaseJumpModelTypeHomeIndex,         /**< 首页推荐和关注切换 */
    BaseJumpModelTypeLive,              /**< 直播跳转 */
    BaseJumpModelTypeLiveList,          /**< 直播列表 */
    BaseJumpModelTypeShareHome,         /**< 晒单首页 */
    BaseJumpModelTypeShareList,         /**< 晒单列表 */
    BaseJumpModelTypeShareDetail,       /**< 晒单详情 */
    BaseJumpModelTypeDiscover,          /**< 发现页 */
    BaseJumpModelTypeShootPhoto,        /**< 拍照 */
    BaseJumpModelTypeSearch,            /**< 首页搜索 */
    BaseJumpModelTypeSearchResult,      /**< 首页搜索结果页 */
    BaseJumpModelTypeLogin,             /**< 登录 仅用于商城 */
    BaseJumpModelTypeStoreTag,          /**< 商品Tag */
    BaseJumpModelTypeReact,             /**< react */
    BaseJumpModelTypeSkip,              /**< 跳过 */
    BaseJumpModelTypeChannelList,       /**< 频道广场 */
    BaseJumpModelTypeRedEnvelope,       /**< 拆红包 */
    BaseJumpModelTypeFeedBack,          /**< 跳转联系官方私信，反馈 */
    BaseJumpModelTypeGroupLeaderFree,   /**< 消息跳免单 */

    BaseJumpModelTypeMessage,           /**< 消息中心 */
    BaseJumpModelTypeMsgList,           /**< 消息列表类型 */
    
    BaseJumpModelTypeWeex,              /**< weex页面 */
    BaseJumpModelTypeBeautyPoster,      /**< 变美海报 */
    BaseJumpModelTypeBeautyList,        /**< 变美空间 */
    
//    BaseJumpModelTypeH5GoodsPay,        /**< H5调起原生支付 */
    BaseJumpModelTypeH5CallAddressBook, /**< H5调原生通讯录 */
    BaseJumpModelTypeH5LaunchWechat,    /**< H5调本地微信 */
    BaseJumpModelTypeTabBarVip,         /**< 跳转会员页 */
    BaseJumpModelTypeUnknow,            /**< 未知 */
    BaseJumpModelTypeContact            /**< 跳转客服 */
};

@interface BaseJumpModel : BaseModel

@property (nonatomic, assign) BaseJumpModelType jumpType;
@property (nonatomic, assign) BOOL isFromReact;         /**< 是否从react跳转的 */
@property (nonatomic, strong) NSNumber *idNumber;       /**< 跳转 id */
@property (nonatomic, strong) NSString *idString;       /**< 跳转 id */
@property (nonatomic, strong) NSString *urlString;      /**< 跳转 url */
#pragma mark - 埋点专用 -
@property (nonatomic, strong) NSString *referer;        /**< 来源类型 shopcart order video mall topic other */
@property (nonatomic, strong) NSString *track_info;     /**< 用于埋点的数据（晒图和视频要用到）*/
@property (nonatomic, strong) UIViewController *currentVC;  /**< 兼容老埋点 */
@property (nonatomic, weak) YMWebViewVC *webViewVC;    /**< 来源H5的操作 */

- (instancetype)initWithUrlString:(NSString *)urlString;

/**
 *  本地跳转时 调用的接口
 *
 *  @param jumpType 跳转类型
 *  @param idString 跳转是的类型id，还有些局限性，待拓展
 */
- (instancetype)initWithJumpType:(BaseJumpModelType)jumpType idString:(NSString *)idString;

- (void)setJumpTypeByUrlString:(NSString *)urlString;

/**
 *  按类型跳转
 */
- (void)handelJump;

@end
