//
//  MDShootPhotoCtrl.m
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDShootPhotoCtrl.h"
#import "UIImage+Capture.h"
#import "MediaResourcesManager.h"

#pragma mark -  拍摄 照相机controller #############################################----------
@interface MDShootPhotoCtrl ()

@property (nonatomic, strong) MDShootPhotoView      *shootView;

@end

@implementation MDShootPhotoCtrl

- (void)dealloc
{
    XLog(@"MDShootPhotoCtrl 释放");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_shootView) {
        [self configShootView];
        // 初始化时 关闭闪光灯效果
        UIButton *button = [self.view viewWithTag:10];
        button.selected = NO;
    }
    if (_shootView) {
        [_shootView setUpCameraLayer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_shootView.session) {
        [_shootView.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (_shootView.session) {
        [_shootView.session stopRunning];
    }
    [_shootView removeFromSuperview];
    _shootView = nil;
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
    [self setTitle:@"拍摄"];
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
    _shootView = [[MDShootPhotoView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_WIDTH)];
    __weak MDShootPhotoCtrl *weakSelf = self;
    _shootView.shootPhotoBlock = ^(id img_assets) {
        
        [weakSelf gotoEditPhotoWithPhoto:img_assets];
    };
    [self.view addSubview:_shootView];
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
        [_shootView flashLightAction];
        if (!_shootView.isFront) {
            sender.selected = !sender.selected;
        }
    }
    else if (sender.tag == 11) {// 转换摄像头
        [_shootView toggleCamera];
        sender.selected = !sender.selected;
    }
    else if (sender.tag == 12){// 网格
        [_shootView gridAction];
        sender.selected = !sender.selected;
    }
    else {// 拍照
        sender.enabled = NO;
        [_shootView shutterCamera];
    }
}

- (void)gotoEditPhotoWithPhoto:(id)photo
{
    if (self.shootPhotoBlock) {
        self.shootPhotoBlock(photo);
    }
    
    [self back:nil];
}

- (void)dismiss
{
    [super back:nil];
}


@end


#pragma mark -  拍摄 照相机 view #############################################----------
@interface MDShootPhotoView ()

//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) AVCaptureDevice *captureDevice;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL flash;       /**< 是否开启闪光灯 */

@end

@implementation MDShootPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialSession];
        [self initView];
    }
    return self;
}

- (void)initialSession
{
    _flash = NO;
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    [_captureDevice lockForConfiguration:&error];
    DLog(@"error:%@",error.description);
    if ([_captureDevice isFlashModeSupported:AVCaptureFlashModeOff])
    {
        [_captureDevice setFlashMode:AVCaptureFlashModeOff];
    }
    
    [_captureDevice unlockForConfiguration];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
}

static bool isFrount;

// 这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    isFrount = YES;
    _front = isFrount;
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    isFrount = NO;
    _front = isFrount;
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

// 接下来在viewWillAppear方法里执行加载预览图层的方法
- (void)setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView *view = self;
        CALayer * viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    }
}

// 这是切换镜头的按钮方法
- (void)toggleCamera
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

// 这是拍照按钮的方法
- (void)shutterCamera
{
    
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        DLog(@"%@", [NSThread currentThread]);
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage * image = [UIImage imageWithData:imageData];
        
        CGFloat imageViewH = self.width * (image.size.height / image.size.width);
        CGFloat detalY = 0.f;
        if (IS_IPHONE_5_OR_LESS) {
            detalY = -70.f;
        }
        else if (IS_IPHONE_6 || iPhoneX){
            detalY = -81.f;
        }
        else {
            detalY = -90.f;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, detalY*(image.size.height / image.size.width), self.width, imageViewH)];
        imageView.image = image;
        [self addSubview:imageView];
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *resultImage = [UIImage captureWithView:self];
        [imageView removeFromSuperview];
        imageView = nil;
        MDWeakPtr(weakPtr, self);
        [MediaResourcesManager saveThePhotosToTheLocal:resultImage completion:^(id  _Nullable asset, BOOL success) {
            if (weakPtr.shootPhotoBlock) {
                weakPtr.shootPhotoBlock(asset);
            }
        }];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (_shootPhotoBlock) {
        _shootPhotoBlock(image);
    }
}

- (void)flashLightAction
{
    if (isFrount) {
        return;
    }
    
    if ([_captureDevice hasTorch] && [_captureDevice hasFlash]){
        
        [_captureDevice lockForConfiguration:nil];
        if (_flash) {
            //[_captureDevice setTorchMode:AVCaptureTorchModeOff];
            [_captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        else {
            //[_captureDevice setTorchMode:AVCaptureTorchModeOn];
            [_captureDevice setFlashMode:AVCaptureFlashModeOn];
        }
        _flash = !_flash;
        
        [_captureDevice unlockForConfiguration];
    }
}

- (void)gridAction
{
    _lineView.hidden = !_lineView.hidden;
}

- (void)initView
{
    self.layer.masksToBounds = YES;
    _lineView = [[UIView alloc] initWithFrame:self.bounds];
    _lineView.hidden = YES;
    [self addSubview:_lineView];
    
    CGFloat lineW_H = 1.f;
    CGFloat padding = (self.width-2*lineW_H)/3;
    // 横线
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, padding + i*(lineW_H + padding), self.width, lineW_H)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_lineView addSubview:lineView];
    }
    // 竖线
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(padding + i*(lineW_H + padding), 0, lineW_H, self.height)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_lineView addSubview:lineView];
    }
}

@end

