//
//  MDRecordVideoCtrl.h
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDBaseViewController.h"

#pragma mark -  拍摄 录制视频 controller #############################################----------
@interface MDRecordVideoCtrl : MDBaseViewController

@end


#pragma mark -  拍摄 录制视频 view #############################################----------
@interface MDRecordVideoView : UIView


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

