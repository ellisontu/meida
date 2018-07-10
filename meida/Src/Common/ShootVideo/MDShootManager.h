//
//  MDShootManager.h
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 拍照 拍视频配置信息  info  ###########  -----------------------
// 视频录制 时长
#define RecordTime        60.1
#define kLongPressMin       0
//区分视频还是照片的界限
#define kPhotoTime          2
#define SHOOT_RATIO         656.0/750
#define SHOOT_WIDTH         [UIScreen mainScreen].bounds.size.width
#define SHOOT_HEIGHT        (SHOOT_WIDTH * SHOOT_RATIO)
// 视频保存路径
#define VideoDicName      @"SmailVideo"
#define BOTTOM_HEIGHT       80
#define SHOOT_TOP           65
#define SHOOT_LEFT          0
#define SCREEN_WIDTH      [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height
//加载bundle中的图片资源
#define ShootBundleName   @"ShootIcons"
#define ImageFromBundle(x)     [UIImage imageNamed:[[[NSBundle mainBundle] pathForResource:ShootBundleName ofType:@"bundle"] stringByAppendingPathComponent:x]]


#pragma mark - 拍照 拍视频管理类  manager  ###########  -----------------------
@class VideoModel;

@interface MDShootManager : NSObject

+ (MDShootManager *)shareManager;

/*!
 *  有视频的存在
 */
+ (BOOL)existVideo;

/*!
 *  时间倒序 后的视频列表
 */
+ (NSArray *)getSortVideoList;

/*!
 *  保存缩略图
 *
 *  @param videoUrl 视频路径
 *  @param second   第几秒的缩略图
 */
+ (void)saveThumImageWithVideoURL:(NSURL *)videoUrl second:(int64_t)second;

/*!
 *  产生新的对象
 */
+ (VideoModel *)createNewVideo;

/*!
 *  删除视频
 */
+ (void)deleteVideo:(NSString *)videoPath;


/*!
 *  存储路径
 */

+ (NSString *)getVideoPath;

- (BOOL)judgeIsHaveShootVideoAuthorityWithCallBackViewController: (UIViewController *)vc;
+ (BOOL)judgeIsHaveCameraAuthority;
+ (BOOL)judgeIsHaveAudioAuthority;

@end


#pragma mark - 视频对象 model  ###########  -----------------------
/*!
 *  视频对象 Model类
 */
@interface VideoModel : NSObject
@property (nonatomic, copy) NSString    *videoAbsolutePath; /**< 完整视频 本地路径 */
@property (nonatomic, copy) NSString    *thumAbsolutePath;  /**< 缩略图 路径 */
@property (nonatomic, strong) NSDate    *recordTime;        /**< 录制时间 */
@property (nonatomic, strong) UIImage   *shootImage;    /**< 点击拍摄的图片 (有 shootImage 就说明是点击拍摄的照片,而不是视频) */
@property (nonatomic, copy) NSString    *qiniuUrl;          /**<  */
@property (nonatomic, assign) NSInteger videoWidth;         /**<  */
@property (nonatomic, assign) NSInteger videoHeight;        /**<  */
@property (nonatomic, assign) CGFloat   videoDuration;      /**<  */

@end


#pragma mark - 视频摄制对象 model  ###########  -----------------------
@interface MDShootModel : BaseModel

@property (nonatomic, copy) NSString    *videoAbsolutePath;     /**< 完整视频 本地路径 */
@property (nonatomic, copy) NSString    *thumAbsolutePath;      /**< 缩略图 路径 */
@property (nonatomic, strong) NSDate    *recordTime;            /**< 录制时间 */

@end
