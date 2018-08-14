//
//  MediaAssetModel.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MediaAssetModel.h"
#import "MediaResourcesManager.h"

@interface MediaAssetModel ()

@property (nonatomic, assign) BOOL                      isCloudImage;
@property (nonatomic, strong) id                        asset;
@property (nonatomic, strong) UIImage                   *originImage;
@property (nonatomic, strong) UIImage                   *previewImage;
@property (nonatomic, strong) UIImage                   *thumbnailImage;
@property (nonatomic, assign) UIImageOrientation        imageOrientation;
@property (nonatomic, strong) PHImageRequestOptions     *imageRequestOption;

@end

@implementation MediaAssetModel

- (id)initWithAsset:(id)asset
{
    if (self = [super init]) {
        _asset = asset;
    }
    
    return self;
}

- (PHImageRequestOptions *)imageRequestOption
{
    if (!_imageRequestOption) {
        _imageRequestOption = [[PHImageRequestOptions alloc] init];
        _imageRequestOption.synchronous = YES;
    }
    
    return _imageRequestOption;
}

#pragma mark - Getters

- (UIImageOrientation)imageOrientation
{
    return self.thumbnailImage.imageOrientation;
}

- (UIImage *)originImage
{
    if (!_originImage) {

        __block UIImage *resultImage = nil;
        [[MediaResourcesManager shareInstance] fetchImageWithAsset:self
                                                        targetSize:kOriginTargetSize
                                                        completion:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
                                                            resultImage = image;
                                                        }];
        _originImage = resultImage;
    }
    
    return _originImage;
}

- (UIImage *)thumbnailImage
{
    if (!_thumbnailImage) {
        
        __block UIImage *resultImage;
        [[MediaResourcesManager shareInstance] fetchImageWithAsset:self
                                                        targetSize:kThumbnailTargetSize
                                                        completion:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
                                                            resultImage = image;
                                                        }];
        _thumbnailImage = resultImage;
    }
    
    return _thumbnailImage;
}

- (UIImage *)previewImage
{
    if (!_previewImage) {
        
        __block UIImage *resultImage;
        [[MediaResourcesManager shareInstance] fetchImageWithAsset:self
                                                        targetSize:kPreviewTargetSize
                                                        completion:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
                                                            resultImage = image;
                                                        }];
        _previewImage = resultImage;
    }
    
    return _previewImage;
}

- (BOOL)isCloudImage
{
    if (self.asset.mediaType == PHAssetMediaTypeImage) {
        __block BOOL isCloudImage = NO;
        
        [[MediaResourcesManager shareInstance] fetchImageWithAsset:self
                                                        targetSize:kOriginTargetSize
                                                        completion:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
                                                            if (info) {
                                                                id isIcloud = [info objectForKey:PHImageResultIsInCloudKey];
                                                                if (isIcloud && [isIcloud boolValue]) {
                                                                    isCloudImage = YES;
                                                                }
                                                            }
                                                        }];
        
        return isCloudImage;
    }
    else {
        return NO;
    }
}


- (NSInteger)assetMediaType
{
    if ([_asset isKindOfClass:[PHAsset class]]) {
        PHAsset *typeAsset = _asset;
        return typeAsset.mediaType;
    }
    else {
        return -1;
    }
}

@end
