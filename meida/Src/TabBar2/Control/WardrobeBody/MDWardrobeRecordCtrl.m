//
//  MDWardrobeRecordCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/25.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeRecordCtrl.h"
#import "RecordVideoView.h"

@interface MDWardrobeRecordCtrl ()<RecordVideoViewDelegate>

@property (nonatomic, strong) RecordVideoView   *recordVideoView;

@end

@implementation MDWardrobeRecordCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    [self setNavigationType:NavHide];
    self.recordVideoView.viewType = TypeFullScreen;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_recordVideoView.fmodel.recordState == RecordStateFinish) {
        [_recordVideoView reset];
    }
}

- (RecordVideoView *)recordVideoView
{
    if(!_recordVideoView){
        _recordVideoView = [[RecordVideoView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT) type:TypeFullScreen];
        _recordVideoView.delegate = self;
        [self.view addSubview:_recordVideoView];
    }
    return _recordVideoView;
}

- (void)dismissVC
{
    [MDAPPDELEGATE.navigation dismissViewControllerAnimated:YES completion:nil];
}

- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl
{
    XLog(@"recordFinishWithvideoUrl === %@", videoUrl);
}

@end
