//
//  UIImagePickerController+Permission.h
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  系统媒体权限检查

#import <UIKit/UIKit.h>

@interface UIImagePickerController (Permission)

/**
 *  1. 相册是否可用
 */
- (BOOL)isAvailablePhotoLibrary;

/**
 *  2. 相机是否可用
 */
- (BOOL)isAvailableCamera;

/**
 *  3. 是否可以保存相册
 */
- (BOOL)isAvailableSavedPhotosAlbum;

/**
 *  4. 后置摄像头是否可用
 */
- (BOOL)isAvailableCameraDeviceRear;

/**
 *  5. 前置摄像头是否可用
 */
- (BOOL)isAvailableCameraDeviceFront;

/**
 *  6. 是否支持拍照权限
 */
- (BOOL)isSupportTakingPhotos;

/**
 *  7. 是否支持获取相册视频权限
 */
- (BOOL)isSupportPickVideosFromPhotoLibrary;

/**
 *  8. 是否支持获取相册图片权限
 */
- (BOOL)isSupportPickPhotosFromPhotoLibrary;

/**
 *  配置媒体
 *
 *  @param sourceType 选择类型
 *
 *  @return UIImagePickerController
 */
+ (UIImagePickerController *)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType;


@end
