//
//  UIImage+Additions.h
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

/**
 *  创建纯色的图片
 */
+(UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
/**
 *  将图片等比缩放到指定尺寸
 */
+(UIImage*)resizedImage:(UIImage*)image maxSize:(CGSize)maxSize;
/**
 *  将图片缩放到指定尺寸
 */
-(UIImage*)scaleToSize:(CGSize)size;

- (UIImage *)imageByScalingToMaxSize;


- (BOOL)saveImageToLocalPath:(NSString *)pathString;

- (CGSize)sizeImageThatFits:(CGSize)size;

- (UIImage *)fixOrientation:(UIImage *)aImage;

//截取图片 (目前针对于长图片)
- (UIImage *)clipImageInRect:(CGRect)rect;


@end
