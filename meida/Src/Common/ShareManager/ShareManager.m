//
//  ShareManager.m
//  meida
//
//  Created by ToTo on 16/1/29.
//  Copyright © 2016年 ymfashion. All rights reserved.
//  

#import "ShareManager.h"
#import "ShareView.h"
#import "SharePosterView.h"
#import <WeiboSDK.h>

#define SHARE_COUNT_KEY_TARGET  @"target"
#define SHARE_COUNT_KEY_TYPE    @"type"
#define SHARE_COUNT_KEY_TYPE_ID @"type_id"

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeVideo,     /**< 卡片视频类型 */
    ShareTypeWebPage,   /**< 卡片图文类型 */
    ShareTypeImage,     /**< 图片类型 */
    
};

//用于传给服务器做统计数据用的静态字符串
static NSString *const ShareAnalyzeTypeGoods        = @"";
static NSString *const ShareAnalyzeTypeGoodsTopic   = @"";
static NSString *const ShareAnalyzeTypeGoodsTags    = @"";
static NSString *const ShareAnalyzeTypeH5           = @"";
static NSString *const ShareAnalyzeTypeRedbag       = @"";
static NSString *const ShareAnalyzeTypeTags         = @"";
static NSString *const ShareAnalyzeTypeLive         = @"";
static NSString *const ShareAnalyzeTypeShareOrder   = @"";
static NSString *const ShareAnalyzeTypeUser         = @"";
static NSString *const ShareAnalyzeTypeVideo        = @"";
static NSString *const ShareAnalyzeTypeVip          = @"";
static NSString *const ShareAnalyzeTypeBeautyDiary  = @"";

ShareManagerOptionsKey const ShareManagerToSina             = @"ShareManagerToSina";            /**< 分享到微博 */
ShareManagerOptionsKey const ShareManagerToQQ               = @"ShareManagerToQQ";              /**< 分享到QQ */
ShareManagerOptionsKey const ShareManagerToQzone            = @"ShareManagerToQzone";           /**< 分享到QQ空间 */
ShareManagerOptionsKey const ShareManagerToWechatSession    = @"ShareManagerToWechatSession";   /**< 分享到微信好友 */
ShareManagerOptionsKey const ShareManagerToWechatTimeline   = @"ShareManagerToWechatTimeline";  /**< 分享到朋友圈 */
ShareManagerOptionsKey const ShareManagerReport             = @"ShareManagerReport";            /**< 举报(视频|晒单) */
ShareManagerOptionsKey const ShareManagerDelete             = @"ShareManagerDelete";            /**< 删除(视频|晒单) */
ShareManagerOptionsKey const ShareManagerBackToHome         = @"ShareManagerBackToHome";        /**< 回到首页(视频|晒单) */
ShareManagerOptionsKey const ShareManagerCopyLink           = @"ShareManagerCopyLink";          /**< 复制链接(视频|晒单) */
ShareManagerOptionsKey const ShareManagerShareLink          = @"ShareManagerShareLink";         /**< 分享链接(商品) */
ShareManagerOptionsKey const ShareManagerSavePoster         = @"ShareManagerSavePoster";        /**< 保存海报到手机 */


@interface ShareManager () <QQApiInterfaceDelegate>

@property (nonatomic, strong) MDShareInfoModel *shareInfoModel;    /**< 分享的信息model */
@property (nonatomic, assign) ShareSourceType   shareSourceType;    /**< 分享的目标源类型 */
@property (nonatomic, assign) ShareType         shareType;          /**< 分享到腾讯相关平台时的样式（视频、图文->默认） */
@property (nonatomic, strong) SharePosterView   *sharePosterView;   /**< 分享海报 View */
@property (nonatomic, strong) ShareView         *shareView;         /**< 分享普通 View */


/******************视频分享********************/

//当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识 @warning 不能为空，长度小于255
@property (nonatomic, strong) NSString *objectID;           /**< 对象唯一ID，用于唯一标识一个多媒体内容 */
@property (nonatomic, strong) NSString *title;              /**< 多媒体内容标题 @warning 不能为空且长度小于1k */
@property (nonatomic, assign) ShareType type;               /**< 分享的类型 */
@property (nonatomic, strong) NSString *platform;           /**< 分享的平台 */
@property (nonatomic, strong) NSMutableDictionary *dict;    /**< 后台统计参数字典 */

@end

@implementation ShareManager
{
    NSString *_reportContent;
}

