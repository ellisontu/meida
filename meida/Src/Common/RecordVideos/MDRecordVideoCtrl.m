//
//  MDRecordVideoCtrl.m
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDRecordVideoCtrl.h"
#import "LocalFileManager.h"
#import "MDRecordProgressView.h"
#import "MDVideoPlayView.h"

//video
#define RECORD_MAX_TIME     4.0           //最长录制时间
#define TIMER_INTERVAL      0.05         //计时器刷新频率

#pragma mark -  拍摄 录制视频 controller #############################################----------
@interface MDRecordVideoCtrl ()<RecordVideoViewDelegate>

@property (nonatomic, strong) MDRecordVideoView     *recordView;
@property (nonatomic, strong) MDRecordProgressView  *progressView;
@property (nonatomic, strong) MDVideoPlayView       *playerView;

@end


@implementation MDRecordVideoCtrl

- (void)dealloc
{
    XLog(@"MDRecordVideoCtrl 释放");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_recordView) {
        [self configShootView];
        // 初始化时 关闭闪光灯效果
        UIButton *button = [self.view viewWithTag:10];
        button.selected = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_recordView.session) {
        [_recordView.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (_recordView.session) {
        [_recordView.session stopRunning];
    }
    [_recordView removeFromSuperview];
    _recordView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = kDefaultBackgroundColor;
    [self configHeadView];
    [self configShootView];
    [self configControlView];
}

- (void)configHeadView
{
    
    self.navigationController.navigationBarHidden = YES;
    [self setNavigationType:NavShowBackAndTitleAndRight];
    [self setTitle:@"录制"];
    if (IS_IPHONE_4_OR_LESS) {
        [self showRigntBtn];
    }
    else {
        [self hideRightBtn];
    }
    [self setRightBtnWith:nil image:IMAGE(@"c_switch_scene")];
    
    UIButton *rightBtn = [self getRightBtn];
    rightBtn.tag = 11;
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configShootView
{
    _recordView = [[MDRecordVideoView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_WIDTH)];
    _recordView.delegate = self;
    [self.view addSubview:_recordView];
}

- (void)configControlView
{
    NSArray *imageArray = @[@"c_flash_close", @"c_switch_scene"];
    NSArray *seletImageArray = @[@"c_flash_on", @"c_switch_scene"];
    CGFloat buttonW_H = 25.f;
    CGFloat buttonY = kHeaderHeight + SCR_WIDTH + 25.f;
    CGFloat padding = (SCR_WIDTH - imageArray.count * buttonW_H) / (imageArray.count + 1);
    
    for (int i = 0; i < imageArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(padding + i * (padding + buttonW_H), buttonY, buttonW_H, buttonW_H);
        [button setImage:IMAGE(imageArray[i]) forState:UIControlStateNormal];
        [button setImage:IMAGE(seletImageArray[i]) forState:UIControlStateSelected];
        button.tag = i+10;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if ((IS_IPHONE_4_OR_LESS) && i==1) {
            button.hidden = YES;
        }
    }
    
    _progressView = [[MDRecordProgressView alloc] init];
    [self.view addSubview:_progressView];
    
    _progressView.width = 55.f;
    _progressView.height = 55.f;
    _progressView.y = (IS_IPHONE_4_OR_LESS) ? kHeaderHeight + SCR_WIDTH + 10.f : buttonY + 50.f;
    _progressView.centerX = SCR_WIDTH/2;
    UIButton *btn = [[UIButton alloc] init];
    [_progressView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progressView);
    }];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 10) {// 闪光灯
        [_recordView flashLightAction];
    }
    else if (sender.tag == 11) {// 转换摄像头
        [_recordView returnCamera];
        sender.selected = !sender.selected;
    }
    else {// 录像
        [_recordView startRecord];
    }
}

- (void)updateRecordingProgress:(CGFloat)progress
{
    [self.progressView updateProgressWithValue:progress];
}

