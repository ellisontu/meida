//
//  MediaResourcesManager.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MediaResourcesManager.h"
#import "MediaAlbumsModel.h"
#import "MediaAssetModel.h"
#import "LocalFileManager.h"
#import "UIImage+Capture.h"

static dispatch_once_t onceToken;
static MediaResourcesManager *mediaManager = nil;

@interface MediaResourcesManager ()

@property (nonatomic, strong) PHImageRequestOptions *imageRequestOption;    /**< 控制加载图片时的一系列参数 */

@end


@implementation MediaResourcesManager

+ (id _Nonnull)shareInstance
{
    dispatch_once(&onceToken, ^{
        mediaManager = [[MediaResourcesManager alloc] init];
    });
    
    return mediaManager;
}

/**
 *  是否可以访问相册
 */
+ (BOOL)canAccessAlbumsAndCamera
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        //无权限
        return NO;
    }
    
    return YES;
}


#pragma mark - photo
/**
 *  读取相册列表
 */
+ (void)fetchAlbums:(void(^_Nonnull)(NSArray <MediaAlbumsModel *>*_Nonnull albums, BOOL success))completion
{
    // 装载所有相册
    __block NSMutableArray *_arrAlbums = [[NSMutableArray alloc] init];
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(_arrAlbums, NO);
            }
        });
    }
    else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                /**
                 *  PHAssetCollectionType
                 *
                 *  Album       从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
                 *  SmartAlbum  由相机得来的相册
                 *  Moment      为我们自动生成的时间分组的相册
                 */
                
                // 所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
                [self fetchAlbumsWithType:PHAssetCollectionTypeSmartAlbum
                                  subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                  options:nil
                                resultArr:_arrAlbums];
                
                //收藏
                [self fetchAlbumsWithType:PHAssetCollectionTypeSmartAlbum
                                  subtype:PHAssetCollectionSubtypeSmartAlbumFavorites
                                  options:nil
                                resultArr:_arrAlbums];
                
                if (IOS_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                    /**
                     *  需要9.0及以上系统支持
                     *  PHAssetCollectionSubtypeSmartAlbumSelfPortraits 自拍
                     *  PHAssetCollectionSubtypeSmartAlbumScreenshots   截屏
                     */
                    [self fetchAlbumsWithType:PHAssetCollectionTypeSmartAlbum
                                      subtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits
                                      options:nil
                                    resultArr:_arrAlbums];
                    
                    [self fetchAlbumsWithType:PHAssetCollectionTypeSmartAlbum
                                      subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots
                                      options:nil
                                    resultArr:_arrAlbums];
                }
                
                // 其他相册（包括手动和第三方应用创建的)
                [self fetchAlbumsWithType:PHAssetCollectionTypeAlbum
                                  subtype:PHAssetCollectionSubtypeAlbumRegular
                                  options:nil
                                resultArr:_arrAlbums];
                
                // 从相机或是外部存储导入的相册
                [self fetchAlbumsWithType:PHAssetCollectionTypeAlbum
                                  subtype:PHAssetCollectionSubtypeAlbumImported
                                  options:nil
                                resultArr:_arrAlbums];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(_arrAlbums, YES);
                    }
                });
            }
            else {
                if (status != PHAuthorizationStatusNotDetermined) {
                    //无权限
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(_arrAlbums, NO);
                        }
                    });
                }
            }
        }];
    }
}

/**
 *  iOS8 以上的相册列表获取(获取不同的专辑)
 */
+ (NSArray <MediaAlbumsModel *> *)fetchAlbumsWithType:(PHAssetCollectionType)type
                                              subtype:(PHAssetCollectionSubtype)subtype
                                              options:(nullable PHFetchOptions *)options
                                            resultArr:(NSMutableArray *_Nonnull)resultArr
{
    // PHFetchResult: 表示一系列的资源结果集合，也可以是相册的集合，从 PHCollection 的类方法中获得
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                       subtype:subtype
                                                                       options:options];
    // PHAssetCollection: PHCollection 的子类，表示一个相册或者一个时刻，或者是一智能相册
    //（系统提供的特定的一系列相册，例如：最近删除，视频列表，收藏等等）
    for (PHAssetCollection *collection in albums) {
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (fetchResult.count == 0) {
            continue;
        }
    
        MediaAlbumsModel *mAlbum = [[MediaAlbumsModel alloc] initWithFetchResult:fetchResult
                                                                            name:collection.localizedTitle
                                                                      assetCount:[fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]];
        
        if ([mAlbum.name isEqualToString:@"Camera Roll"]
            || [mAlbum.name isEqualToString:@"相机胶卷"]
            || [mAlbum.name isEqualToString:@"所有照片"]) {
            
            [resultArr insertObject:mAlbum atIndex:0];
        }
        else {
            if (mAlbum.assetCount > 0) {
                [resultArr addObject:mAlbum];
            }
        }
    }
    
    return resultArr;
}

