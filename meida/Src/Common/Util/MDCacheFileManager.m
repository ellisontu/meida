//
//  MDCacheFileManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDCacheFileManager.h"
#import "LSFileManage.h"

static CGFloat   const sizeRate = 1024.f*1024.f;
/**
 *  当使用 NSURL 相关的框架，使用到缓存的时候，
 *  系统会在 Caches目录下创建一个 跟 bundle identifer 同名的一个文件夹，
 *  以及里面的 Cache.db、Cache.db-shm、Cache.db-wal 三个文件
 *  和文件夹 fsCacheData/，·fsCacheData/ 文件夹会在有需要缓存数据到文件的数据才会有，如缓存图片
 */
static NSString *const nsUrlCacheDir    = @"fsCachedData";
/**
 *  视频全部缓存后，由 videoCacheDir 移动到 videoDownloadDir 中 （视频已经本地不缓存了，暂时此目录中没有存文件）
 */
static NSString *const videoDownloadDir = @"MDDownloadTemp";
static NSString *const videoCacheDir    = @"MDVideoCache";     /**< 播放视频临时缓存（暂未做缓存) */
static NSString *const draftsDir        = @"drafts";            /**< 草稿箱文件夹 */
static NSString *const clipVideoDir     = @"clipVideoDir";      /**< 发布视频处理中间文件夹 */
static NSString *const shareBuyImageDir = @"shareBuyImageFile"; /**< 晒单图片处理文件夹 */
static NSString *const tabbarIconsDir   = @"tabbarIconsDir";    /**< tabbar活动icons文件夹 */
static NSString *const weexDir          = @"weex";              /**< weex文件夹 */
static NSString *const exceptionFile    = @"exceptionFile";     /**< 储存app崩溃信息文件 */

@implementation MDCacheFileManager

+ (NSString *)cachePathWithType:(MDCacheType)type
{
    NSString *resultPath = nil;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    switch (type) {
        case CacheDraft:
        {
            resultPath = [cachePath stringByAppendingPathComponent:draftsDir];
        }
            break;
            
        case CacheClipVideoTemp:
        {
            resultPath = [cachePath stringByAppendingPathComponent:clipVideoDir];
        }
            break;
            
        case CacheVideoCache:
        {
            resultPath = [cachePath stringByAppendingPathComponent:videoCacheDir];
        }
            break;
            
        case CacheVideoDownload:
        {
            resultPath = [cachePath stringByAppendingPathComponent:videoDownloadDir];
        }
            break;
            
        case CacheTabBarIcons:
        {
            resultPath = [cachePath stringByAppendingPathComponent:tabbarIconsDir];
        }
            break;
            
        case CacheWeex:
        {
            resultPath = [[LSFileManage getDocumentsPath] stringByAppendingPathComponent:weexDir];
        }
            break;
            
        case CacheShareBuyImage:
        {
            resultPath = [cachePath stringByAppendingPathComponent:shareBuyImageDir];
        }
            break;
            
        case CacheNSURLCache:
        {
            NSString *subPath = [NSString stringWithFormat:@"%@/%@", BUNDLE_ID, nsUrlCacheDir];
            resultPath = [cachePath stringByAppendingPathComponent:subPath];
        }
            break;
            
        case CacheExceptionFile:
        {
            resultPath = [cachePath stringByAppendingPathComponent:exceptionFile];
            // 暂时这么处理，待优化
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:resultPath]) {
                NSError *error = nil;
                [fileManager createFileAtPath:resultPath contents:nil attributes:nil];
                if (error) {
                    DLog(@"%@", error.domain);
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:resultPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:resultPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DLog(@"%@", error.domain);
        }
    }
    
    return resultPath;
}

/**
 清空 XX 文件夹缓存
 */
+ (void)clearDiskWithType:(MDCacheType)type
{
    NSString *cachePath = [self cachePathWithType:type];
    [LSFileManage deleteFileAtPath:cachePath];
}

/**
 清空公共的文件缓存
 */
+ (void)clearPublicDiskCache
{
    NSArray *publicCachePathArray = [self _getPublicCachePathArray];
    for (NSString *cachePath in publicCachePathArray) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [[SDImageCache sharedImageCache] clearDisk];
}

/**
 自动检查app存储空间，如果缓存超过最大缓存数时，自动清除缓存
 */
