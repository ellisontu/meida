//
//  Constant.h
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  本文件用于存放APP中第三方应用中用到的信息，包括各平台key，分享文字内容;
//  存储信息的key，拍摄时长

#ifndef meida_Constant_h
#define meida_Constant_h

// used for generating token
#define kSeed @"XIHONGCHUN"

#pragma mark - ------------------ 三方平台信息 ------------------
// qq
#define QQ_APPID                @"1103443915"
#define QQ_APPKEY               @"zAbw7ArZaWjxhtoq"

// 微信
#define APP_ID_WECHAT           @"wxa5583bad5377255f"
#define MCH_ID_WECHAT           @"1272968601"           /**< 商家向财付通申请的商家id */
#define WECHAT_LOGIN_OAUTH2_URL @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"

// 微博
#define SINA_APPKEY             @"3146088882"
#define SINA_ymfashion_UID      @"123123123"           /**< uid */
#define SINA_REDIRECT_URL       @"http://sns.whalecloud.com/sina2/callback"
#define GET_GIF_IMAGE           @"?imageView2/1/w/150/h/150/format/jpg"

//支付宝
#define PARTNER_ID_ALIPAY       @"ymfashion"
#define SELLER_ID_ALIPAY        @"pay@ymfashion.com"

// 七鱼客服
#define QYAppKey                @"ymfashion"
#define QYAppName               @"meida"
// 七鱼售前 groupID
#define QYAppPreSaleGroupID     111231
// 七鱼售后 groupID
#define QYAppAfterSaleGroupID   123123123

// 智齿客服
#define SOBOT_SYSTEMID          @"a3144037027c402191d35d6bd11dc6a3"

// 数美sdk Organization值
#define SM_ORGANIXSTION         @"7gacgDojOdClZoYM58g6"

// JSPatch
#define JsPatchKey              @"1a788f5d1550541c"
#define JsPatchPublicKey        @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrmLVx6cLgfr6MwG1hOM3UlXyI\n4cjgGV54VnMJFaKrFwqDVXkisKplTlfZbfYyC3OpkhKhFKxI/vT80zbOpDhQBNfN\nzlZ1UFc5QZdtSJd5om1n0O6szUiJ4X3usEuV4npyFvciuPCGpc1WOxNXurGqlggm\nAC1VqCzh52zHEtINMQIDAQAB\n-----END PUBLIC KEY-----"

// 个推
#ifdef DEBUG

#define kGetuiAppId             @"X8hoJRL5TW8Gd5kBVbsQW3"
#define kGetuiAppKey            @"Blv1XAgzPp7CkxLl99YYI1"
#define kGetuiAppSecret         @"wVnmS3YFqr7wuidkze4629"
#define kGetuiMasterSecret      @"iAibODwCr26tr0kvfmiEm8"

#else

#define kGetuiAppId             @"NGaOIoeT3kAQQBEcKyOYY8"
#define kGetuiAppKey            @"k2yDwKwqpJ97q45e1Npzc2"
#define kGetuiAppSecret         @"fn3NKxIgi37ftsU9ZXr447"
#define kGetuiMasterSecret      @"H1dcARUDyB7HT7rwKxWeD7"

#endif


#pragma mark - ------------------ 钥匙串中存储uuid ------------------

#define kService @"app.ymfashion.cn"
#define kAccount @"device_id"
#define KDeviceID @"YM_device_id"


#pragma mark - ------------------ 拍摄相关信息 ------------------
// 本地存储 频道入口 频道名称
#define kChannelName            @"channelSourceName"
// 本地存储 晒单图片 文件夹名称
#define kShareBuyImageFile      @"shareBuyImageFile"
// 本地存储 新晒单图片 文件夹名称
#define kNewShareBuyImageFile   @"newShareBuyImageFile"
// 存储 晒单草稿箱 文件夹名称
#define kDraftBoxFile           @"draftBoxFile"
// 存储 视频草稿箱 文件夹名称
#define kVideoDraftBoxFile      @"videoDraftBoxFile"
// 存储草稿箱及临时文件的视频文件名
#define kVideoFileName          @"compile.mov"
// 图文 添加图片发送的通知
#define kShareBuyAddPhoto       @"ShareBuyAddPhotoArray"

//最大同时可编辑视频数量
#define MaxEditableVideoCount   6
//最少拍摄时长
#define kMinShootDuration       3
//最高拍摄时长
#define kMaxShootDuration       120.f
// transcodings
#define kDefaultVideoWidth      720.0
#define kDefaultVideoHeight     720.0
#define kDefaultFrameRate       30.0
#define kDefaultBitRate         1500*1024
#define kDefaultWatermark       @"watermark.png"

#define kVideoAdvancedEditFileName @"advanced_edit_video.mp4"
#define kVideoForCoverFileName @"advanced_edit_toCover_video.mp4"

#define kNewPublishImageSize CGSizeMake(SCR_WIDTH - 30 - 50 * 2, SCR_HEIGHT - kHeaderHeight - 205)