+ (ShareManager *)sharedInstance
{
    static ShareManager *shareManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[ShareManager alloc] init];
        shareManager.dict = [NSMutableDictionary dictionary];
    });
    return shareManager;
}

/**
 *  H5分享时 调用的接口
 */
- (void)shareH5WithTitle:(NSString *)title text:(NSString *)text shareImageData:(NSData *)shareImage shareUrl:(NSString *)shareUrl
{
    MDShareInfoModel *model = [[MDShareInfoModel alloc] initWithShareInfoTitle:title text:text imageData:shareImage shareUrl:shareUrl];
    _shareInfoModel = model;
    _shareSourceType = ShareSourceTypeH5;
    [[ShareManager sharedInstance] shareInfoModel:model sourceType:ShareSourceTypeH5];
}

//分享海报
- (void)sharePosterImageWithShareInfoModel:(MDShareInfoModel *)model sourceType:(ShareSourceType)sourceType
{
    if (_isShow) {
        return;
    }
    
    if (stringIsEmpty(model.poster_url)) {
        [Util showMessage:@"获取分享信息失败" forDuration:1.5f inView:MDAPPDELEGATE.window];
        return;
    }
    
    _shareInfoModel = model;
    _shareSourceType = sourceType;
    //清空 _dict 中的值，防止数据错误
    if (dictionaryIsEmpty(_dict)) {
        _dict = [NSMutableDictionary dictionary];
    }
    else {
        [_dict removeAllObjects];
    }
    
    if (sourceType == ShareSourceTypeStoreGoods) {
        [_dict setObject:ShareAnalyzeTypeGoods forKey:SHARE_COUNT_KEY_TYPE];
    }
    else if (sourceType == ShareSourceTypeVip) {
        [_dict setObject:ShareAnalyzeTypeVip forKey:SHARE_COUNT_KEY_TYPE];
    }
    //数据统计 (sourceId:商品id)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    
    //展示shareView
    [self configPosterShareView];
    
    _isShow = YES;
}

#pragma mark - 配置海报分享界面 -
- (void)configPosterShareView
{
    NSArray *allPlatform = @[ShareManagerToWechatSession, ShareManagerToWechatTimeline, ShareManagerToSina, ShareManagerToQQ, ShareManagerSavePoster, ShareManagerShareLink];
    //如果有额外按钮则添加
    if (!arrayIsEmpty(_shareInfoModel.additionalBtnAry)) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:allPlatform];
        [array addObjectsFromArray:_shareInfoModel.additionalBtnAry];
        allPlatform = array;
    }
    
    _sharePosterView = [[SharePosterView alloc] initWithPlatformsArray:allPlatform shareInfoModel:_shareInfoModel];
    //shareView.model = _shareInfoModel;
    MDWeakPtr(weakPtr, self);
    _sharePosterView.SharePlatformSeletedBlock = ^(ShareManagerOptionsKey platform, BOOL isSharePoster) {
        //分享海报
        if (isSharePoster) {
            //检测图片资源是否已下载
            weakPtr.shareType = ShareTypeImage;
            [weakPtr checkPosterDataByPlatform:platform];
            //数据统计
            NSString *value = [weakPtr.dict objectForKey:SHARE_COUNT_KEY_TYPE];
            value = [NSString stringWithFormat:@"%@-poster", value];
            [weakPtr.dict setObject:value forKey:SHARE_COUNT_KEY_TYPE];
        }
        //分享卡片
        else {
            weakPtr.shareType = ShareTypeWebPage;
            [weakPtr checkIconDataByPlatform:platform];
        }
    };
//    _sharePosterView.dismissBlock = ^ {
//        weakPtr.isShow = NO;
//        if (weakPtr.shareViewDismissBlock) {
//            weakPtr.shareViewDismissBlock();
//        }
//        weakPtr.shareViewDismissBlock = nil;
//        [weakPtr.sharePosterView removeFromSuperview];
//        weakPtr.sharePosterView = nil;
//    };
    [_sharePosterView show];
}

