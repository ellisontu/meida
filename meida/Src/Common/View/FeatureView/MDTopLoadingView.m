//
//  MDTopLoadingView.m
//  meida
//
//  Created by ToTo on 2018/6/30.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTopLoadingView.h"

#define kViewHeight  (5 + kStatusBarHeight)

@interface  MDTopLoadingView()

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation MDTopLoadingView

+ (instancetype)shareInstance
{
    static MDTopLoadingView *topLoadingView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLoadingView = [[MDTopLoadingView alloc] init];
    });
    return topLoadingView;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, kViewHeight)];
        [self.window setBackgroundColor:COLOR_WITH_CLEAR];
        [self.window setWindowLevel:UIWindowLevelStatusBar];
    }
    
    return self;
}

- (void) showTopViewInViewWithtitle:(NSString *)title delayTime:(CGFloat)time
{
    if (!self.bgView) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -kViewHeight, SCR_WIDTH, kViewHeight)];
        self.bgView.backgroundColor = UIColorFromRGB(0Xffdfdf);
        
        [self.window addSubview:self.bgView];
        [self.window makeKeyAndVisible];
    }
    
    if (!self.titleLabel)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iPhoneX ? 24 : 0, SCR_WIDTH, 25)];
        self.titleLabel.text = title;
        self.titleLabel.textColor = kDefaultTitleColor;
        self.titleLabel.font = FONT_SYSTEM_NORMAL(12.0);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.bgView addSubview:self.titleLabel];
    }
    
    
    [self animationToShow:time];
}

- (void) animationToShow:(CGFloat)delayTime
{
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.bgView.frame = CGRectMake(0, 0, SCR_WIDTH, kViewHeight);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self autoFadeOut];
        }
    }];
}

- (void) autoFadeOut
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationToDismiss:delayTime:) object:nil];
    
    [self performSelector:@selector(animationToDismiss:delayTime:) withObject:nil afterDelay:0.5];
}

- (void) animationToDismiss:(BOOL)animation delayTime:(CGFloat)delayTime
{
    [UIView animateWithDuration:0.15 animations:^{
        
        CGFloat height = self.bgView.height;
        self.bgView.frame = CGRectMake(0, -height, SCR_WIDTH, height);
        
    }];
}

@end
