//
//  MDVideoPlayView.m
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDVideoPlayView.h"
#import "LocalFileManager.h"
#import "MDCacheFileManager.h"

typedef NS_ENUM(NSInteger, VideoLoadStatus) {
    VideoLoadStatusUnload,
    VideoLoadStatusLoading,
    VideoLoadStatusLoaded,
};

@interface MDVideoPlayView ()
{
    CGFloat                 width;
    CGFloat                 height;
    NSString                *videoPath;             /**< 标记 当前播放的视频 */
    BOOL                    isPlaying;              /**< 标记是否正在播放 */
    BOOL                    isRemotePlaying;        /**< 标记是否为远程播放 */
    UIActivityIndicatorView *cirularProgress;
    UIImageView             *pauseImageView;        /**< 视频列表（如关注）里中心的暂停按钮 */
    NSDateFormatter         *dateFormatter;
    BOOL                    isAnimation;            /**< 标记是否在执行动画 */
}
@property (nonatomic, strong) AVPlayer       *avPlayer;
@property (nonatomic, strong) AVPlayerLayer  *playerLayer;
@property (nonatomic, strong) AVPlayerItem   *playerItem;
@property (nonatomic, strong) UIImageView    *videoImageView;       /**< 视频 imageView */
@property (nonatomic, strong) UIView         *operationView;        /**< 可隐藏的操作 view */
@property (nonatomic, strong) UIView         *bottomView;           /**< 底部黑色透明层 footer */
@property (nonatomic, strong) UIButton       *pauseBtn;             /**< 播放、暂停按钮 */
@property (nonatomic, strong) UIProgressView *bufferProgressView;   /**< 缓冲进度 ProgressView */
@property (nonatomic, strong) UISlider       *playProgressView;     /**< 播放进度 slide */
@property (nonatomic, strong) UILabel        *durationLabel;        /**< 视频总时长 label */
@property (nonatomic, strong) UIImageView    *kissImageView;        /**< 点赞 imageView */
@property (nonatomic, strong) id             playbackTimeObserver;  /**< 播放时间监听 */
@property (nonatomic, assign) VideoLoadStatus videoStatus;          /**< 标记当前视频播放器状态 */
@property (nonatomic, assign) BOOL           isDragSlide;           /**< 是否正在拖动进度条 */

- (void)videoSlierChangeValue:(UISlider *)sender;

@end

@implementation MDVideoPlayView

- (void)regsitNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidEnterBackgroundNotification
{
    DLog(@"%s 收到进入后台通知", __func__);
    [self videoPause];
}

- (void)applicationWillEnterForegroundNotification
{
    DLog(@"%s 收到进入前台通知", __func__);
    //[self monitoringPlayback:_playerItem];
    //[self setAvPlayerIsPlay:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configVideo];
    }
    return self;
}