- (void)checkPosterDataByPlatform:(ShareManagerOptionsKey)platform
{
    if (_shareInfoModel.posterThumData && _shareInfoModel.posterData) {
        [self shareViewSelectedAction:platform];
    }
    else {
        [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在生成海报"];
        MDWeakPtr(weakPtr, self);
        if (!_shareInfoModel.posterThumData) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_shareInfoModel.poster_thum_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        weakPtr.shareInfoModel.posterThumData = data;
                        //_shareInfoModel.posterThumData = UIImageJPEGRepresentation(image, 0.7f);
                        weakPtr.shareInfoModel.posterThumImgH_W = image.size.height/image.size.width;
                        [weakPtr shareViewSelectedAction:platform];
                    }
                    else {
                        [Util showMessage:@"生成海报缩略图失败" inView:MDAPPDELEGATE.window];
                    }
                });
            }];
        }
        if (!_shareInfoModel.posterData) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_shareInfoModel.poster_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        weakPtr.shareInfoModel.posterData = data;
                        //_shareInfoModel.posterData = UIImageJPEGRepresentation(image, 0.7f);
                        [weakPtr shareViewSelectedAction:platform];
                    }
                    else {
                        [Util hideLoadingVw];
                        [Util showMessage:@"生成海报失败" inView:MDAPPDELEGATE.window];
                    }
                });
            }];
        }
    }
}

- (void)shareInfoModel:(MDShareInfoModel *)model sourceType:(ShareSourceType)sourceType
{
    if (_isShow) {
        return;
    }
    
    if (!model) {
        [Util showMessage:@"获取分享信息失败" forDuration:1.f inView:MDAPPDELEGATE.window];
        return;
    }
    _shareInfoModel = model;
    _shareSourceType = sourceType;
    _shareType = ShareTypeWebPage;
    //清空 _dict 中的值，防止数据错误
    if (dictionaryIsEmpty(_dict)) {
        _dict = [NSMutableDictionary dictionary];
    }
    else {
        [_dict removeAllObjects];
    }

    switch (sourceType) {
        case ShareSourceTypeStoreGoods:
            [self shareStoreGoods];
            break;
        case ShareSourceTypeStoreGoodsTopic:
            [self shareStoreGoodsTopic];
            break;
        case ShareSourceTypeStoreGoodsTags:
            [self shareStoreGoodsTags];
            break;
        case ShareSourceTypeOrderRedbag:
            [self shareOrderRedbag];
            break;
        case ShareSourceTypeVideo:
            [self shareVideo];
            break;
        case ShareSourceTypeShareImage:
            [self shareImage];
            break;
        case ShareSourceTypeAllChannel:
            [self shareAllChannel];
            break;
        case ShareSourceTypeUser:
            [self shareUser];
            break;
        case ShareSourceTypeSiginIn:
            [self shareSignInRedbag];
            break;
        case ShareSourceTypeLive:
            [self shareLive];
            break;
        case ShareSourceTypeH5:
            [self shareH5];
            break;
        case ShareSourceTypeStoreAggr:
            [self shareStoreAggr];
            break;
            
        default:
            break;
    }
}

- (void)shareInfoModel:(MDShareInfoModel *)model toPlatform:(NSString *)platform sourceType:(ShareSourceType)sourceType
{
    if (_isShow) {
        return;
    }
    
    if (!model) {
        [Util showMessage:@"获取分享信息失败" forDuration:1.5f inView:MDAPPDELEGATE.window];
        return;
    }
    _shareInfoModel = model;
    _shareSourceType = sourceType;
    
    //清空 _dict 中的值，防止数据错误
    if (dictionaryIsEmpty(_dict)) {
        _dict = [NSMutableDictionary dictionary];
    }
    else {
        [_dict removeAllObjects];
    }
    
    if (sourceType == ShareSourceTypeVideo) {
        _shareType = ShareTypeVideo;
        
        [_dict setObject:ShareAnalyzeTypeVideo forKey:SHARE_COUNT_KEY_TYPE];
        if (!stringIsEmpty(_shareInfoModel.track_info)) {
            [_dict setObject:_shareInfoModel.track_info forKey:@"track_info"];
        }
        _isShow = YES;
    }
    else if (sourceType == ShareSourceTypeShareImage) {
        _shareType = ShareTypeWebPage;
        
        [_dict setObject:ShareAnalyzeTypeShareOrder forKey:SHARE_COUNT_KEY_TYPE];
        if (!stringIsEmpty(_shareInfoModel.track_info)) {
            [_dict setObject:_shareInfoModel.track_info forKey:@"track_info"];
        }
        _isShow = YES;
        
    }
    else if (sourceType == ShareSourceTypeBeautyDiary) {
        _shareType = ShareTypeImage;
        
        [_dict setObject:ShareAnalyzeTypeBeautyDiary forKey:SHARE_COUNT_KEY_TYPE];
        if (!stringIsEmpty(_shareInfoModel.track_info)) {
            [_dict setObject:_shareInfoModel.track_info forKey:@"track_info"];
        }
        _isShow = NO;
    }
    
    //数据统计 (sourceId:晒单id or 视频id)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    
    [self shareViewSelectedAction:platform];
}

