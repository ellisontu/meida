//
//  UIImageView+sdTools.h
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  对sdwebImage 进行二次封装

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

@interface UIImageView (sdTools)


- (NSString *)imageURLStr;
- (void)imageWithUrlStr:(NSString *)urlStr;
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)imageWithUrlStr:(NSString *)urlStr completed:(SDWebImageCompletionBlock)completedBlock;
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

- (void)imagePreviousCachedImageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs;
- (void)cancelCurrentImageLoad;

- (void)cancelCurrentAnimationImagesLoad;
- (void)showActivityIndicatorView:(BOOL)show;

- (void)indicatorStyle:(UIActivityIndicatorViewStyle)style;
@end
