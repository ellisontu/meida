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

//闪光灯状态
typedef NS_ENUM(NSInteger, FlashState) {
    FlashClose = 0,
    FlashOpen,
    FlashAuto,
};

//录制状态
typedef NS_ENUM(NSInteger, RecordState) {
    RecordStateInit = 0,
    RecordStateRecording,
    RecordStatePause,
    RecordStateFinish,
};

@protocol RecordVideoViewDelegate <NSObject>

- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(RecordState)recordState withUrl:(NSURL *)videoUrl;
@optional
- (void)updateFlashState:(FlashState)state;

@end

@interface MDRecordVideoView : UIView


@property (nonatomic, strong, readonly) AVCaptureSession    *session;
@property (nonatomic, assign) RecordState                   recordState;
@property (nonatomic, strong, readonly) NSURL               *videoUrl;
@property (nonatomic, weak) id<RecordVideoViewDelegate>     delegate;

/**
 *  录制视频
 */
- (void)startRecord;

/**
 *  切换镜头
 */
- (void)returnCamera;

/**
 *  开启闪光灯
 */
- (void)flashLightAction;

@end