#pragma mark - 配置分享界面 -
- (void)configShareView
{
    NSArray *allPlatform = @[ShareManagerToWechatSession, ShareManagerToWechatTimeline, ShareManagerToSina, ShareManagerToQQ, ShareManagerToQzone];
    //如果有额外按钮则添加
    if (!arrayIsEmpty(_shareInfoModel.additionalBtnAry)) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:allPlatform];
        [array addObjectsFromArray:_shareInfoModel.additionalBtnAry];
        allPlatform = array;
    }
    
    _shareView = [[ShareView alloc] initWithPlatformsArray:allPlatform shareInfoModel:_shareInfoModel];
    MDWeakPtr(weakPtr, self);
    _shareView.SharePlatformSeletedBlock = ^(ShareManagerOptionsKey platform) {
        //检测图片资源是否已下载
        if ([platform isEqualToString:ShareManagerBackToHome] || [platform isEqualToString:ShareManagerReport] || [platform isEqualToString:ShareManagerDelete] || [platform isEqualToString:ShareManagerCopyLink]) {
            [weakPtr shareViewSelectedAction:platform];
        }
        else {
            [weakPtr checkIconDataByPlatform:platform];
        }
    };
    _shareView.dismissBlock = ^ {
        weakPtr.isShow = NO;
        if (weakPtr.shareViewDismissBlock) {
            weakPtr.shareViewDismissBlock();
        }
        weakPtr.shareViewDismissBlock = nil;
        [weakPtr.shareView removeFromSuperview];
        weakPtr.shareView = nil;
    };
    [_shareView show];
    
    _isShow = YES;
}

- (void)shareViewDismiss
{
    if (_sharePosterView) {
        [_sharePosterView dismiss];
    }
    else if (_shareView) {
        [_shareView dismiss];
    }
}

