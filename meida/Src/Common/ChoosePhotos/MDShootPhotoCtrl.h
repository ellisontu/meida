//
//  MDShootPhotoCtrl.h
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  拍摄 照相机controller vc & View

#import "MDBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark -  拍摄 照相机controller #############################################----------
@interface MDShootPhotoCtrl : MDBaseViewController

@property (nonatomic, copy) void (^shootPhotoBlock) (id img_assets);     /**< 拍照回调 刷新本地数据 */
@end


#pragma mark -  拍摄 照相机 view #############################################----------
@interface MDShootPhotoView : UIView

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, assign, getter=isFront) BOOL front;

@property (nonatomic, copy) void (^shootPhotoBlock)(id img_assets);

/**
 *  接下来在viewWillAppear方法里执行加载预览图层的方法
 */
- (void)setUpCameraLayer;

/**
 *  拍照
 */
- (void)shutterCamera;

/**
 *  切换镜头
 */
- (void)toggleCamera;

/**
 *  开启闪光灯
 */
- (void)flashLightAction;

/**
 *  打开网格
 */
- (void)gridAction;

@end
