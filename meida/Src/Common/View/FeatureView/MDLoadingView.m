//
//  MDLoadingView.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDLoadingView.h"
#import <MBProgressHUD.h>

@interface MDLoadingView()

- (void)showInView:(UIView *)view animated:(BOOL)animated;
+ (void)showHintHUD:(UIView *)view withText:(NSString *)hudText animated:(BOOL)animated dismissAfter:(double)delay;

@end

@implementation MDLoadingView
{
    UIView *_dimBgVw;
    MDLoadContainerView *_containerView;
}

+ (instancetype)shareInstance
{
    static MDLoadingView *loadingVw = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadingVw = [[MDLoadingView alloc] init];
    });
    return loadingVw;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    [self showInView:view withText:NSLocalizedString(@"Loading",@"加载中..") animated:animated];
}


- (void)showInView:(UIView *)view withText:(NSString *)text animated:(BOOL)animated {
    
    if (_dimBgVw) {
        [_dimBgVw removeFromSuperview];
        _dimBgVw = nil;
    }
    
    if (_containerView) {
        [_containerView startAnimation];
    }
    else
    {
        _containerView = [[MDLoadContainerView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        [view addSubview:_containerView];
        [_containerView addLoadingViewWithText:text];
        _containerView.loadingViewMode = NormalLoadingViewMode;
    }
    
}

- (void)multiMediaShowInView:(UIView *)view withText:(NSString *)text progress:(NSInteger)progress withloadingMode:(LoadingMode)mode
{
    
    if (_containerView) {
        [_containerView startAnimation];
    }
    else
    {
        _containerView = [[MDLoadContainerView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
        [view addSubview:_containerView];
        [_containerView addLoadingViewWithText:text];
        if (mode == ProgressLoadingMode) {
            _containerView.loadingViewMode = ProgressLoadingViewMode;
        }
        else
        {
            _containerView.loadingViewMode = NormalLoadingViewMode;
        }
    }
    
}

- (void) setLoadingProgress:(CGFloat)loadingProgress
{
    _loadingProgress = loadingProgress;
    if (_containerView) {
        _containerView.progress = _loadingProgress;
    }
}


- (void)hide:(BOOL)animated
{
    if (_dimBgVw)
    {
        [_dimBgVw removeFromSuperview];
        _dimBgVw = nil;
    }
    
    if(_containerView)
    {
        [_containerView stopAnimation];
        [_containerView removeFromSuperview];
        _containerView = nil;
    }
    self.loadingMode = NormalLoadingMode;
}

+ (void)showHintHUD:(UIView *)view withText:(NSString *)hudText animated:(BOOL)animated dismissAfter:(double)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hudText;
    [hud hideAnimated:animated afterDelay:delay];
}

@end


@interface MDLoadContainerView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *textlabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MDLoadContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = COLOR_WITH_CLEAR;
        self.angle = 0;
        [self addLoadingSubview];
    }
    return self;
}

- (void) addLoadingSubview
{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(SCR_WIDTH / 2 - 65, SCR_HEIGHT / 2 - 65, 130, 130)];
    self.backView.backgroundColor = [COLOR_WITH_BLACK colorWithAlphaComponent:0.5];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self addSubview:self.backView];
    
    self.animationView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.width / 2 - 22, 20, 44, 44)];
    [self.animationView setImage:[UIImage imageNamed:@"loading_rotate_view"]];
    [self.backView addSubview:self.animationView];
    
    self.textlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.animationView.y + 44 + 10, 120, 20)];
    self.textlabel.textColor = COLOR_WITH_WHITE;
    self.textlabel.font = FONT_SYSTEM_NORMAL(16.0);
    self.textlabel.numberOfLines = 0;
    self.textlabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.textlabel];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.textlabel.y + 30, 120, 20)];
    self.progressLabel.textColor = COLOR_WITH_WHITE;
    self.progressLabel.font = FONT_SYSTEM_NORMAL(16.0);
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.progressLabel];
}

- (void) addLoadingViewWithText:(NSString *)text
{
    NSDictionary *descAttributeDict = getAttributeDictionary(FONT_SYSTEM_NORMAL(16.f), -1);
    CGFloat descHeight =  getAttributeStringSize(text, CGSizeMake(100, MAXFLOAT), descAttributeDict).height + 5;
    self.textlabel.height = descHeight;
    
    self.progressLabel.y = self.textlabel.y + descHeight + 5;
    
    self.textlabel.text = text;
    
    [self startAnimation];
    
}

- (void)setLoadingViewMode:(LoadingViewMode)loadingViewMode
{
    _loadingViewMode = loadingViewMode;
    
    if (_loadingViewMode == ProgressLoadingViewMode) {
        self.backView.height = 20 + 44 + 10 + self.textlabel.height + 5+ 20 + 20;
    }
    else
    {
        self.backView.height = 20 + 44 + 10 + self.textlabel.height + 20;
    }
    
    
}

- (void) startAnimation
{
    if (self.isAnimating) {
        [self stopAnimation];
    }
    _isAnimating = YES;
    self.angle = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(transformAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void) transformAnimation
{
    self.angle += 5.f;
    [self startRotateAnimation];
}

- (void) startRotateAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    _animationView.transform = endAngle;
}

- (void) stopAnimation
{
    _isAnimating = NO;
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) setProgress:(CGFloat)progress
{
    _progress = progress;
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress];
}


@end
