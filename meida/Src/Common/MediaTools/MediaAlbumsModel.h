//
//  MediaAlbumsModel.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  相册列表模型

#import <Foundation/Foundation.h>

@interface MediaAlbumsModel : NSObject

/**
 *  相册的名称
 */
@property (nonatomic, copy, readonly, nonnull) NSString *name;

/**
 *  头图
 */
@property (nonatomic, strong, readonly, nonnull, getter=displayHeaderImage) UIImage *thumbnail;

/**
 *  照片的数量
 */
@property (nonatomic, assign, readonly) NSUInteger assetCount;

/**
 *  PHFetchResult<PHAsset>/ALAssetsGroup<ALAsset>
 */
@property (nonatomic, strong, readonly, nonnull) id fetchResult;

/**
 *  初始化MediaAlbumsModel
 *
 *  @param fetchResult PHFetchResult<PHAsset>/ALAssetsGroup<ALAsset>
 *  @param name        相册的名称
 *  @param assetCount  照片的数量
 *
 *  @return MediaAlbumsModel
 */
- (id _Nonnull)initWithFetchResult:(id _Nonnull)fetchResult
                              name:(NSString *_Nonnull)name
                        assetCount:(NSUInteger)assetCount;

@end