/**
 *  读取相册(PHFetchResult/ALAssetsGroup)内 assets
 */
+ (void)fetchAssetsWithAlbum:(id _Nonnull)album
                  completion:(void(^_Nonnull)(NSArray <MediaAssetModel *>*_Nonnull assets, BOOL success))completion
{
    __block NSMutableArray *photoArr = [NSMutableArray array];
    
    id albumTemp = [album isKindOfClass:[MediaAlbumsModel class]] ? [album fetchResult] : album;
    
    if ([albumTemp isKindOfClass:[PHFetchResult class]]) {
        
        [albumTemp enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            MediaAssetModel *mAsset = [[MediaAssetModel alloc] initWithAsset:asset];
            if (mAsset.assetMediaType == 1) {
                [photoArr insertObject:mAsset atIndex:0];
            }
        }];
    }
    
    if (completion) {
        completion(photoArr, photoArr.count);
    }
}

/**
 *  读取 asset(PHAsset/ALAsset) 内 image
 */
- (void)fetchImageWithAsset:(id _Nonnull)asset
                 targetSize:(CGSize)targetSize
                 completion:(void(^_Nullable)(UIImage *_Nullable image, NSDictionary *_Nullable info))completion;

{
    __block UIImage *resultImage = nil;
    __block NSDictionary *resultInfo = nil;
    
    id assetTemp = [asset isKindOfClass:[MediaAssetModel class]] ? [asset asset] : asset;
    
    if ([assetTemp isKindOfClass:[PHAsset class]]) {
        // PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，
        // 可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
        // synchronous 为 NO 状态下 resultHandler 会被多次调用 即先返回较低质量 再返回较高质量  YES 状态则直接返回要求图片
        [[PHImageManager defaultManager] requestImageForAsset:assetTemp
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:self.imageRequestOption
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
        {
            resultImage = [result normalizedImage];
            //resultImage = result;
            resultInfo = info;
            
            // 存在云上的只取缩略图
            id isIcloud = [info objectForKey:PHImageResultIsInCloudKey];
            if (isIcloud && [isIcloud boolValue]) {
                
                PHImageRequestOptions *requestOption = [[PHImageRequestOptions alloc] init];
                [[PHImageManager defaultManager] requestImageForAsset:assetTemp
                                                           targetSize:targetSize
                                                          contentMode:PHImageContentModeDefault
                                                              options:requestOption
                                                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
                {
                    resultImage = result;
                    // 这块不重新赋值 不然会影响 MediaAssetModel.isCloudImage 的判断
                    // resultInfo = info;
                }];
            }
            
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined) {
                
            }
        }];
    }
    
    if (completion) {
        completion(resultImage, resultInfo);
    }
}

//- (void)requestIcloudImageWithInfo:(NSDictionary *)info
//                             asset:(id _Nonnull)asset
//                        targetSize:(CGSize)targetSize
//                        completion:(void(^_Nullable)(UIImage *_Nullable image, NSDictionary *_Nullable info))completion;
//{
//    __block UIImage *resultImage = nil;
//    __block NSDictionary *resultInfo = nil;
//    // 存在云上的在 WiFi 状态自动下载
//    PHImageRequestOptions *requestOption = [[PHImageRequestOptions alloc] init];
//    requestOption.resizeMode = PHImageRequestOptionsResizeModeFast;
//    requestOption.synchronous = YES;
//    requestOption.networkAccessAllowed = [[XHCNetWorking sharedClient] isConnectedViaWiFi] ? YES : NO;
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:kOriginTargetSize contentMode:PHImageContentModeDefault options:requestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        
//        if ([[XHCNetWorking sharedClient] isConnectedViaWiFi]) {
//            // 排除取消，错误，低清图三种情况，即已经获取到了高清图
//            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];   
//            if (!downloadFinined) {
//                resultInfo = info;
//                resultImage = result;
//            }
//        }
//        else {
//            resultInfo = info;
//            resultImage = result;
//        }
//
//    }];
//    
//    if (completion) {
//        completion(resultImage, resultInfo);
//    }
//}

