//
//  MDRecordVideoCtrl.m
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDRecordVideoCtrl.h"
#import "MDCacheFileManager.h"

#pragma mark -  拍摄 录制视频 controller #############################################----------
@interface MDRecordVideoCtrl ()

@property (nonatomic, strong) MDRecordVideoView     *recordView;

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
    if (_recordView) {
        //[_recordView setUpCameraLayer];
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
    __weak MDRecordVideoCtrl *weakSelf = self;
    _recordView.shootPhotoBlock = ^(id img_assets) {
        
        [weakSelf gotoEditPhotoWithPhoto:img_assets];
    };
    [self.view addSubview:_recordView];
}

- (void)configControlView
{
    NSArray *imageArray = @[@"c_flash_close", @"c_switch_scene", @"c_grid_close"];
    NSArray *seletImageArray = @[@"c_flash_on", @"c_switch_scene", @"c_grid_on"];
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
    
    UIButton *shootButton = [[UIButton alloc] init];
    [shootButton setImage:IMAGE(@"c_shoot_press") forState:UIControlStateNormal];
    shootButton.width = 55.f;
    shootButton.height = 55.f;
    shootButton.y = (IS_IPHONE_4_OR_LESS) ? kHeaderHeight + SCR_WIDTH + 10.f : buttonY + 50.f;
    shootButton.centerX = SCR_WIDTH/2;
    [shootButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shootButton];
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 10) {// 闪光灯
        [_recordView flashLightAction];
        if (!_recordView.isFront) {
            sender.selected = !sender.selected;
        }
    }
    else if (sender.tag == 11) {// 转换摄像头
        [_recordView toggleCamera];
        sender.selected = !sender.selected;
    }
    else if (sender.tag == 12){// 网格
        [_recordView gridAction];
        sender.selected = !sender.selected;
    }
    else {// 拍照
        sender.enabled = NO;
        [_recordView shutterCamera];
    }
}

- (void)gotoEditPhotoWithPhoto:(id)photo
{    
    [self back:nil];
}

- (void)dismiss
{
    [super back:nil];
}


@end



#pragma mark -  拍摄 录制视频 view #############################################----------
@interface MDRecordVideoView ()

@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewlayer;  /**<  */
@property (nonatomic, strong) AVCaptureDeviceInput          *videoInput;    /**<  */
@property (nonatomic, strong) AVCaptureDeviceInput          *audioInput;    /**<  */
@property (nonatomic, strong) AVCaptureMovieFileOutput      *FileOutput;    /**<  */

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
    _previewlayer.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_WIDTH);
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
    
    //self.previewlayer.frame = self.frame;
    
}


//添加视频聚焦
//- (void)addFocus
//{
//    [self addSubview:self.focusCursor];
//    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
//    [self addGestureRecognizer:tapGesture];
//}
//
//-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
//    CGPoint point= [tapGesture locationInView:self];
//    //将UI坐标转化为摄像头坐标
//    CGPoint cameraPoint= [self.previewlayer captureDevicePointOfInterestForPoint:point];
//    [self setFocusCursorWithPoint:point];
//    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
//}


-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  接下来在viewWillAppear方法里执行加载预览图层的方法
 */
- (void)setUpCameraLayer
{
    
}

/**
 *  拍照
 */
- (void)shutterCamera
{
    
}

/**
 *  切换镜头
 */
- (void)toggleCamera
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
//    if(_flashState == FMFlashClose){
//        if ([self.videoInput.device hasTorch]) {
//            [self.videoInput.device lockForConfiguration:nil];
//            [self.videoInput.device setTorchMode:AVCaptureTorchModeOn];
//            [self.videoInput.device unlockForConfiguration];
//            _flashState = FMFlashOpen;
//        }
//    }else if(_flashState == FMFlashOpen){
//        if ([self.videoInput.device hasTorch]) {
//            [self.videoInput.device lockForConfiguration:nil];
//            [self.videoInput.device setTorchMode:AVCaptureTorchModeAuto];
//            [self.videoInput.device unlockForConfiguration];
//            _flashState = FMFlashAuto;
//        }
//    }else if(_flashState == FMFlashAuto){
//        if ([self.videoInput.device hasTorch]) {
//            [self.videoInput.device lockForConfiguration:nil];
//            [self.videoInput.device setTorchMode:AVCaptureTorchModeOff];
//            [self.videoInput.device unlockForConfiguration];
//            _flashState = FMFlashClose;
//        }
//    };
//    if (self.delegate && [self.delegate respondsToSelector:@selector(updateFlashState:)]) {
//        [self.delegate updateFlashState:_flashState];
//    }
}

/**
 *  打开网格
 */
- (void)gridAction
{
    
}

@end