- (void)updateRecordState:(RecordState)recordState withUrl:(NSURL *)videoUrl
{
    if (recordState == RecordStateInit) {
        //[self updateViewWithStop];
        [self.progressView resetProgress];
    } else if (recordState == RecordStateRecording) {
        //[self updateViewWithRecording];
    } else  if (recordState == RecordStateFinish) {
        if (!stringIsEmpty([videoUrl absoluteString])) {
            self.playerView.videoType = VideoPlayViewSourceTypeDocument;
            self.playerView.videoUrl = [videoUrl absoluteString];
            [self.playerView videoPlay];
            [self.playerView setIsShowBotmView:NO];
            [UIView animateWithDuration:0.02 animations:^{
                self.recordView.hidden = YES;
                self.playerView.hidden = NO;
            }];
        }
    }
}

- (MDVideoPlayView *)playerView
{
    if (!_playerView) {
        _playerView = [[MDVideoPlayView alloc] initWithFrame:_recordView.frame];
        _playerView.hidden = YES;
        [self.view addSubview:_playerView];
    }
    return _playerView;
}

@end



#pragma mark -  拍摄 录制视频 view #############################################----------

@interface MDRecordVideoView ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewlayer;  /**<  */
@property (nonatomic, strong) AVCaptureDeviceInput          *videoInput;    /**<  */
@property (nonatomic, strong) AVCaptureDeviceInput          *audioInput;    /**<  */
@property (nonatomic, strong) AVCaptureMovieFileOutput      *FileOutput;    /**<  */

@property (nonatomic, assign) FlashState                    flashState;    /**<  */
@property (nonatomic, strong) UIImageView                   *focusCursor;   /**< 聚焦光标 */
@property (nonatomic, strong, readwrite) NSURL              *videoUrl;      /**<  */
@property (nonatomic, strong) NSTimer                       *timer;         /**<  */
@property (nonatomic, assign) CGFloat                       recordTime;     /**<  */


@end


@implementation MDRecordVideoView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _session = [[AVCaptureSession alloc] init];
    
    if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {//设置分辨率
        _session.sessionPreset=AVCaptureSessionPresetHigh;
    }
    
    _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewlayer.frame = CGRectMake(0, 0, self.width, self.height);
    [self.layer addSublayer:_previewlayer];
    
    // 1.1 获取视频输入设备(摄像头)
    AVCaptureDevice *videoCaptureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    
    // 视频 HDR (高动态范围图像)
    // videoCaptureDevice.videoHDREnabled = YES;
    // 设置最大，最小帧速率
    //videoCaptureDevice.activeVideoMinFrameDuration = CMTimeMake(1, 60);
    // 1.2 创建视频输入源
    NSError *error1=nil;
    self.videoInput= [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error1];
    // 1.3 将视频输入源添加到会话
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
        
    }
    
    // 2.1 获取音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    NSError *error2=nil;
    // 2.2 创建音频输入源
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error2];
    // 2.3 将音频输入源添加到会话
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
    
    
    // 3.1初始化设备输出对象，用于获得输出数据
    self.FileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    // 3.2设置输出对象的一些属性
    AVCaptureConnection *captureConnection=[self.FileOutput connectionWithMediaType:AVMediaTypeVideo];
    //设置防抖
    //视频防抖 是在 iOS 6 和 iPhone 4S 发布时引入的功能。到了 iPhone 6，增加了更强劲和流畅的防抖模式，被称为影院级的视频防抖动。相关的 API 也有所改动 (目前为止并没有在文档中反映出来，不过可以查看头文件）。防抖并不是在捕获设备上配置的，而是在 AVCaptureConnection 上设置。由于不是所有的设备格式都支持全部的防抖模式，所以在实际应用中应事先确认具体的防抖模式是否支持：
    if ([captureConnection isVideoStabilizationSupported ]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    //预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.previewlayer connection].videoOrientation;
    
    // 3.3将设备输出添加到会话中
    if ([_session canAddOutput:_FileOutput]) {
        [_session addOutput:_FileOutput];
    }
    
    // 3.4 添加视频聚焦
    
    _focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 48.f, 48.f)];
    _focusCursor.image = [UIImage imageNamed:@"camera_focus_icon"];
    _focusCursor.alpha = 0;
    
    [self addFocus];
    
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}