#pragma mark - 分享商城商品(ShareSourceTypeStoreGoods) -
- (void)shareStoreGoods
{
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:商品id)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    [_dict setObject:ShareAnalyzeTypeGoods forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享商城商品专题(ShareSourceTypeStoreGoodsTopic) -
- (void)shareStoreGoodsTopic
{
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:t_id 专题id)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    [_dict setObject:ShareAnalyzeTypeGoodsTopic forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享商城商品标签、品牌(ShareAnalyzeTypeGoodsTags) -
- (void)shareStoreGoodsTags
{
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:tagName 标签、品牌 tagName)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    [_dict setObject:ShareAnalyzeTypeGoodsTags forKey:SHARE_COUNT_KEY_TYPE];
}

- (void)shareOrderRedbag
{
    //展示shareView
    [self configShareView];
    
    //数据统计
    [_dict setObject:ShareAnalyzeTypeH5 forKey:SHARE_COUNT_KEY_TYPE];
}

- (void)shareVideo
{
    _shareType = ShareTypeVideo;
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:视频id)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    if (!stringIsEmpty(_shareInfoModel.track_info)) {
        [_dict setObject:_shareInfoModel.track_info forKey:@"track_info"];
    }
    [_dict setObject:ShareAnalyzeTypeVideo forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享图片(ShareSourceTypeShareImage) -
- (void)shareImage
{
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:晒单id)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    
    [_dict setObject:ShareAnalyzeTypeShareOrder forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享频道(ShareSourceTypeAllChannel) -
- (void)shareAllChannel
{
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:tag_name)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    
    [_dict setObject:ShareAnalyzeTypeTags forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享个人页(ShareSourceTypeUser) -
- (void)shareUser
{
    //展示shareView
    [self configShareView];
    
    //数据统计 (sourceId:uid)
    if (_shareInfoModel.sourceId) {
        [_dict setObject:_shareInfoModel.sourceId forKey:SHARE_COUNT_KEY_TYPE_ID];
    }
    
    [_dict setObject:ShareAnalyzeTypeUser forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享签到红包(ShareSourceTypeSiginIn) -
- (void)shareSignInRedbag
{
    //展示shareView
    [self configShareView];
    
    //数据统计
    [_dict setObject:ShareAnalyzeTypeRedbag forKey:SHARE_COUNT_KEY_TYPE];
}


#pragma mark - 分享直播(ShareSourceTypeLive) -
- (void)shareLive
{
    //展示shareView
    [self configShareView];
    
    //数据统计
    [_dict setObject:ShareAnalyzeTypeLive forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享H5 (ShareSourceTypeH5) -
- (void)shareH5
{
    //展示shareView
    [self configShareView];
    
    //数据统计
    [_dict setObject:ShareAnalyzeTypeH5 forKey:SHARE_COUNT_KEY_TYPE];
}

#pragma mark - 分享商品聚合 (ShareSourceTypeStoreAggr) -
- (void)shareStoreAggr
{
    //展示shareView
    [self configShareView];
    // 分享聚合页不需要统计
}

#pragma mark - 检测各个平台的图片资源是否被下载下来 -
- (void)checkIconDataByPlatform:(ShareManagerOptionsKey)platform
{
    //微信好友
    MDWeakPtr(weakPtr, self);
    if ([platform isEqualToString:ShareManagerToWechatSession]) {
        if (!_shareInfoModel.weixin.iconData) {
            [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_shareInfoModel.weixin.icon_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                [Util hideLoadingVw];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        weakPtr.shareInfoModel.weixin.iconData = data;
                    }
                    else {
                        UIImage *imageIcon = IMAGE(@"QQShare.jpg");
                        weakPtr.shareInfoModel.weixin.iconData = UIImageJPEGRepresentation(imageIcon, 1.0);
                    }
                    [self shareViewSelectedAction:platform];
                });
            }];
        }
        else {
            [self shareViewSelectedAction:platform];
        }
    }
    //微信朋友圈
    else if ([platform isEqualToString:ShareManagerToWechatTimeline]) {
        if (!_shareInfoModel.pengyouquan.iconData) {
            [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_shareInfoModel.pengyouquan.icon_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                [Util hideLoadingVw];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        weakPtr.shareInfoModel.pengyouquan.iconData = data;
                    }
                    else {
                        UIImage *imageIcon = IMAGE(@"QQShare.jpg");
                        weakPtr.shareInfoModel.pengyouquan.iconData = UIImageJPEGRepresentation(imageIcon, 1.0);
                    }
                    [self shareViewSelectedAction:platform];
                });
            }];
        }
        else {
            [self shareViewSelectedAction:platform];
        }
    }
    //新浪微博(优先判断是否有海报图)
    else if ([platform isEqualToString:ShareManagerToSina]) {
        if (_shareInfoModel.posterData) {
            [self shareViewSelectedAction:platform];
        }
        else {
            NSString *imageUrl = nil;
            if (stringIsEmpty(_shareInfoModel.poster_url)) {
                if (_shareInfoModel.weibo.iconData) {
                    [self shareViewSelectedAction:platform];
                    return;
                }
                else {
                     imageUrl = _shareInfoModel.weibo.icon_url;
                }
            }
            else {
                imageUrl = _shareInfoModel.poster_url;
            }
            [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                [Util hideLoadingVw];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        weakPtr.shareInfoModel.weibo.iconData = data;
                    }
                    else {
                        UIImage *imageIcon = IMAGE(@"QQShare.jpg");
                        weakPtr.shareInfoModel.weibo.iconData = UIImageJPEGRepresentation(imageIcon, 1.0);
                    }
                    [self shareViewSelectedAction:platform];
                });
            }];
        }
    }
    //QQ好友和空间暂时不需要预加载图片数据
    //QQ好友
    else if ([platform isEqualToString:ShareManagerToQQ]) {
        if (!_shareInfoModel.qq.iconData) {
            [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_shareInfoModel.qq.icon_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                [Util hideLoadingVw];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        weakPtr.shareInfoModel.qq.iconData = data;
                    }
                    else {
                        UIImage *imageIcon = IMAGE(@"QQShare.jpg");
                        weakPtr.shareInfoModel.qq.iconData = UIImageJPEGRepresentation(imageIcon, 1.0);
                    }
                    [self shareViewSelectedAction:platform];
                });
            }];
        }
        else {
            [self shareViewSelectedAction:platform];
        }
    }
    //QQ空间
    else if ([platform isEqualToString:ShareManagerToQzone]) {
        if (!_shareInfoModel.qqzone.iconData) {
            [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_shareInfoModel.qqzone.icon_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                [Util hideLoadingVw];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        weakPtr.shareInfoModel.qqzone.iconData = data;
                    }
                    else {
                        UIImage *imageIcon = IMAGE(@"QQShare.jpg");
                        weakPtr.shareInfoModel.qqzone.iconData = UIImageJPEGRepresentation(imageIcon, 1.0);
                    }
                    [self shareViewSelectedAction:platform];
                });
            }];
        }
        else {
            [self shareViewSelectedAction:platform];
        }
    }
}

