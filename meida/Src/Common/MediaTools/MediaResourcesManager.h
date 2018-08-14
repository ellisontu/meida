//
//  MediaResourcesManager.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  专门用来获取本地视频/图片资源

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#define kCellWidth              ((SCR_WIDTH - 30) / 4.0)                /**< 每行四个image */
#define kPreviewTargetSize      ([UIScreen mainScreen].bounds.size)     /**< 预览图尺寸 */
#define kThumbnailTargetSize    (CGSizeMake(kCellWidth * kScreenScale, kCellWidth * kScreenScale))  /**< 缩略图尺寸 */
#define kOriginTargetSize       CGSizeMake(SCR_WIDTH * kScreenScale, SCR_HEIGHT * kScreenScale)     /**< 原图尺寸 */

@class MediaAlbumsModel,MediaAssetModel;

@interface MediaResourcesManager : NSObject

+ (id _Nonnull)shareInstance;

/**
 *  是否可以访问相册
 */
+ (BOOL)canAccessAlbumsAndCamera;

/**
 *  读取相册列表
 */
+ (void)fetchAlbums:(void(^_Nonnull)(NSArray <MediaAlbumsModel *>*_Nonnull albums, BOOL success))completion;
/**
 *  获取指定的专辑
 */
+ (NSArray <MediaAlbumsModel *> *_Nullable)fetchAlbumsWithType:(PHAssetCollectionType)type
                                                       subtype:(PHAssetCollectionSubtype)subtype
                                                       options:(nullable PHFetchOptions *)options
                                                     resultArr:(NSMutableArray *_Nonnull)resultArr;

/**
 *  读取相册内assets
 */
+ (void)fetchAssetsWithAlbum:(id _Nonnull)album
                  completion:(void(^_Nonnull)(NSArray <MediaAssetModel *>*_Nonnull assets, BOOL success))completion;
/**
 *  读取asset内image
 */
- (void)fetchImageWithAsset:(id _Nonnull)asset
                 targetSize:(CGSize)targetSize
                 completion:(void(^_Nullable)(UIImage *_Nullable image, NSDictionary *_Nullable info))completion;

/**
 *  保存图片到本地相册
 */
+ (void)saveThePhotosToTheLocal:(UIImage *_Nonnull)image completion:(void(^_Nullable)(id _Nullable asset, BOOL success))completion;

#pragma mark - 视频直接用这个获取
/**
 *  读取相册内视频
 */
+ (void)fetchAssetsWithVideoAlbum:(void(^_Nonnull)(NSArray <MediaAssetModel *>*_Nonnull videoAssets, BOOL success))completion;

+ (void)fetchVideoAssetsUrl:(MediaAssetModel* _Nonnull)assetModel
                 completion:(void(^_Nullable)(MediaAssetModel* _Nonnull assetModel, BOOL isIniCloud))completion;


#pragma mark - 清理
// 销毁单例 --> 收到内存警告
+ (void)singletonDealloc;

// 清理晒单文件夹的本地图片
+ (void)clearShareBuyImage;
+ (void)clearNewShareBuyImage;


#pragma mark - 比较 asset
/**
 *  model : 要添加的对象
 *  selectArr : 已选中的图片组
 *  return : 已存在返回 index 不存在返回 -1
 */
- (NSInteger)checkChooseAssetsWithModel:(MediaAssetModel *_Nonnull)model selectArr:(NSMutableArray *_Nonnull)selectArr;

@end