//添加视频聚焦
- (void)addFocus
{
    [self addSubview:self.focusCursor];
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.previewlayer captureDevicePointOfInterestForPoint:point];
    
    self.focusCursor.center= point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
    //设置聚焦点
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}
//设置聚焦点
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

-(void)changeDeviceProperty:(void(^)(AVCaptureDevice *captureDevice))propertyChange{
    AVCaptureDevice *captureDevice= [self.videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)startRecord
{
    NSString *cacheDir = [LocalFileManager getCachePath];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![LocalFileManager isExistFileAtPath:direc]) {
        [LocalFileManager createDirectorWithFolderName:direc];
    }
    NSString *videoPath = [direc stringByAppendingString:[NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString]];
    self.videoUrl = [NSURL fileURLWithPath:videoPath];
    [self.FileOutput startRecordingToOutputFileURL:self.videoUrl recordingDelegate:self];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
      fromConnections:(NSArray *)connections
{
    self.recordState = RecordStateRecording;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(refreshTimeLabel) userInfo:nil repeats:YES];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    if ([LocalFileManager isExistFileAtPath:[self.videoUrl path]]) {
        
        self.recordState = RecordStateFinish;
        //剪裁成正方形
        //[self cutVideoWithFinished:nil];
        
    }
    
}

- (void)refreshTimeLabel
{
    _recordTime += TIMER_INTERVAL;
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateRecordingProgress:)]) {
        [self.delegate updateRecordingProgress:_recordTime/RECORD_MAX_TIME];
    }
    if (_recordTime >= RECORD_MAX_TIME) {
        [self stopRecord];
    }
}

- (void)setRecordState:(RecordState)recordState
{
    if (_recordState != recordState) {
        _recordState = recordState;
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordState:withUrl:)]) {
            [self.delegate updateRecordState:_recordState withUrl:self.videoUrl];
        }
    }
}


- (void)stopRecord
{
    [self.FileOutput stopRecording];
    [self.session stopRunning];
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  切换镜头
 */
- (void)returnCamera
{
    [self.session stopRunning];
    // 1. 获取当前摄像头
    AVCaptureDevicePosition position = self.videoInput.device.position;
    
    //2. 获取当前需要展示的摄像头
    if (position == AVCaptureDevicePositionBack) {
        position = AVCaptureDevicePositionFront;
    } else {
        position = AVCaptureDevicePositionBack;
    }
    
    // 3. 根据当前摄像头创建新的device
    AVCaptureDevice *device = [self getCameraDeviceWithPosition:position];
    
    // 4. 根据新的device创建input
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //5. 在session中切换input
    [self.session beginConfiguration];
    [self.session removeInput:self.videoInput];
    [self.session addInput:newInput];
    [self.session commitConfiguration];
    self.videoInput = newInput;
    
    [self.session startRunning];
}

/**
 *  开启闪光灯
 */
- (void)flashLightAction
{
    if(_flashState == FlashClose){
        if ([self.videoInput.device hasTorch]) {
            [self.videoInput.device lockForConfiguration:nil];
            [self.videoInput.device setTorchMode:AVCaptureTorchModeOn];
            [self.videoInput.device unlockForConfiguration];
            _flashState = FlashOpen;
        }
    }else if(_flashState == FlashOpen){
        if ([self.videoInput.device hasTorch]) {
            [self.videoInput.device lockForConfiguration:nil];
            [self.videoInput.device setTorchMode:AVCaptureTorchModeAuto];
            [self.videoInput.device unlockForConfiguration];
            _flashState = FlashAuto;
        }
    }else if(_flashState == FlashAuto){
        if ([self.videoInput.device hasTorch]) {
            [self.videoInput.device lockForConfiguration:nil];
            [self.videoInput.device setTorchMode:AVCaptureTorchModeOff];
            [self.videoInput.device unlockForConfiguration];
            _flashState = FlashClose;
        }
    };
}


@end

