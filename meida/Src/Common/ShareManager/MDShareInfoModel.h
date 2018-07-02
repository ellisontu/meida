//
//  MDShareInfoModel.h
//  meida
//
//  Created by ToTo on 2018/6/30.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"
@class ShareTargetModel;


/**
 *  分享 view type (4种  海报：vip、商品   普通：团购订单、视频晒单的普通样式)
 */
typedef NS_ENUM(NSInteger, ShareViewType) {
    ShareViewTypeNormal,        /**< 分享视频晒单的普通样式 */
    ShareViewTypePosterVip,     /**< 会员分享海报邀请开通会员 */
    ShareViewTypePosterGoods,   /**< 会员分享商城商品 */
    ShareViewTypeOrderGroup,    /**< 分享团购订单，邀请好友参团 */
    ShareViewTypeBeautyDiary    /**< 分享变美日签 */
};

@interface MDShareInfoModel : BaseModel

@property (nonatomic, strong) ShareTargetModel *weibo;
@property (nonatomic, strong) ShareTargetModel *weixin;
@property (nonatomic, strong) ShareTargetModel *pengyouquan;
@property (nonatomic, strong) ShareTargetModel *qq;
@property (nonatomic, strong) ShareTargetModel *qqzone;
//以下是自定义属性
@property (nonatomic, strong) NSString  *sourceId;          /**< 目标源的id（用于后台分享统计） eg:视频id,晒单id,频道name等 */
@property (nonatomic, strong) NSArray   *additionalBtnAry;  /**< 附加的按钮数组 eg:举报、删除、复制视频链接、返回首页 */
@property (nonatomic, strong) NSString  *track_info;        /**< 视频分享用到的信息 */


#pragma mark - 分享海报的信息 -
@property (nonatomic, strong) NSString  *poster_thum_url;   /**< 海报缩略图URL */
@property (nonatomic, strong) NSString  *poster_url;        /**< 海报原图URL */
@property (nonatomic, strong) NSData    *posterThumData;    /**< 海报缩略图图片资源 */
@property (nonatomic, strong) NSData    *posterData;        /**< 分享的海报图片资源(不需要文案) */
@property (nonatomic, assign) CGFloat   posterThumImgH_W;   /**< 海报缩略图图片高比宽的比例 */

#pragma mark - 自定义属性
@property (nonatomic, assign) ShareViewType shareViewType;  /**< 标记分享 View 类型 */
@property (nonatomic, assign) UIView    *customView;        /**< 标记是否显示自定义view 默认传nil */

//分享H5时通过文案实例化model
- (instancetype)initWithShareInfoTitle:(NSString *)title text:(NSString *)text imageData:(NSData *)imageData shareUrl:(NSString *)shareUrl;

@end



@interface ShareTargetModel : BaseModel

@property (nonatomic, strong) NSString *title;      /**< 分享的标题 */

@property (nonatomic, strong) NSString *content;    /**< 分享的内容 */

@property (nonatomic, strong) NSString *desc;       /**< 分享到新浪微博视频的描述 */

@property (nonatomic, strong) NSString *icon_url;   /**< 分享的图片 url */

@property (nonatomic, strong) NSString *target_url; /**< 分享的 url */

@property (nonatomic, assign) BOOL     is_share;    /**< 是否分享 */

@property (nonatomic, strong) NSData   *iconData;   /**< 通过 icon_url 下载的 iconData */

- (instancetype)initWithShareInfoDic:(NSDictionary *)dic;

@end
