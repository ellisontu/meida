//
//  MediaAlbumsModel.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MediaAlbumsModel.h"
#import "MediaResourcesManager.h"

@implementation MediaAlbumsModel

- (id _Nonnull)initWithFetchResult:(id _Nonnull)fetchResult name:(NSString * _Nonnull)name assetCount:(NSUInteger)assetCount
{
    if (self = [super init]) {
        _fetchResult = fetchResult;
        _assetCount = assetCount;
        _name = name;
    }
    
    return self;
}

- (UIImage *_Nonnull)displayHeaderImage
{
    __block UIImage *img;
    
    if ([_fetchResult isKindOfClass:[PHFetchResult class]]) {
        [[MediaResourcesManager shareInstance] fetchImageWithAsset:[_fetchResult lastObject] targetSize:kThumbnailTargetSize completion:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
            img = image;
        }];
    }
    
    return img;
}

@end