#pragma mark - 分享到各个平台的处理 -
- (void)shareViewSelectedAction:(ShareManagerOptionsKey)platform
{
    NSString *object = @"";
    //微信好友
    if ([platform isEqualToString:ShareManagerToWechatSession]) {
        object = @"wechat";
        [self shareToWechatWithScene:platform];
    }
    //微信朋友圈
    else if ([platform isEqualToString:ShareManagerToWechatTimeline]) {
        object = @"timeline";
        [self shareToWechatWithScene:platform];
    }
    //新浪微博
    else if ([platform isEqualToString:ShareManagerToSina]) {
        object = @"sina";
        [self shareToSinaWeibo];
    }
    //QQ好友
    else if ([platform isEqualToString:ShareManagerToQQ]) {
        object = @"qq";
        [self shareToQQWithScene:platform];
    }
    //QQ空间
    else if ([platform isEqualToString:ShareManagerToQzone]) {
        object = @"qZone";
        [self shareToQQWithScene:platform];
    }
    //保存图片到本地
    else if ([platform isEqualToString:ShareManagerSavePoster]) {
        object = @"save_poster";
        [self shareToSavePoster];
    }
    
    // 点击的 分享平台 点击后的回调
    if (self.shareClickButtonBlock) {
        self.shareClickButtonBlock(platform);
    }
    [_dict setObject:object forKey:SHARE_COUNT_KEY_TARGET];
}

