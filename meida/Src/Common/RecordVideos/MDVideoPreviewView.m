//
//  MDVideoPreviewView.m
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDVideoPreviewView.h"
#import "MDVideoPlayView.h"
#import "MediaResourcesManager.h"
#import "MediaAssetModel.h"

@interface MDVideoPreviewView()

@property (assign,nonatomic) id<VideoPreviewViewDelegate > delegate;

@property (nonatomic, assign) NSInteger videoIdx;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) MDVideoPlayView *videoPlayerVw;

@end

@implementation MDVideoPreviewView

+ (void) videoPreviewForAsset:(MediaAssetModel *)assetModel videoIdx:(NSInteger)videoIdx selected:(BOOL)selected delegate:(id<VideoPreviewViewDelegate>)delegate
{
    MDVideoPreviewView *vw = [MDVideoPreviewView newAutoLayoutView];
    [MDAPPDELEGATE.window addSubview:vw];
    [vw autoPinEdgesToSuperviewEdges];
    vw.videoIdx = videoIdx;
    vw.delegate = delegate;
    vw.selected = selected;
    [vw playVideo:assetModel];
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self layoutView];
    }
    return self;
}

- (void) layoutView
{
    self.backgroundColor = [UIColor blackColor];
    
//    UIView *topControlVw = [UIView newAutoLayoutView];
//    topControlVw.backgroundColor = UIColorFromRGBA(0xffffff,0.5);
//    [self addSubview:topControlVw];
//    [topControlVw autoSetDimensionsToSize:CGSizeMake(SCR_WIDTH, kHeaderHeight)];
//    [topControlVw autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [topControlVw autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//
//    UIButton *cancelBtn = [UIButton newAutoLayoutView];
//    [cancelBtn setImage:[UIImage imageNamed:@"so_back_black"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [topControlVw addSubview:cancelBtn];
//    [cancelBtn autoSetDimensionsToSize:CGSizeMake(50, 44)];
//    [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//    [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//
//    _completeBtn = [UIButton newAutoLayoutView];
//    [_completeBtn setImage:[UIImage imageNamed:@"video_unselected"] forState:UIControlStateNormal];
//    [_completeBtn setImage:[UIImage imageNamed:@"video_selected"] forState:UIControlStateSelected];
//    [_completeBtn addTarget:self action:@selector(completeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [topControlVw addSubview:_completeBtn];
//    [_completeBtn autoSetDimensionsToSize:CGSizeMake(50, 44)];
//    [_completeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
//    [_completeBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self addGestureRecognizer:doubleTapGesture];
    
    _videoPlayerVw = [MDVideoPlayView newAutoLayoutView];
    _videoPlayerVw.videoType = VideoPlayViewSourceTypeALAsset;
    [self addSubview:_videoPlayerVw];
    [_videoPlayerVw autoPinEdgesToSuperviewEdges];
    
    [self sendSubviewToBack:_videoPlayerVw];
}

- (void) setSelected:(BOOL)selected
{
    _selected = selected;
    _completeBtn.selected = selected;
}

- (void)cancelBtnTapped:(id)sender
{
    [_videoPlayerVw videoDestroy];
    [self removeFromSuperview];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)Gesture
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.01f;
        [self removeFromSuperview];
    }];
}

- (void) playVideo:(MediaAssetModel *)assetModel
{
    [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在准备视频..."];
     MDWeakPtr(weakPtr, self);
    [MediaResourcesManager fetchVideoAssetsUrl:assetModel completion:^(MediaAssetModel * _Nonnull assetModel, BOOL success) {
        
        weakPtr.videoPlayerVw.videoUrl = assetModel.assetUrl.absoluteString;
        weakPtr.videoPlayerVw.coverImage = assetModel.previewImage;
        [weakPtr.videoPlayerVw videoPlay];
        
        [Util hideLoadingVw];
    }];
}
@end