+ (void)autoReleaseLocalStorage
{
    [self _moveDraftPath];
    [self _removeRubbishFiles];
    [self _checkLocalStorage];
}

/**
 获取工程所有缓存大小
 */
+ (CGFloat)getTotalCacheSize
{
    CGFloat totalSize = 0.f;
    
    NSArray *allCachePathArray = [self _getAllCachePathArray];
    
    for (NSString *cachePath in allCachePathArray) {
        totalSize += [LSFileManage getDirectorySizeAtPath:cachePath]/sizeRate;
    }
    
    CGFloat sdImageCacheSize = [[SDImageCache sharedImageCache] getSize]/sizeRate;
    totalSize += sdImageCacheSize;
    
    return totalSize;
}

/**
 清理工程中所有的缓存
 */
+ (void)clearAllDiskCache
{
    NSArray *allCachePathArray = [self _getAllCachePathArray];
    for (NSString *cachePath in allCachePathArray) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [[SDImageCache sharedImageCache] clearDisk];
    // 清空NSURLCache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/**
 迁移草稿箱存储路径，v2.7.2版本开始迁移，由 Documents 迁移到 Caches
 */
+ (void)_moveDraftPath
{
    // 迁移草稿箱文件夹位置，v2.7.2版本开始迁移
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *checkPath = [[LSFileManage getDocumentsPath] stringByAppendingPathComponent:@"drafts"];
    BOOL isDirectory = NO;
    BOOL isExists = [fileManager fileExistsAtPath:checkPath isDirectory:&isDirectory];
    if (isExists && isDirectory) {
        NSString *newPath = [[LSFileManage getCachePath] stringByAppendingPathComponent:@"drafts"];
        if ([fileManager fileExistsAtPath:newPath]) {
            [fileManager removeItemAtPath:newPath error:nil];
        }
        BOOL moveSuccess = [fileManager moveItemAtPath:checkPath toPath:newPath error:nil];
        if (!moveSuccess) {
            [fileManager removeItemAtPath:checkPath error:nil];
        }
    }
}

/**
 清空迁移存储路径时，老版本的垃圾文件 v2.7.3加入此函数
 */
+ (void)_removeRubbishFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [LSFileManage getCachePath];
    NSString *captureDir = [cachePath stringByAppendingPathComponent:@"captureDir"];
    if ([fileManager fileExistsAtPath:captureDir]) {
        [fileManager removeItemAtPath:captureDir error:nil];
    }
    [LSFileManage deleteFolderMP4SizeAtPath:cachePath];
}

/**
 检查工程图片、视频的缓存大小
 */
+ (void)_checkLocalStorage
{
    CGFloat totalSize = [self getTotalCacheSize];
    
    if (totalSize >= kMaxLocalCacheSize) {
        [self _autoClearDiskCache];
    }
}

/**
 自动清除公共磁盘缓存
 */
+ (void)_autoClearDiskCache
{
    NSArray *publicPathArray = [self _getPublicCachePathArray];
    for (NSString *cachePath in publicPathArray) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [[SDImageCache sharedImageCache] clearDisk];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/**
 获取公共缓存路径
 */
+ (NSArray *)_getPublicCachePathArray
{
    NSString *clipDir = [MDCacheFileManager cachePathWithType:CacheClipVideoTemp];
    NSString *videoCacheDir = [MDCacheFileManager cachePathWithType:CacheVideoCache];
    NSString *videoDownloadDir = [MDCacheFileManager cachePathWithType:CacheVideoDownload];
    NSString *shareBuyImageDir = [MDCacheFileManager cachePathWithType:CacheShareBuyImage];
    NSString *nsUrlCacheDir = [MDCacheFileManager cachePathWithType:CacheNSURLCache];
    return @[clipDir, videoCacheDir, videoDownloadDir, shareBuyImageDir, nsUrlCacheDir];
}

/**
 获取 非私密文件 缓存路径
 */
+ (NSArray *)_getAllCachePathArray
{
    NSMutableArray *publicCachePathArray = [[self _getPublicCachePathArray] mutableCopy];
    NSString *draftDir = [MDCacheFileManager cachePathWithType:CacheDraft];
    [publicCachePathArray addObject:draftDir];
    NSArray *allCachePathArray = [publicCachePathArray copy];
    return allCachePathArray;
}

@end