- (void)configVideo
{
    
    self.backgroundColor = [UIColor blackColor];
    
    _videoImageView = [[UIImageView alloc] init];
    _videoImageView.image = IMAGE_LOADING;
    _videoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_videoImageView];
    _videoImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _operationView = [[UIView alloc] init];
    //_operationView.backgroundColor = RED;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_operationView addGestureRecognizer:tap];
    [self addSubview:_operationView];
    [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 50, 0));
        
    }];
    
    //底部操作栏 view
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [COLOR_WITH_BLACK colorWithAlphaComponent:0.42f];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.bottom.equalTo(self).offset(-kTabBarBottomHeight);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 50));
    }];
    
    //暂停播放按钮
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pauseBtn setImage:IMAGE(@"video_pause") forState:UIControlStateNormal];
    [_pauseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView  addSubview:_pauseBtn];
    [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.width);
        make.left.equalTo(_bottomView).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    //视频时间label
    _durationLabel = [[UILabel alloc] init];
    _durationLabel.text = @"00:00";
    _durationLabel.textColor = COLOR_WITH_WHITE;
    _durationLabel.textAlignment = NSTextAlignmentCenter;
    _durationLabel.font = FONT_SYSTEM_NORMAL(14.f);
    [_bottomView addSubview:_durationLabel];
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    //缓冲条
    _bufferProgressView = [[UIProgressView alloc] init];
    _bufferProgressView.progressTintColor = kDefaultFontColorLightGray;
    _bufferProgressView.trackTintColor = [COLOR_WITH_WHITE colorWithAlphaComponent:0.7f];
    [_bufferProgressView setProgress:0.0f animated:NO];
    //_bufferProgressView.progressImage = IMAGE(@"");
    //UIImage *trackImage = [IMAGE(@"video_buffer_progress") resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3) resizingMode:UIImageResizingModeStretch];
    //_bufferProgressView.trackImage = trackImage;
    _bufferProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_bottomView addSubview:_bufferProgressView];
    [_bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pauseBtn.mas_right).offset(15);
        make.right.equalTo(_durationLabel.mas_left).offset(-5);
        make.height.mas_equalTo(2.f);
        if (IS_IPHONE_6P) {
            make.centerY.equalTo(_bottomView.mas_centerY).offset(1.f);
        }
        else {
            make.centerY.equalTo(_bottomView.mas_centerY).offset(0.8f);
        }
    }];
    
    //播放进度条
    _playProgressView = [[UISlider alloc] init];
    _playProgressView.minimumValue = 0.f;
    _playProgressView.maximumValue = 100.f;
    _playProgressView.minimumTrackTintColor = RED;
    _playProgressView.maximumTrackTintColor = COLOR_WITH_CLEAR;
    [_playProgressView setThumbImage:IMAGE(@"video_slide_dot") forState:UIControlStateNormal];
    [_playProgressView setThumbImage:IMAGE(@"video_slide_dot") forState:UIControlStateHighlighted];
    //UIImage *minimumTrackImage = [IMAGE(@"video_slide_dot") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    //[_playProgressView setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
    _playProgressView.continuous = NO;
    _playProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_playProgressView addTarget:self action:@selector(videoSlierChangeValueStart:) forControlEvents:UIControlEventTouchDown];
    [_playProgressView addTarget:self action:@selector(videoSlierChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_bottomView addSubview:_playProgressView];
    [_playProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pauseBtn.mas_right).offset(13);
        make.right.equalTo(_durationLabel.mas_left).offset(-5);
        make.height.mas_equalTo(20.f);
        make.centerY.equalTo(_bottomView.mas_centerY);
    }];
    
    cirularProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //[cirularProgress setColor:UIColorFromRGB(0xfc3049)];
    [cirularProgress setColor:RED];
    [self addSubview:cirularProgress];
    [cirularProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    //cirularProgress.center = CGPointMake(width/2, width/2);
    //[cirularProgress startAnimating];
    
    _kissImageView = [[UIImageView alloc] initWithImage:IMAGE(@"video_kiss_zan")];
    _kissImageView.hidden = YES;
    [self addSubview:_kissImageView];
    [_kissImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    
    //_bottomView.hidden = YES;
    pauseImageView = [[UIImageView alloc] initWithImage:IMAGE(@"middle_play")];
    //pauseImageView.hidden = YES;
    [self addSubview:pauseImageView];
    [pauseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    _videoStatus = VideoLoadStatusUnload;
    
    [self videoPlayerStatusDidChange:XHCPlayerStatusUnknow];
    
    //初始化 volume and mute
    _volume = 1.f;
    _muted = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    width = self.frame.size.width;
    height = self.frame.size.height;
    //    if (_videoStatus != VideoLoadStatusUnload) {
    //        _videoImageView.image = IMAGE_LOADING;
    //    }
    _videoImageView.frame = CGRectMake((self.width - width)/2.f, 0, width, height);
    //playerLayer.frame = CGRectMake(0, 0, width, height);
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = CGRectMake(0, 0, width, height);
    //playerLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - width)/2.f, 0, width, height);
    [CATransaction commit];
}

- (void)setCoverImage:(UIImage *)coverImage
{
    _coverImage = coverImage;
    if (coverImage) {
        _videoImageView.image = coverImage;
    }
}

- (void)setCoverImageUrl:(NSString *)coverImageUrl
{
    _coverImageUrl = coverImageUrl;
    [_videoImageView imageWithUrlStr:coverImageUrl placeholderImage:IMAGE_LOADING options:SDWebImageProgressiveDownload | SDWebImageHighPriority | SDWebImageContinueInBackground | SDWebImageRetryFailed];
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender == _pauseBtn) {
        DLog(@"暂停、播放");
        isPlaying = !isPlaying;
        [self setAvPlayerIsPlay:isPlaying isEnd:NO];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    if (!isAnimation) {
        if (pauseImageView) {
            if (pauseImageView.hidden) {
                
            }
            else {
                pauseImageView.hidden = YES;
                [self setAvPlayerIsPlay:YES isEnd:NO];
            }
        }
        
        if (_bottomView.hidden) {
            [self setOperationViewisShow:YES];
        }
        else {
            [self setOperationViewisShow:NO];
        }
    }
}

- (void)autoHiddenOperationView
{
    [self performSelector:@selector(setOperationViewisShow:) withObject:nil afterDelay:10.f];
}

- (void)setOperationViewisShow:(BOOL)isShow
{
    isAnimation = YES;
    if (isShow) {
        _bottomView.hidden = NO;
        [UIView animateWithDuration:0.6f animations:^{
            _bottomView.alpha = 1.f;
        } completion:^(BOOL finished) {
            isAnimation = NO;
            [self autoHiddenOperationView];
        }];
    }
    else {
        [UIView animateWithDuration:0.6f animations:^{
            _bottomView.alpha = 0.f;
        } completion:^(BOOL finished) {
            _bottomView.hidden = YES;
            isAnimation = NO;
        }];
    }
    [self videoViewShowBottomView:isShow];
}

- (void)videoSlierChangeValueStart:(UISlider *)sender
{
    _isDragSlide = YES;
    DLog(@"UIControlEventTouchDown -----> value change start :%f", sender.value);
}

- (void)videoSlierChangeValue:(UISlider *)sender
{
    if (!_isDragSlide) {
        return;
    }
    UISlider *slider = (UISlider *)sender;
    DLog(@"UIControlEventValueChanged -----> value change:%f", slider.value);
    MDWeakPtr(weakPtr, self);
    if (slider.value <= 0.000000) {
        //__weak typeof(self) weakSelf = self;
        [_avPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            STRONGSELF;
            [strongSelf.avPlayer play];
            strongSelf.isDragSlide = NO;
        }];
    }
    else {
        AVPlayerItem *avPlayerItem = _avPlayer.currentItem;
        CMTime currentTime = avPlayerItem.currentTime;
        if (sender.value > CMTimeGetSeconds(avPlayerItem.duration)) {
            sender.value = CMTimeGetSeconds(avPlayerItem.duration);
        }
        // value:第几帧  timescale:帧率（每秒多少帧）
        //CMTimeValue timeValue = sender.value*currentTime.timescale;
        CMTime changedTime = CMTimeMakeWithSeconds(sender.value, currentTime.timescale);
        //CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
        if (isRemotePlaying) {
            [cirularProgress startAnimating];
        }
        //__weak typeof(self) weakSelf = self;
        [_avPlayer seekToTime:changedTime completionHandler:^(BOOL finished) {
            //[avPlayer play];
            STRONGSELF;
            [strongSelf -> cirularProgress stopAnimating];
            strongSelf.isDragSlide = NO;
        }];
    }
}

/*
 重置播放器为unload。移除AVPlayerItem的KVO时注意是否添加过KVO
 例如：该远程视频已经下载完成，播放的是本地视频.因此不需要移除KVO。是否添加过KVO由 isRemotePlaying 决定.
 */
- (void)resetVideo:(NSNotification *)notifaction
{
    DLog(@"resetVideo -> notifaction.name = %@", notifaction.name);
    [cirularProgress stopAnimating];
    
    if (isRemotePlaying) {
        AVPlayerItem *item = _playerLayer.player.currentItem;
        [item removeObserver:self forKeyPath:@"status"];
        [item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        //[item removeObserver:self forKeyPath:@"playbackBufferFull"];
        [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
        item = nil;
    }
    [self setAvPlayerIsPlay:NO isEnd:NO];
    [_playerLayer removeFromSuperlayer];
    _avPlayer = nil;
    _playerLayer = nil;
    _videoStatus = VideoLoadStatusUnload;
    
    self.bufferProgressView.progress = 0.f;
    self.playProgressView.value = 0.f;
    _bottomView.hidden = YES;
    isRemotePlaying = NO;
    
    pauseImageView.hidden = NO;
}

- (void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl;
    //当更换视频源的时候需要重置播放器
    if (videoUrl != videoPath && videoPath) {
        //播放新的视频,重置播放器
        [self resetVideo:nil];
    }
}

- (void)videoPlay
{
    if(![[MDNetWorking sharedClient] isConnectedViaWiFi] && ![[UserManager sharedInstance] isAutoPlay]) {
        return;
    }
    //    if (![[XHCNetWorking sharedClient] isConnectedViaWiFi]) {
    //        return;
    //    }
    pauseImageView.hidden = YES;
    _bottomView.hidden = NO;
    _bottomView.alpha = 1.f;
    
    if (stringIsEmpty(_videoUrl)) {
        [Util showMessage:@"视频地址为空" inView:self];
    }
    else {
        if (videoPath) {
            return;
        }
        if (_videoStatus == VideoLoadStatusUnload) {
            [self videoPlayerStatusDidChange:XHCPlayerStatusPreparing];
            [self downloadVideo];
        }
    }
}

- (void)videoPause
{
    if (isPlaying) {
        [self setAvPlayerIsPlay:NO isEnd:NO];
        [cirularProgress stopAnimating];
    }
}

- (void)videoResume
{
    if (!isPlaying) {
        [self setAvPlayerIsPlay:YES isEnd:NO];
    }
}

- (void)videoDestroy
{
    [self resetVideo:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_avPlayer removeTimeObserver:_playbackTimeObserver];
}

- (void)setVolume:(float)volume
{
    _volume = volume;
    if (_avPlayer) {
        _avPlayer.volume = volume;
    }
}

- (void)setMuted:(BOOL)muted
{
    _muted = muted;
    if (_avPlayer) {
        _avPlayer.muted = muted;
    }
}


#pragma mark - 下载视频与播放 -
- (void)downloadVideo
{
    //初始化下载状态
    [cirularProgress startAnimating];
    _videoStatus = VideoLoadStatusLoading;
    
    if (_videoType == VideoPlayViewSourceTypeALAsset || _videoType == VideoPlayViewSourceTypeRemote) {
        //进行下载
        NSString *videoURL = _videoUrl;
        NSString *cachedPath = [self checkIsVideoCached:videoURL];
        if (cachedPath) {
            //播放本地视频
            [self downloadVideoDoneWithURLString:videoURL filePath:cachedPath];
        }
        else {
            //[XHCCacheFileManager autoReleaseLocalStorage];
            //在线播放远程视频
            [self playRemoteVideo:videoURL];
        }
    }
    else if (_videoType == VideoPlayViewSourceTypeDocument) {
        [self playDocumentVideo];
    }
}

//设置播放器的暂停与播放
- (void)setAvPlayerIsPlay:(BOOL)isPlay isEnd:(BOOL)isEnd
{
    if (isPlay) {
        [_pauseBtn setImage:IMAGE(@"video_play") forState:UIControlStateNormal];
        if (_videoStatus == VideoLoadStatusUnload) {
            //当关闭 wifi 下自动播放时 点击播放按钮走此方法
            [self downloadVideo];
        }
        else {
            isPlaying = YES;
            [_avPlayer play];
            pauseImageView.hidden = YES;
            [self autoHiddenOperationView];
            [self videoPlayerStatusDidChange:XHCPlayerStatusPlaying];
        }
    }
    else {
        isPlaying = NO;
        [_pauseBtn setImage:IMAGE(@"video_pause") forState:UIControlStateNormal];
        [_avPlayer pause];
        if (isEnd) {
            [self videoPlayerStatusDidChange:XHCPlayerStatusStoped];
        }
        else {
            [self videoPlayerStatusDidChange:XHCPlayerStatusPaused];
        }
    }
}

//已经本地缓存，直接调用此方法
- (void)downloadVideoDoneWithURLString:(NSString *)urlString filePath:(NSString *)path
{
    if (_videoStatus == VideoLoadStatusLoading) {
        _videoStatus = VideoLoadStatusLoaded;
        [cirularProgress stopAnimating];
        if (path) {
            videoPath = path;
            [self startLocalVideoWithPath:path];
        }
        else {
            _videoStatus = VideoLoadStatusUnload;
            [_pauseBtn setImage:IMAGE(@"video_pause") forState:UIControlStateNormal];
        }
    }
}

//播放沙盒路径下的视频
- (void)playDocumentVideo
{
    if (_videoStatus == VideoLoadStatusLoading) {
        _videoStatus = VideoLoadStatusLoaded;
        [cirularProgress stopAnimating];
        videoPath = _videoUrl;
        [self startLocalVideoWithPath:videoPath];
    }
}

//初始化 _avPlayer
- (void)initAVPlayerWithVideoPath:(NSString *)path isfileURL:(BOOL)isfileURL
{
    //videoPath = path;
    AVAsset *avAsset;
    if (isfileURL) {
        avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    }
    else {
        avAsset = [AVAsset assetWithURL:[NSURL URLWithString:path]];
    }
    
    _playerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    if (!_avPlayer || _avPlayer.status == AVPlayerStatusReadyToPlay) {
        _avPlayer = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
        //_avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    else {
        [_avPlayer replaceCurrentItemWithPlayerItem:_playerItem];
        
    }
    _avPlayer.volume = _volume;
    _avPlayer.muted = _muted;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
    [_playerLayer removeFromSuperlayer];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _playerLayer.frame = CGRectMake(0, 0, _videoImageView.width, _videoImageView.height);
    //_playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.videoImageView.layer addSublayer:_playerLayer];
}

// 播放本地视频，path为本地文件路径
- (void)startLocalVideoWithPath:(NSString *)path
{
    if (_videoType == VideoPlayViewSourceTypeALAsset) {
        [self initAVPlayerWithVideoPath:path isfileURL:NO];
    }
    else if (_videoType == VideoPlayViewSourceTypeRemote) {
        //播放缓存的远程视频
        [self initAVPlayerWithVideoPath:path isfileURL:YES];
    }
    else if (_videoType == VideoPlayViewSourceTypeDocument) {
        [self initAVPlayerWithVideoPath:path isfileURL:YES];
    }
    
    //本地视频，缓冲完毕
    _bufferProgressView.progress = 1.f;
    
    if ([path isEqualToString:videoPath]) {
        [self setAvPlayerIsPlay:YES isEnd:NO];
        [self monitoringPlayback:_playerItem];
    }
}

//初始化远程视频的播放器，此方法并没有直接播放，只是做了初始化，添加了AVPLayerItem属性值的监控。播放是在检测到“status”等值变化时进行，祥见observeValueForKeyPath方法
- (void)playRemoteVideo:(NSString *)path
{
    videoPath = path;
    
    [self initAVPlayerWithVideoPath:path isfileURL:NO];
    
    isRemotePlaying = YES;
    
    [_playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
    //[_playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:0 context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:0 context:nil];
    
    //当在线播放时未开始播放视频时禁止拖动进度条 否则会 crash
    _playProgressView.userInteractionEnabled = NO;
    //暂停、播放按钮关闭交互
    _pauseBtn.userInteractionEnabled = NO;
}

-(void)setIsShowBotmView:(BOOL)isShowBotmView
{
    _bottomView.hidden = !isShowBotmView;
}

#pragma mark - NSKeyValueObserving -
/*检测到AVPlayerItem属性值的变化，依据不同状态进行播放，暂停，提示正在缓冲，更新缓冲进度等操作。
 status: (AVPlayerItemStatusReadyToPlay: 初始化完成，开始播放  AVPlayerItemStatusFailed/AVPlayerItemStatusUnknown: 初始化错误，重置播放器)
 playbackBufferEmpty: YES:缓冲区为空，提示正在缓冲  NO:缓冲区不为空，开始播放
 loadedTimeRanges: 已缓冲的时间段,更新缓冲进度
 存在的问题：断网重连后，avplayer不会继续缓冲。
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            switch(item.status) {
                case AVPlayerItemStatusFailed:
                    
                    XLog(@"player item status failed error:%@", item.error);
                    [self resetVideo:nil];
                    [self videoPlayerStatusDidChange:XHCPlayerStatusError];
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    XLog(@"player item status is ready to play");
                    _playProgressView.userInteractionEnabled = YES;
                    _pauseBtn.userInteractionEnabled = YES;
                    _videoStatus = VideoLoadStatusLoading;
                    [self setAvPlayerIsPlay:YES isEnd:NO];
                    
                    [cirularProgress stopAnimating];
                    [self monitoringPlayback:item];
                    break;
                case AVPlayerItemStatusUnknown:
                    XLog(@"player item status is unknown");
                    [self resetVideo:nil];
                    [self videoPlayerStatusDidChange:XHCPlayerStatusError];
                    break;
            }
        }
        else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
            if (item.playbackBufferEmpty) {
                XLog(@"player item playback buffer is empty");
                [_avPlayer pause];
                [cirularProgress startAnimating];
                _videoStatus = VideoLoadStatusLoading;
                isPlaying = NO;
                [self videoPlayerStatusDidChange:XHCPlayerStatusCaching];
            }
            else {
                XLog(@"player item playback buffer is not empty");
                [_avPlayer play];
                [cirularProgress stopAnimating];
                isPlaying = YES;
            }
        }
        else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSArray *loadedTimeRanges = [item loadedTimeRanges];
            Float64 bufferTime;
            if ([loadedTimeRanges count] > 0) {
                CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
                Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
                Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
                bufferTime = startSeconds + durationSeconds;
            }
            else {
                bufferTime = 0;
            }
            Float64 durationTime = CMTimeGetSeconds([item duration]);
            //float playedTime = CMTimeGetSeconds(item.currentTime);
            //XLog(@"缓冲进度 %f, 总时长%f", nearbyint(bufferTime), durationTime);
            Float64 progressTime = (nearbyint(bufferTime) / floor(durationTime));
            _bufferProgressView.progress = progressTime;
        }
    }
}


#pragma mark - 更新播放进度条和剩余播放时间 -
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    CMTime intervalTime = CMTimeMake(1, 15);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    MDWeakPtr(weakPtr, self);
    self.playbackTimeObserver = [_avPlayer addPeriodicTimeObserverForInterval:intervalTime queue:mainQueue usingBlock:^(CMTime time) {
        if (playerItem.duration.value > 0) {
            STRONGSELF;
            Float64 durationTime = CMTimeGetSeconds(playerItem.duration);
            strongSelf.playProgressView.maximumValue = durationTime;
            
            // 计算当前在第几秒
            //CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;
            Float64 currentSecond = CMTimeGetSeconds(playerItem.currentTime);
            if (!strongSelf.isDragSlide) {
                [strongSelf.playProgressView setValue:currentSecond animated:YES];
            }
            Float64 surplusTime = durationTime - currentSecond;
            NSString *timeString = [strongSelf convertTime:surplusTime];
            strongSelf.durationLabel.text = [NSString stringWithFormat:@"%@", timeString];
            //播放到 90% 发送播放结束请求记录播放结束次数
            //Float64 flag = currentSecond/durationTime;
        }
    }];
}

// 检测长视频是否已经下载完成 (放在这不太合适，是否应该由networkmananger进行管理)
- (NSString *)checkIsVideoCached:(NSString *)videoDownloadURL
{
    if (!stringIsEmpty(videoDownloadURL)) {
        NSString *md5String = [Util md5:videoDownloadURL];
        NSString *videoName = [md5String stringByAppendingString:@".mp4"];
        NSString *destPath = [[MDCacheFileManager cachePathWithType:CacheVideoCache] stringByAppendingPathComponent:videoName];
        if([[NSFileManager defaultManager] fileExistsAtPath:destPath] && [LocalFileManager getFileSizeAtPath:destPath] > 0) {
            return destPath;
        }
    }
    return nil;
}

#pragma mark - 视频播放到结尾通知 -
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *playerItem = [notification object];
    
    NSString *cachedPath = [self checkIsVideoCached:_videoUrl];
    if (([videoPath hasPrefix:@"http"] && cachedPath)) {
        if (playerItem && isRemotePlaying){
            [playerItem removeObserver:self forKeyPath:@"status"];
            [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            //[playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
            [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            isRemotePlaying = NO;
        }
        videoPath = cachedPath;
        
        [playerItem seekToTime:kCMTimeZero];
        
        [self initAVPlayerWithVideoPath:videoPath isfileURL:YES];
        
        [self monitoringPlayback:_playerItem];
        
        pauseImageView.hidden = NO;
    }
    else {
        [playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            //[_avPlayer pause];
            pauseImageView.hidden = NO;
        }];
    }
    [self setAvPlayerIsPlay:NO isEnd:YES];
}

- (NSString *)convertTime:(CGFloat)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    }
    else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:date];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

#pragma mark - XHCVideoPlayViewDelegate Methods -
- (void)videoPlayerStatusDidChange:(XHCPlayerStatus)status
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoPlayView:statusDidChange:)]) {
        [_delegate videoPlayView:self statusDidChange:status];
    }
}

- (void)videoViewShowBottomView:(BOOL)isShow
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoPlayView:showBottomView:)]) {
        [_delegate videoPlayView:self showBottomView:isShow];
    }
}

- (void)seek:(CGFloat)progress
{
    if (_avPlayer) {
        AVPlayerItem *avPlayerItem = _avPlayer.currentItem;
        CMTime currentTime = avPlayerItem.currentTime;
        CGFloat second = CMTimeGetSeconds(avPlayerItem.duration)*progress;
        [_avPlayer seekToTime:CMTimeMakeWithSeconds(second, currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}
@end
