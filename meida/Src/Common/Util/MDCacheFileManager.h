//
//  MDCacheFileManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MDCacheType) {
    // 用户文件
    CacheDraft,          // 草稿箱
    
    // 公共文件
    CacheClipVideoTemp,  // 视频处理中间文件
    CacheVideoCache,     // 播放视频临时缓存路径
    CacheVideoDownload,  // 完整视频缓存路径
    CacheShareBuyImage,  // 晒单图片处理文件路径
    CacheNSURLCache,      // NSURLCache文件目录，由系统去管理，禁止在本文件外部单独操作
    
    // 私密文件
    CacheTabBarIcons,    // tabbar缓存路径
    CacheWeex,           // Weex文件夹  存储在Documents文件中，防止被系统清除
    
    // 数据文件
    CacheExceptionFile,  // 储存app崩溃信息文件
};

@interface MDCacheFileManager : NSObject

/**
 获取 XX 文件夹缓存路径
 */
+ (NSString *)cachePathWithType:(MDCacheType)type;

/**
 清空 XX 文件夹缓存
 */
+ (void)clearDiskWithType:(MDCacheType)type;

/**
 清空公共的文件缓存
 */
+ (void)clearPublicDiskCache;

/**
 自动检查app存储空间，如果缓存超过最大缓存数时，自动清除公共缓存
 */
+ (void)autoReleaseLocalStorage;

/**
 获取工程所有缓存大小
 */
+ (CGFloat)getTotalCacheSize;

/**
 清理工程中所有的缓存（不包含私密文件）
 */
+ (void)clearAllDiskCache;

@end
