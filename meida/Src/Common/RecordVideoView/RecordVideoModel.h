//
//  RecordVideoModel.h
//  meida
//
//  Created by ToTo on 2018/7/25.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

//录制视频的长宽比
typedef NS_ENUM(NSInteger, VideoViewScaleType) {
    Type1X1 = 0,
    Type4X3,
    TypeFullScreen
};

//闪光灯状态
typedef NS_ENUM(NSInteger, RecordFlashState) {
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

@protocol RecordVideoModelDelegate <NSObject>

- (void)updateFlashState:(RecordFlashState)state;
- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(RecordState)recordState;

@end

@interface RecordVideoModel : NSObject

@property (nonatomic, weak  ) id<RecordVideoModelDelegate>delegate;
@property (nonatomic, assign) RecordState recordState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;
- (instancetype)initWithFMVideoViewType:(VideoViewScaleType )type superView:(UIView *)superView;

- (void)turnCameraAction;
- (void)switchflash;
- (void)startRecord;
- (void)stopRecord;
- (void)reset;

@end
