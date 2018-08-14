//
//  MDTabBarManager.m
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTabBarManager.h"
#import "LocalFileManager.h"
#import "ZipArchive.h"
#import <UIImage+GIF.h>
#import "EncryptionMethods.h"
#import "MDCacheFileManager.h"

NSString *const kFileName = @"tabbarIcons";

@interface MDTabBarManager ()

@property (nonatomic, strong) NSString *zipUrl;         /**< zip 文件下载地址 */
@property (nonatomic, strong) NSDictionary *zipParams;
@property (nonatomic, strong) NSString *folderDirectory;
@property (nonatomic, assign, getter=isDuringActive) BOOL duringActive;

@end

@implementation MDTabBarManager

+ (MDTabBarManager *)sharedInstance
{
    static MDTabBarManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MDTabBarManager alloc] init];
        manager.zipParams = [[NSUserDefaults standardUserDefaults] objectForKey:@"tabBarCheckKey"];
        manager.zipUrl = manager.zipParams[@"zipurl"];
        manager.folderDirectory = [MDCacheFileManager cachePathWithType:CacheTabBarIcons];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:manager.folderDirectory error:NULL];
        NSInteger count = 0;
        for (NSString *fileName in contents) {
            NSString *fileNameE = [fileName pathExtension];
            if ([fileNameE isEqualToString:@"png"] || [fileNameE isEqualToString:@"jpg"] || [fileNameE isEqualToString:@"gif"]) {
                count++;
            };
        }
        manager.duringActive = count == 10;
    });
    return manager;
}

static NSArray * _getFileNameDict(NSArray *imageNameArray)
{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *folderPath = [[MDTabBarManager sharedInstance] folderDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:folderPath error:NULL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *fileName in contents) {
        NSString *fileNameH = [fileName stringByDeletingPathExtension];
        [dict setObject:fileName forKey:fileNameH];
    }
    
    for (int i = 0; i < imageNameArray.count; i++) {
        NSString *imageName = imageNameArray[i];
        NSString *imagePath = [folderPath stringByAppendingPathComponent:dict[imageName]];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        if (image) {
            [resultArray addObject:imagePath];
        }
    }
    if (resultArray.count == 5) {
        return [resultArray copy];
    }
    return nil;
}

- (NSArray *)tabbarImageNameArray
{
    NSArray *imageNameArray = nil;
    imageNameArray = @[@"tabbar_01", @"tabbar_02", @"tabbar_03", @"tabbar_04"];
    if ([MDTabBarManager sharedInstance].isDuringActive) {
        
        NSArray *resultArray = _getFileNameDict(imageNameArray);
        if (resultArray) {
            imageNameArray = resultArray;
        }
        else {
            _duringActive = NO;
        }
    }
    return imageNameArray;
}

- (NSArray *)tabbarHighLightImageArray
{
    NSArray *highLightImageArray = nil;
    highLightImageArray = @[@"tabbar_01_select",@"tabbar_02_select", @"tabbar_03_select", @"tabbar_04_select"];
    if ([MDTabBarManager sharedInstance].isDuringActive) {
        
        NSArray *resultArray = _getFileNameDict(highLightImageArray);
        if (resultArray) {
            highLightImageArray = resultArray;
        }
        else {
            _duringActive = NO;
        }
    }
    return highLightImageArray;
}

- (NSArray *)tabbarNameArray
{
    NSArray *nameArray = nil;
    nameArray = @[@"潮流", @"衣橱", @"服务", @"我的"];
    return nameArray;
}

/**
 tabbar:{
 zipurl:
 zipmd5:
 }
 */
- (void)checkIfNeedFecthImageWithZipParams:(NSDictionary *)zipParams;
{
    if (zipParams && ![zipParams isKindOfClass:[NSDictionary class]]) {
        // 清空本地文件
        [self resetTabBarCheckKey];
        return;
    }
    
    NSString *zipUrl = nil;
    if ([zipParams isKindOfClass:[NSDictionary class]]) {
        zipUrl = zipParams[@"zipurl"];
    }
    
    if ([zipUrl isEqualToString:_zipUrl] || zipUrl.hash == _zipUrl.hash) {
        // tabbarImageNameArray 和 tabbarHighLightImageArray 方法会 _duringActive = NO;
        if ([MDTabBarManager sharedInstance].isDuringActive) {
            // 只有在活动图片能获取到的时候才 return，否则继续下载
            return;
        }
        else {
            [self resetTabBarCheckKey];
        }
    }
    
    _duringActive = NO;
    
    if (stringIsEmpty(zipUrl)) {
        // 清空本地文件
        [self resetTabBarCheckKey];
        [self updateTabBarImage];
    }
    else {
        MDWeakPtr(weakPtr, self);
        [[MDNetWorking sharedClient] downloadResourceZipByUrlString:zipUrl withParameter:nil httpMethod:MethodGet callback:^(BOOL rs, NSObject *obj) {
            if (rs) {
                
                NSString *string = [[EncryptionMethods dataMD5String:(NSData *)obj] lowercaseString];
                NSString *zipMd5 = [zipParams[@"zipmd5"] lowercaseString];
                
                if (!zipMd5 || ![zipMd5 isEqualToString:string]) return ;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *contents = [fileManager contentsOfDirectoryAtPath:weakPtr.folderDirectory error:NULL];
                if (!arrayIsEmpty(contents)) {
                    // 清空本地文件
                    [LocalFileManager deleteAllFileFromFolderPath:weakPtr.folderDirectory];
                }
                NSString *filePath = [weakPtr.folderDirectory stringByAppendingPathComponent:kFileName];
                BOOL flag = [LocalFileManager saveDataToPathName:filePath WithData:[NSData dataWithData:(NSData *)obj]];
                if (flag) {
                    [[NSUserDefaults standardUserDefaults] setObject:zipParams forKey:@"tabBarCheckKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self _unzipOpenFile];
                }
                else {
                    [self updateTabBarImage];
                }
            }
            else {
                [self updateTabBarImage];
            }
        }];
    }
}

- (void)_unzipOpenFile
{
    NSString *filePath = [_folderDirectory stringByAppendingPathComponent:kFileName];
    
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    if ([zipArchive UnzipOpenFile:filePath]) {
        BOOL flag = [zipArchive UnzipFileTo:_folderDirectory overWrite:YES];
        if (flag) {
            
            DLog(@"unzip success");
            //删除压缩包(即 FOLDER_NAME 文件夹下，FILE_NAME 文件)
            [LocalFileManager deleteFileAtPath:filePath];
            _duringActive = YES;
        }
        else {
            DLog(@"unzip faile");
            // 清空本地文件
            [self resetTabBarCheckKey];
        }
        [zipArchive UnzipCloseFile];
    }
    else {// 格式不对，解压失败
        // 清空本地文件
        [self resetTabBarCheckKey];
    }
    [self updateTabBarImage];
}

- (void)updateTabBarImage
{
    if (_tabBarFetchSuccessBlock) {
        
        _tabBarFetchSuccessBlock();
    }
}

- (void)resetTabBarCheckKey
{
    [LocalFileManager deleteAllFileFromFolderPath:_folderDirectory];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"tabBarCheckKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