#pragma mark - 分享到微信好友和微信朋友圈 -
- (void)shareToWechatWithScene:(NSString *)scene
{
    [WXApi registerApp:APP_ID_WECHAT];
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    WXMediaMessage *message = [WXMediaMessage message];

    NSString *descriptionStr = _shareInfoModel.weixin.content;
    descriptionStr = [descriptionStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (descriptionStr.length > 50) {
        descriptionStr = [descriptionStr substringToIndex:50];
    }
    NSString *shareUrl = nil;
    if ([scene isEqualToString:ShareManagerToWechatSession]) {
        //微信好友
        request.type = WXSceneSession;
        request.scene = WXSceneSession;
        message.title = _shareInfoModel.weixin.title;
        message.description = descriptionStr;
        message.thumbData = reduceImageFileSize(_shareInfoModel.weixin.iconData, 30*1024);
        shareUrl = _shareInfoModel.weixin.target_url;
    }
    else if ([scene isEqualToString:ShareManagerToWechatTimeline]) {
        //微信朋友圈
        request.type = WXSceneTimeline;
        request.scene = WXSceneTimeline;
        message.title = _shareInfoModel.pengyouquan.title;
        message.description = descriptionStr;
        message.thumbData = reduceImageFileSize(_shareInfoModel.pengyouquan.iconData, 30*1024);
        shareUrl = _shareInfoModel.pengyouquan.target_url;
    }
    
    if (_shareType == ShareTypeVideo) {
        //卡片视频类型（H5）
        WXVideoObject *videoObject = [WXVideoObject object];
        // 微信暂不支持直接播放视频，需要用H5页面播放
        videoObject.videoUrl = shareUrl;
        message.mediaObject = videoObject;
    }
    else if (_shareType == ShareTypeImage) {
        //分享图片
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = _shareInfoModel.posterData;
        message.mediaObject = imageObject;
        message.thumbData = reduceImageFileSize(_shareInfoModel.posterThumData, 30*1024);
        //此处防止包含@"/"符合导致iOS分享到安卓无法下载图片
        message.title = @"美哒";
        message.description = @"美哒";
    }
    else {
        //卡片图文类型（H5）
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareUrl;
        message.mediaObject = webObject;
    }
    
    request.message = message;
    request.openID = LOGIN_USER.openId;
    [WXApi sendReq:request];
}

#pragma mark - 分享到新浪微博 -
- (void)shareToSinaWeibo
{
    [WeiboSDK registerApp:SINA_APPKEY];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SINA_REDIRECT_URL;
    authRequest.scope = @"all";
    WBMessageObject *messageObject = [WBMessageObject message];
    
    NSString *title = _shareInfoModel.weibo.title;
    NSString *shareUrl = _shareInfoModel.weibo.target_url;
    NSString *text = _shareInfoModel.weibo.content;
    NSString *desc = _shareInfoModel.weibo.desc;
    NSData *imageData = reduceImageFileSize(_shareInfoModel.weibo.iconData, 1*1024*1024);;
    
    if (title.length > 511) {
        title = [title substringToIndex:511];
    }
    if (text.length > 139) {
        text = [text substringToIndex:139];
    }
    if (desc.length > 511) {
        desc = [desc substringToIndex:511];
    }
    
    if (_shareType == ShareTypeVideo) {
        // 视频LinkCard分享
        if ([WeiboSDK isCanShareInWeiboAPP]) {
            // 安装客户端可以分享成LinkCard
            //和下面方法效果一样，需要进一步研究
//            WBVideoObject *videoObject = [WBVideoObject object];
//            videoObject.objectID = _shareInfoModel.sourceId;
//            videoObject.title = title;
//            videoObject.description = desc;
//            videoObject.thumbnailData = reduceImageFileSize(_shareInfoModel.weibo.iconData, 30*1024);
//            videoObject.videoUrl = shareUrl;
////            videoObject.videoLowBandUrl = shareUrl;
//            messageObject.mediaObject = videoObject;
//            messageObject.text = text;
            
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = _shareInfoModel.sourceId;
            webpage.title = title;
            webpage.description = desc;
            webpage.thumbnailData = reduceImageFileSize(_shareInfoModel.weibo.iconData, 30*1024);
            webpage.webpageUrl = shareUrl;
            messageObject.mediaObject = webpage;
            
            messageObject.text = text;
        }
        else {
            // 没有客户端  要用网页分享  图文样式
            messageObject.text = title;
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = imageData;
            messageObject.imageObject = imageObject;
        }
    }
    else if (_shareType == ShareTypeImage) {
        messageObject.text = title;
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = _shareInfoModel.posterData;
        messageObject.imageObject = imageObject;
    }
    else {
        messageObject.text = title;
        WBImageObject *imageObject = [WBImageObject object];
        if (_shareInfoModel.posterData) {
            imageObject.imageData = _shareInfoModel.posterData;
        }
        else {
            imageObject.imageData = imageData;
        }
        messageObject.imageObject = imageObject;
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObject authInfo:authRequest access_token:nil];
    request.message = messageObject;
    [WeiboSDK sendRequest:request];
}

#pragma mark - 分享到QQ和QZone -
- (void)shareToQQWithScene:(NSString *)scene
{
    TencentOAuth *oauth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:nil];
    DLog(@"%@",oauth);
    
    NSString *title = nil;
    NSString *shareUrl = nil;
    NSString *text = nil;
    NSData *imageData = nil;
    
    if ([scene isEqualToString:ShareManagerToQQ]) {
        //QQ
        title = _shareInfoModel.qq.title;
        text = _shareInfoModel.qq.content;
        shareUrl = _shareInfoModel.qq.target_url;
        imageData = reduceImageFileSize(_shareInfoModel.qq.iconData, 0.8*1024*1024);
    }
    else {
        //QQ空间 (title控制在17个字以内，否则text内容在QQ客户端显示不出来，但是在QQ空间客户端能显示出来)
        title = _shareInfoModel.qqzone.title;
        text = _shareInfoModel.qqzone.content;
        shareUrl = _shareInfoModel.qqzone.target_url;
        imageData = reduceImageFileSize(_shareInfoModel.qqzone.iconData, 0.8*1024*1024);
    }
    
    QQApiObject *object = nil;
    if (_shareType == ShareTypeVideo) {
        //视频
        QQApiVideoObject *videoObject = [QQApiVideoObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:text previewImageData:imageData];
        videoObject.flashURL = [NSURL URLWithString:shareUrl];
        object = videoObject;
    }
    else if (_shareType == ShareTypeImage) {
        //分享图片
        QQApiImageObject *imageObject = [QQApiImageObject objectWithData:_shareInfoModel.posterData previewImageData:nil title:title description:text];
        object = imageObject;
    }
    else {
        //图文
        //object = [QQApiURLObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:text previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
        //QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:text previewImageURL:iconUrl];
        QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:text previewImageData:imageData];
        object = newsObject;
    }
    
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:object];
    request.type = ESENDMESSAGETOQQREQTYPE;
    
    if ([scene isEqualToString:ShareManagerToQQ]) {
        //分享到QQ
        [QQApiInterface sendReq:request];
    }
    else {
        //分享到QQ空间
        [QQApiInterface SendReqToQZone:request];
    }
}

