//
//  MediaAssetModel.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  本地图片模型

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MediaAssetModel : NSObject

/**
 *  PHAsset/ALAsset
 */
@property (nonatomic, strong, readonly, nonnull) PHAsset *asset;

/**
 *  原图 (默认尺寸kOriginTargetSize)
 */
@property (nonatomic, strong, readonly, nonnull) UIImage *originImage;

/**
 *  预览图（默认尺寸kPreviewTargetSize）
 */
@property (nonatomic, strong, readonly, nonnull) UIImage *previewImage;

/**
 *  缩略图（默认尺寸kThumbnailTargetSize)
 */
@property (nonatomic, strong, readonly, nonnull) UIImage *thumbnailImage;

/**
 *  照片方向
 */
@property (nonatomic, assign, readonly) UIImageOrientation imageOrientation;

/**
 *  图片是否在iCloud中
 */
@property (nonatomic, assign, readonly) BOOL isCloudImage;

/**
 *  是否选中
 */
@property (nonatomic, assign) BOOL selected;

/**
 *  视频 asset url
 */
@property (nonatomic, nonnull) NSURL *assetUrl;

/**
 *  视频是否在iCloud中
 */
@property (nonatomic, strong, nonnull) NSNumber *isCloudVideo;

/**
 *  初始化相片model
 *
 *  @param asset PHAsset/ALAsset
 *
 *  @return SYAsset
 */
- (id _Nonnull)initWithAsset:(id _Nonnull)asset;

/**
 *  媒体资源类型
 *
 *  PHAssetMediaTypeUnknown = 0,
 *  PHAssetMediaTypeImage   = 1,
 *  PHAssetMediaTypeVideo   = 2,
 *  PHAssetMediaTypeAudio   = 3,
 */
- (NSInteger)assetMediaType;


@end