/**
 *  保存图片到相册
 */
+ (void)saveThePhotosToTheLocal:(UIImage *_Nonnull)image completion:(void(^_Nullable)(id _Nullable asset, BOOL success))completion
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(imageAsset, YES);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(nil, NO);
                }
            });
        }
        
    }];
}


#pragma mark - video
/**
 *  读取相册内视频
 */
+ (void)fetchAssetsWithVideoAlbum:(void(^_Nonnull)(NSArray <MediaAssetModel *>*_Nonnull videoAssets, BOOL success))completion;
{
    // 装载所有相册
    __block NSMutableArray *_arrVideoAssets = [[NSMutableArray alloc] init];
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(_arrVideoAssets, NO);
            }
        });
    }
    else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                // 视频
                PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
                
                [fetchResult enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    MediaAssetModel *mAsset = [[MediaAssetModel alloc] initWithAsset:asset];
                    if (mAsset.assetMediaType == 2) {
                        [_arrVideoAssets insertObject:mAsset atIndex:0];
                    }
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(_arrVideoAssets, YES);
                    }
                });
            }
            else {
                if (status != PHAuthorizationStatusNotDetermined) {
                    //无权限
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(_arrVideoAssets, NO);
                        }
                    });
                }
            }
        }];
    }
}

+ (void)fetchVideoAssetsUrl:(MediaAssetModel *)assetModel completion:(void (^ _Nullable)(MediaAssetModel * _Nonnull, BOOL))completion
{
    if (!assetModel.isCloudVideo || [assetModel.isCloudVideo isEqual:@0]) {
        if (assetModel.asset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            [[PHImageManager defaultManager] requestAVAssetForVideo:assetModel.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                // 获取不到资源/地址 默认在 icloud
                if ([asset isKindOfClass:[AVComposition class]]) {
                    assetModel.isCloudVideo = @1;
                }
                else {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    if (!stringIsEmpty(urlAsset.URL.absoluteString)) {
                        assetModel.isCloudVideo = @0;
                        assetModel.assetUrl = urlAsset.URL;
                    }
                    else {
                        assetModel.isCloudVideo = @1;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(assetModel, [assetModel.isCloudVideo boolValue]);
                });
            }];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(assetModel, [assetModel.isCloudVideo boolValue]);
        });
    }
}

- (PHImageRequestOptions *)imageRequestOption {
    if (!_imageRequestOption) {
        _imageRequestOption = [[PHImageRequestOptions alloc] init];
        // 这块配置的才管用 contentMode:PHImageContentModeAspectFill 不好使
        _imageRequestOption.resizeMode = PHImageRequestOptionsResizeModeFast;
        // 是否同步下载 默认为 NO
        _imageRequestOption.synchronous = YES;
//        // 是否使用网络 默认为 NO
//        _imageRequestOption.networkAccessAllowed = YES;
    }
    
    return _imageRequestOption;
}


#pragma mark - 清理
+ (void)singletonDealloc
{
    mediaManager = nil;
    onceToken = 0;
}

+ (void)clearShareBuyImage
{
    // 清除本地存储的图片
    NSString *cachePath = [LocalFileManager getCachePath];
    NSString *folderDirectory = [cachePath stringByAppendingPathComponent:kShareBuyImageFile];
    if ([LocalFileManager deleteAllFileFromFolderPath:folderDirectory]) {
        DLog(@"清除成功");
    }
}

+ (void)clearNewShareBuyImage
{
    // 清除本地存储的图片
    NSString *cachePath = [LocalFileManager getCachePath];
    NSString *folderDirectory = [cachePath stringByAppendingPathComponent:kNewShareBuyImageFile];
    if ([LocalFileManager deleteAllFileFromFolderPath:folderDirectory]) {
        DLog(@"清除成功");
    }
}

- (NSInteger)checkChooseAssetsWithModel:(MediaAssetModel *)model selectArr:(NSMutableArray *)selectArr
{
    for (int i = 0; i < selectArr.count; i ++) {
        MediaAssetModel *didSecModel = selectArr[i];
        if ([model.asset.localIdentifier isEqualToString: didSecModel.asset.localIdentifier]) {
            return i;
        }
    }
    
    return -1;
}

@end