//保存海报到本地
- (void)shareToSavePoster
{
    if (!_shareInfoModel.posterData) {
        [Util showMessage:@"图片未下载" forDuration:1.5f inView:MDAPPDELEGATE.window];
        return;
    }
    UIImage *savedImage = [UIImage imageWithData:_shareInfoModel.posterData];
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if (error != NULL) {
        msg = @"保存失败" ;
    }
    else {
        msg = @"保存成功" ;
    }
    [Util showMessage:msg forDuration:1.5f inView:MDAPPDELEGATE.window];
}

// 获取所有的分享平台
- (NSArray *)getAllSharePlatformName
{
    NSArray *allPlatform = @[ShareManagerToWechatSession, ShareManagerToWechatTimeline, ShareManagerToSina, ShareManagerToQQ, ShareManagerToQzone];
    return allPlatform;
}

- (void)initData
{
    _dict = nil;
    _shareFinishBlock = nil;
}

#pragma mark - QQApiInterfaceDelegate -
#pragma mark - 各平台分享回调 -
// qq && qZone && 微信  && 朋友圈
- (void)onResp:(QQBaseResp *)resp
{
    NSString *message = nil;
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {// qq回调
        SendMessageToQQResp *result = (SendMessageToQQResp *)resp;
        NSInteger errcode = [result.result integerValue];
        switch (errcode)
        {
            case EQQAPISENDSUCESS:
            {
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, YES);
                }
                [self feedBack];
                message = @"分享成功";
                break;
            }
            case -4:
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, NO);
                }
                message = @"取消分享";
                break;
            default:
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, NO);
                }
                message = @"分享失败";
                break;
        }
    }
    else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 微信回调
        SendMessageToWXResp *result = (SendMessageToWXResp *)resp;
        
        switch (result.errCode)
        {
            case WXSuccess:
            {
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, YES);
                }
                [self feedBack];
                message = @"分享成功";
                break;
            }
                
            case WXErrCodeUserCancel:
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, NO);
                }
                message = @"取消分享";
                break;
                
            case WXErrCodeSentFail:
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, NO);
                }
                message = @"发送失败";
                break;
                
            case WXErrCodeAuthDeny:
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, NO);
                }
                message = @"授权失败";
                break;
                
            case WXErrCodeUnsupport:
                if (_shareFinishBlock) {
                    _shareFinishBlock(_platform, NO);
                }
                message = @"微信不支持";
            default:
                break;
        }
    }
    //登录的微信回调
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *result = (SendAuthResp *)resp;
        switch (result.errCode)
        {
            case WXErrCodeAuthDeny:
            {
                [Util showMessage:@"拒绝授权" forDuration:1.5 inView:MDAPPDELEGATE.window];
            }
                break;
                
            case WXErrCodeUserCancel:
            {
                [Util showMessage:@"取消授权" forDuration:1.5 inView:MDAPPDELEGATE.window];
            }
                break;
            default:
                break;
        }
    }
    
    [Util showMessage:message forDuration:1.5 inView:MDAPPDELEGATE.window];
}

- (void)onReq:(QQBaseReq *)req
{
    DLog(@"req = %@", req);
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    DLog(@"response = %@", response);
}

// 新浪微博
- (void)didReceiveWeiboShareResponse:(NSInteger)statusCode
{
    NSString *message = nil;
    if (statusCode == WeiboSDKResponseStatusCodeSuccess) {
        if (_shareFinishBlock) {
            _shareFinishBlock(_platform, YES);
        }
        message = @"分享成功";
        [self feedBack];
    }
    else if (statusCode == WeiboSDKResponseStatusCodeUserCancel) {
        if (_shareFinishBlock) {
            _shareFinishBlock(_platform, NO);
        }
        message = @"取消分享";
    }
    else if (statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
        if (_shareFinishBlock) {
            _shareFinishBlock(_platform, NO);
        }
        message = @"授权失败";
    }
    else if (statusCode == WeiboSDKResponseStatusCodeSentFail) {
        if (_shareFinishBlock) {
            _shareFinishBlock(_platform, NO);
        }
        message = @"发送失败";
    }
    else if (statusCode == WeiboSDKResponseStatusCodeShareInSDKFailed) {
        if (_shareFinishBlock) {
            _shareFinishBlock(_platform, NO);
        }
        message = @"分享失败";
    }
    else {
        if (_shareFinishBlock) {
            _shareFinishBlock(_platform, NO);
        }
        message = @"未知错误";
    }
    
    [Util showMessage:message forDuration:1.5 inView:MDAPPDELEGATE.window];
}

- (void)feedBack
{
}




@end
