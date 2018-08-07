//
//  RecordVideoView.m
//  meida
//
//  Created by ToTo on 2018/7/25.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "RecordVideoView.h"
#import "UIButton+EnlargeArea.h"

@interface RecordVideoView ()<RecordVideoModelDelegate>

@property (nonatomic, strong) UIView    *headView;
@property (nonatomic, strong) UIButton  *cancelBtn;
@property (nonatomic, strong) UIButton  *turnCamera;
@property (nonatomic, strong) UIButton  *flashBtn;
@property (nonatomic, strong) UIButton  *recordBtn;

@property (nonatomic, assign) CGFloat   recordTime;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong, readwrite) RecordVideoModel *fmodel;

@end

@implementation RecordVideoView

-(instancetype)initWithFrame:(CGRect)frame type:(VideoViewScaleType)type
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView:type];
    }
    return self;
}


#pragma mark - view
- (void)initView:(VideoViewScaleType)type
{
    
    self.fmodel = [[RecordVideoModel alloc] initWithFMVideoViewType:type superView:self];
    self.fmodel.delegate = self;
    
    //1. headview
    _headView   = [[UIView alloc] init];
    _cancelBtn  = [[UIButton alloc] init];
    _turnCamera = [[UIButton alloc] init];
    _flashBtn   = [[UIButton alloc] init];
    
    UIView *bgColor = [[UIView alloc] init];
    
    [self addSubview:_headView];
    [self addSubview:bgColor];
    [_headView addSubview:_cancelBtn];
    [_headView addSubview:_turnCamera];
    [_headView addSubview:_flashBtn];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, kHeaderHeight));
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.left.equalTo(self.headView).offset(kOffPadding);
        make.top.equalTo(self.headView).offset(kStatusBarHeight + 5);
    }];
    [_turnCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kOffPadding);
        make.size.mas_equalTo(CGSizeMake(28.f, 22.f));
        make.top.equalTo(self.cancelBtn);
    }];
    [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.right.equalTo(self.turnCamera.mas_left).offset(-kOffset);
        make.top.equalTo(self.turnCamera);
    }];
    
    _headView.backgroundColor = [UIColor clearColor];
    bgColor.backgroundColor = COLOR_HEX_STR(@"#292B2E");
    bgColor.alpha = 0.3f;
    [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_turnCamera setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
    [_turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [_turnCamera sizeToFit];
    [_flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    [_flashBtn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
    [_flashBtn sizeToFit];
    
    CGFloat edgeOffSet = 20.f;
    [_cancelBtn setEnlargeEdgeWithTop:edgeOffSet right:edgeOffSet bottom:edgeOffSet left:edgeOffSet];
    [_turnCamera setEnlargeEdgeWithTop:edgeOffSet right:edgeOffSet bottom:edgeOffSet left:edgeOffSet];
    [_flashBtn setEnlargeEdgeWithTop:edgeOffSet right:edgeOffSet bottom:edgeOffSet left:edgeOffSet];
    
    // 2. 进度条
    _progressView = [[UIProgressView alloc] init];
    _progressView.progressTintColor = COLOR_HEX_STR(@"#F8E71C");
    _progressView.trackTintColor = COLOR_HEX_STR(@"#292B2E");
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [_headView addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 5.f));
        make.centerX.equalTo(self.headView);
        make.bottom.equalTo(self.headView);
    }];
    
    //3. 拍摄按钮
    _recordBtn = [[UIButton alloc] init];
    [_recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    _recordBtn.backgroundColor = [UIColor orangeColor];
    _recordBtn.layer.cornerRadius = 60.f * 0.5;
    _recordBtn.layer.masksToBounds = YES;
    [self addSubview:_recordBtn];
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 60.f));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-100.f);
    }];
    
}

- (void)updateViewWithRecording
{
    _headView.hidden = YES;
    [self changeToRecordStyle];
}

- (void)updateViewWithStop
{
    _headView.hidden = NO;
    [self changeToStopStyle];
}

- (void)changeToRecordStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(28, 28);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 4;
        self.recordBtn.center = center;
    }];
}

- (void)changeToStopStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(52, 52);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 26;
        self.recordBtn.center = center;
    }];
}
#pragma mark - action

- (void)cancelBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelAction)]) {
        [self.delegate cancelAction];
    }
}

- (void)turnCameraAction
{
    [self.fmodel turnCameraAction];
}

- (void)flashAction
{
    [self.fmodel switchflash];
}

- (void)startRecord
{
    if (self.fmodel.recordState == RecordStateInit) {
        [self.fmodel startRecord];
    } else if (self.fmodel.recordState == RecordStateRecording) {
        [self.fmodel stopRecord];
    } else if (self.fmodel.recordState == RecordStatePause) {
        
    }
    
}

- (void)reset
{
    [self.fmodel reset];
}

#pragma mark - FMFModelDelegate

- (void)updateFlashState:(RecordFlashState)state
{
    if (state == FlashOpen) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_on"] forState:UIControlStateNormal];
    }
    if (state == FlashClose) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    }
    if (state == FlashAuto) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_auto"] forState:UIControlStateNormal];
    }
}


- (void)updateRecordState:(RecordState)recordState
{
    if (recordState == RecordStateInit) {
        [self updateViewWithStop];
        //[self.progressView resetProgress];
    } else if (recordState == RecordStateRecording) {
        [self updateViewWithRecording];
    } else if (recordState == RecordStatePause) {
        [self updateViewWithStop];
    } else  if (recordState == RecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
            [self.delegate recordFinishWithvideoUrl:self.fmodel.videoUrl];
        }
    }
}


- (void)updateRecordingProgress: (CGFloat)progress{

        self.progressView.progress = progress;
        if (self.progressView.progress == 1) {
        /*
         *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
         *动画时长0.25s，延时0.3s后开始动画
         *动画结束后将progressView隐藏
         */
        __weak typeof (self)weakSelf = self;
        [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
        } completion:^(BOOL finished) {
            weakSelf.progressView.hidden = YES;
            
        }];
    }
}

//- (void)updateRecordingProgress:(CGFloat)progress
//{
//    //[self.progressView updateProgressWithValue:progress];
//    self.timelabel.text = [self changeToVideotime:progress * RECORD_MAX_TIME];
//    [self.timelabel sizeToFit];
//}

- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    
}
@end
