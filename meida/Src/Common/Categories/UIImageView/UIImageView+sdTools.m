//
//  UIImageView+sdTools.m
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import "UIImageView+sdTools.h"
#import <UIImageView+WebCache.h>
//#import <UIImage+WebP.h>

@implementation UIImageView (sdTools)

- (NSString *)imageURLStr
{
    NSURL *url = [self sd_imageURL];
    return [url absoluteString];
}
- (void)imageWithUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url];
}
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options];
}
- (void)imageWithUrlStr:(NSString *)urlStr completed:(SDWebImageCompletionBlock)completedBlock
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url completed:completedBlock];
}
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
}
- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:completedBlock];
}

- (void)imageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)imagePreviousCachedImageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs
{
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}

- (void)cancelCurrentImageLoad
{
    [self sd_cancelCurrentImageLoad];
}

- (void)cancelCurrentAnimationImagesLoad
{
    [self sd_cancelCurrentAnimationImagesLoad];
}
- (void)showActivityIndicatorView:(BOOL)show
{
    [self setShowActivityIndicatorView:show];
}

- (void)indicatorStyle:(UIActivityIndicatorViewStyle)style
{
    [self setIndicatorStyle:style];
}


@end
