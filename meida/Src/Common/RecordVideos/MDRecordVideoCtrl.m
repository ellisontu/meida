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

@end


@implementation MDRecordVideoView



@end

