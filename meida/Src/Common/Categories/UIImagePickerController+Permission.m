//
//  UIImagePickerController+Permission.m
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UIImagePickerController+Permission.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


@implementation UIImagePickerController (Permission)

- (BOOL)isAvailablePhotoLibrary {
    // 相册是否可用
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)isAvailableCamera {
    // 相机是否可用
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isAvailableSavedPhotosAlbum {
    // 是否可保持至相册
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (BOOL)isAvailableCameraDeviceRear {
    // 后置摄像头是否可用
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isAvailableCameraDeviceFront {
    // 前置摄像头是否可用
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)isSupportTakingPhotos {
    // 是否支持拍照
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)isSupportPickVideosFromPhotoLibrary {
    // 是否支持获取相册视频权限
    return [self isSupportsMedia:(__bridge NSString *)kUTTypeMovie
                      sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)isSupportPickPhotosFromPhotoLibrary {
    // 是否支持获取相册图片权限
    return [self isSupportsMedia:(__bridge NSString *)kUTTypeImage
                      sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

- (BOOL)isSupportsMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType
{
    __block BOOL result = NO;
    if ([mediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:mediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
    
}

+ (UIImagePickerController *)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = sourceType;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    
    return controller;
}

@end
