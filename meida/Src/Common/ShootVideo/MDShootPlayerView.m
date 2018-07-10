//
//  MDShootPlayerView.m
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDShootPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation MDShootPlayerView
{
    AVPlayer *_player;
    BOOL _isPlaying;
}

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl{
    if (self = [super initWithFrame:frame]) {
        _autoReplay = YES;
        _videoUrl = videoUrl;
        [self setupSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)play {
    if (_isPlaying) {
        return;
    }
    [self tapAction];
}

- (void)stop {
    if (_isPlaying) {
        [self tapAction];
    }
}


- (void)setupSubViews {
    
    AVAsset *asset = [AVAsset assetWithURL:_videoUrl];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;//这里的矩阵有旋转角度，转换一下即可
        //        NSLog(@"获取路径下视频宽高  width:%f===height:%f",videoTrack.naturalSize.width,videoTrack.naturalSize.height);//宽高
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:_videoUrl];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = self.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:playerLayer];
}

- (void)tapAction {
    if (_isPlaying) {
        [_player pause];
    }
    else {
        [_player play];
    }
    _isPlaying = !_isPlaying;
}

- (void)playEnd {
    
    if (!_autoReplay) {
        return;
    }
    [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [_player play];
    }];
}

- (void)removeFromSuperview {
    [_player.currentItem cancelPendingSeeks];
    [_player.currentItem.asset cancelLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    [super removeFromSuperview];
}

- (void) enterBackground {
    [self stop];
}

- (void) enterForeground {
    [self play];
}

- (void)dealloc {
    //    NSLog(@"player dalloc");
}
@end