// 评论显示时间
#define kCommentsShowTime       24*60*60
// 单位MB
#define kMaxLocalCacheSize      300

#pragma mark - ------------------ 存储key ------------------
//********************* 3D Touch ShortcutItem Type *********************//
#define kTouchShouYe            @"UITouchText.shouye"
#define kTouchShangCheng        @"UITouchText.shangcheng"
#define kTouchSheQu             @"UITouchText.shequ"

//*********************  UserDefault存储  *********************//
#define kGiftGoodsGd_idArray        @"giftGoodsArray"
#define kLiveBoxView                @"kLiveBoxView"                 /**< 记录是否开启直播提示框，只提示主播一次 */
#define kUserRegisgerPhoneNum       @"kUserRegisgerPhoneNum"        /**< 用户注册时候使用的手机号，优化用户体验 */
#define kGetuiBindCheckoutLastTime  @"kGetuiBindCheckoutLastTime"   /**< 记录个推上一次绑定别名的时间 */
#define kVideoZanKey                @"kVideoZanKey"                 /**< 记录视频点赞的数据 */
#define kVideoCommentZanKey         @"kVideoCommentZanKey"          /**< 记录视频评论点赞的数据 （为了防止不登录情况下无限点赞的问题）*/
#define kShareImageCommentZanKey    @"kShareImageCommentZanKey"     /**< 记录晒单评论点赞的数据 （为了防止不登录情况下无限点赞的问题）*/
#define kAppApproved                @"kAppApproved"                 /**< 标记App审核是否已通过 */
#define kCustomerServiceTipsCount   @"kCustomerServiceTipsCount"    /**< 客服提示个数 */
#define kLipsTotalCount             @"kLipsTotalCount"              /**< 记录总共唇印数 */

#define kLipsGuideShow             @"kLipsGuideShow"              /**< 记录是否显示过海报引导图 晓峰老师说:大版本更新的时候去展示 所以大版本的时候就换一下key值*/

#define kLipsHomeGuideShow          @"kLipsHomeGuideShow"              /**< 记录是否显示首页蒙层的变美日签引导图 晓峰老师说:大版本更新的时候去展示 所以大版本的时候就换一下key值*/

#define kLipsGuideHomeShow             @"kLipsGuideHomeShow"              /**< 记录首页显示引导图时间差 */

#define kLipsGuideHasShow             @"kLipsGuideHasShow"              /**< 14天之后显示过了 */

#define kPerpetratingAFraud         @"0"                            /**< 偷梁换柱（开启或关闭首页及商城页是否需要用原生的展示） */

#define kSuperiorParameter          @"kSuperiorParameter"           /**< 从外部H5进入APP传入的上级参数 "s"(当生成订单后删除) */

#define kPushApnsID                 @"kPushApnsID"                  /**< 收集个推cid， deviceID等信息，再上传到服务器 */

#define kCustomDeviceId             @"YM_app_custom_device_id"     /**< 自定义规则device_id，生成request_id时使用 */

#pragma mark - ------------------ 提示用户信息 ------------------
//*************** 未安装客户端的提示 *******************
#define NOT_INSTALLED_WECHAT        @"检测到您尚未安装微信客户端"
#define PAY_SUCCESS                 @"支付成功！^_^"
#define PAY_ERROR                   @"支付错误！T_T 请联系客服~ ~"
//#define PAY_SUCCESS_SUPPL_INFO      @"请在订单详情页填写身份信息"

#pragma mark - ------------------ 接口返回提示 ------------------
#define YM_API_CALLBACK_CODE_ERROR         @"接口返回失败"
#define YM_API_CALLBACK_DATA_FORMAT_ERROR  @"数据格式错误"


#pragma mark - ------------------ 分享文案 ------------------
// 新注册用户微博分享
#define SHARE_NEW_SINA_CONTENT      @"我刚注册了@美哒App ，这里是时尚好物推荐、真人视频分享社区。快和大家一起分享化妆美甲、减肥发型、美食星座的经验和话题吧。美哒，你的变美频道！下载链接戳这里 https://www.ymfashion.com"

// 分享视频
#define SHARE_VIDEO_URL             @"https://www.ymfashion.com/show/%@"

#define kShowRecorderTip            @"kShowRecorderTip"     /**< 显示拍摄辅助提示 */

// 团购免单规则 说明h5
#define kgroupBuyRuleFree           @"https://static.ymfashion.com/groupbuy/rule/free?YM_share=0"
// 团购规则 说明h5
#define kbulkBuyRule               @"https://static.ymfashion.com/groupbuy/rule?YM_share=0"

#pragma mark - 发布默认文案
#define kDefualtTitleStr            @"标题要突出你的作品主题喔～"
#define kDefualtDescStr             @"介绍一下你的作品和分享心得吧，越详细越容易热门呦～"

//video
#define RECORD_MAX_TIME 8.0           //最长录制时间
#define TIMER_INTERVAL 0.05         //计时器刷新频率
#define VIDEO_FOLDER @"recordVideoFile" //视频录制存放文件夹

#endif







