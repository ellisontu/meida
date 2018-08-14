//
//  MDVideoPlayView.h
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDVideoPlayView;

typedef NS_ENUM(NSUInteger, VideoPlayViewSourceType) {
    VideoPlayViewSourceTypeUnknow = 0,  /**< 未知(默认) */
    VideoPlayViewSourceTypeALAsset,     /**< 播放本地相册里的视频 */
    VideoPlayViewSourceTypeRemote,      /**< 播放远程视频 */
    VideoPlayViewSourceTypeDocument     /**< 播放沙盒路径下的视频 */
};

typedef NS_ENUM(NSUInteger, XHCPlayerStatus) {
    XHCPlayerStatusUnknow = 0,  /**< 未知状态，只会作为 init 后的初始状态，开始播放之后任何情况下都不会再回到此状态 */
    XHCPlayerStatusPreparing,   /**< 正在准备播放所需组件， 在调用 -videoPlay 方法时会出现 */
    XHCPlayerStatusCaching,     /**< 播放远程视频 loading 时出现 */
    XHCPlayerStatusPlaying,     /**< 正在播放状态 */
    XHCPlayerStatusPaused,      /**< 暂停状态 */
    XHCPlayerStatusStoped,      /**< 停止状态,该状态仅会在播放结束时出现 */
    XHCPlayerStatusError        /**< 错误状态，播放出现错误时会出现此状态 */
};

@protocol VideoPlayViewDelegate <NSObject>

@optional

/**
 *  告知代理对象播放器状态变更
 *
 *  @param videoView 调用该方法的 XHCVideoPlayView 对象
 *  @param state     变更之后的 XHCPlayerStatus 状态
 */
- (void)videoPlayView:(MDVideoPlayView *)videoView statusDidChange:(XHCPlayerStatus)state;

/**
 *  底部操作栏显示和隐藏时执行
 *
 *  @param videoView 当前 XHCVideoPlayView 对象
 *  @param isShow    是否显示底部操作栏
 */
- (void)videoPlayView:(MDVideoPlayView *)videoView showBottomView:(BOOL)isShow;

@end


@interface MDVideoPlayView : UIView

@property (nonatomic, assign) VideoPlayViewSourceType videoType;    /**< 视频来源类型 */

@property (nonatomic, strong) NSString *videoUrl;                   /**< 视频播放地址 */

@property (nonatomic, strong) UIImage  *coverImage;                 /**< 封面图 */

@property (nonatomic, strong) NSString *coverImageUrl;              /**< 封面图URL */
@property (nonatomic, assign) BOOL      isShowBotmView;     

@property (nonatomic, weak) id<VideoPlayViewDelegate> delegate;

@property (nonatomic, assign) float volume;                         /**< audio volume:0--1 default:1 */

@property (nonatomic, assign) BOOL muted;                           /**< 是否静音🔇 default:NO */

/**
 *  视频播放
 */
- (void)videoPlay;

/**
 *  暂停播放
 */
- (void)videoPause;

/**
 *  当播放器处于暂停状态时调用该方法可以使播放器继续播放
 */
- (void)videoResume;

/**
 *  视频销毁
 */
- (void)videoDestroy;

- (void)seek:(CGFloat)progress;

@end
