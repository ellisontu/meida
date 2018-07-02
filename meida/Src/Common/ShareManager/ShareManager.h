//
//  ShareManager.h
//  meida
//
//  Created by ToTo on 16/1/29.
//  Copyright © 2016年 ymfashion. All rights reserved.
//  分享管理者

#import <Foundation/Foundation.h>
#import "MDShareInfoModel.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

typedef NSString * ShareManagerOptionsKey;
typedef void(^ShareFinishBlock)(NSString *platform, BOOL success);
typedef void(^ShareClickButtonBlock)(NSString *platform);
typedef void(^ShareViewDismissBlock)(void);

typedef NS_ENUM(NSInteger, ShareSourceType) {
    ShareSourceTypeStoreGoods,      /**< 分享商城商品 */
    ShareSourceTypeStoreGoodsTopic, /**< 分享商城商品专题 */
    ShareSourceTypeStoreGoodsTags,  /**< 分享商城商品标签、品牌 */
    ShareSourceTypeOrderRedbag,     /**< 分享订单界面红包 */
    ShareSourceTypeVideo,           /**< 分享视频 */
    ShareSourceTypeShareImage,      /**< 分享图片 */
    ShareSourceTypeAllChannel,      /**< 分享频道(标签视频|图片) */
    ShareSourceTypeUser,            /**< 分享用户的二级个人页 */
    ShareSourceTypeSiginIn,         /**< 分享红包签到 */
    ShareSourceTypeH5,              /**< 分享 H5 网页 */
    ShareSourceTypeLive,            /**< 分享直播|直播回放 */
    ShareSourceTypeStoreAggr,       /**< 分享商品聚合页 */
    ShareSourceTypeVip,             /**< 分享会员 */
    ShareSourceTypeBeautyDiary      /**< 分享变美日签 */
};


@interface ShareManager : NSObject<WXApiDelegate, QQApiInterfaceDelegate>

extern ShareManagerOptionsKey const ShareManagerToSina;             /**< 分享到微博 */
extern ShareManagerOptionsKey const ShareManagerToQQ;               /**< 分享到QQ */
extern ShareManagerOptionsKey const ShareManagerToQzone;            /**< 分享到QQ空间 */
extern ShareManagerOptionsKey const ShareManagerToWechatSession;    /**< 分享到微信好友 */
extern ShareManagerOptionsKey const ShareManagerToWechatTimeline;   /**< 分享到朋友圈 */
extern ShareManagerOptionsKey const ShareManagerReport;             /**< 举报(视频|晒单) */
extern ShareManagerOptionsKey const ShareManagerDelete;             /**< 删除(视频|晒单) */
extern ShareManagerOptionsKey const ShareManagerBackToHome;         /**< 回到首页(视频|晒单) */
extern ShareManagerOptionsKey const ShareManagerCopyLink;           /**< 复制链接(视频|晒单) */
extern ShareManagerOptionsKey const ShareManagerShareLink;          /**< 分享链接(商品) */
extern ShareManagerOptionsKey const ShareManagerSavePoster;         /**< 保存海报到手机 */


@property (nonatomic, copy) ShareFinishBlock      shareFinishBlock;         /**< 分享完成回调 */
@property (nonatomic, copy) ShareClickButtonBlock shareClickButtonBlock;    /**< 按钮点击回调 */
@property (nonatomic, copy) ShareViewDismissBlock shareViewDismissBlock;    /**< 分享界面消失回调 */
@property (nonatomic, strong) NSString *track_info;                         /**< 推荐视频分享 埋点增加的字段 */
@property (nonatomic, assign) BOOL      isShow;                             /**< 标记shareView是否正在展示(防止多次点击多次弹出) */

+ (ShareManager *)sharedInstance;

/**
 *  分享调用的接口
 *
 *  @param model        分享的信息 model (MDShareInfoModel)
 *  @param sourceType   分享的目标源类型 (ShareSourceType)
 */
- (void)shareInfoModel:(MDShareInfoModel *)model sourceType:(ShareSourceType)sourceType;

/**
 *  发布完视频、晒单、变美日签要调用的分享接口（因为UI的不同显得太不完美，这是瑕疵，以后有空把UI重构一下，也写到这个类里，一统天下）
 *
 *  @param model        分享的信息 model (MDShareInfoModel)
 *  @param platform     分享到的平台类型 (shareToQQ | shareToQzone | shareToSina | shareToWechatSession | shareToWechatTimeline)
 *  @param sourceType   分享的目标源类型 (ShareSourceType)
 */
- (void)shareInfoModel:(MDShareInfoModel *)model toPlatform:(ShareManagerOptionsKey)platform sourceType:(ShareSourceType)sourceType;

#pragma mark - H5分享时 调用的接口
/**
 *  H5分享时 调用的接口
 *
 *  @param title          分享标题
 *  @param text           分享内容
 *  @param shareImageData 分享图片
 *  @param shareUrl       分享跳转url
 */
- (void)shareH5WithTitle:(NSString *)title text:(NSString *)text shareImageData:(NSData *)shareImageData shareUrl:(NSString *)shareUrl;

#pragma mark - 分享海报（图片） -
/**
 *  分享海报（即 微信好友：发图片 朋友圈：发图片到朋友圈 ）
 *  @param model        要发送的图片资源
 *  @param sourceType   分享的目标源类型 (ShareSourceType)
 */
- (void)sharePosterImageWithShareInfoModel:(MDShareInfoModel *)model sourceType:(ShareSourceType)sourceType;


/**
 *  隐藏分享 view
 */
- (void)shareViewDismiss;

/**
 *  返回全部的分享平台
 *
 *  @return 全部的分享平台
 */
- (NSArray *)getAllSharePlatformName;

///**
// *  处理微博分享的回调结果，因为微博在AppDelegate回调时无法区分是登录还是分享的回调，只有走到回调方法才能区分
// *
// *  @param response 回调结果
// */
//- (void)didReceiveWeiboShareResponse:(WBSendMessageToWeiboResponse *)response;


@end


