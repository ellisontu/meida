//
//  XHCLoginManager.m
//  redlips
//
//  Created by sxj on 2017/2/23.
//  Copyright © 2017年 xiaohongchun. All rights reserved.
//

#import "XHCLoginManager.h"
#import "XHCLoginEntryView.h"

@interface XHCLoginManager ()

@property (nonatomic, strong) LoginResultBlock  loginBlock;
@property (nonatomic, strong) XHCLoginEntryView *loginEntryView;

@end

@implementation XHCLoginManager

+ (XHCLoginManager *)shareInstance;
{
    static dispatch_once_t onceToken;
    static XHCLoginManager *loginManager = nil;
    dispatch_once(&onceToken, ^{
        loginManager = [[XHCLoginManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:loginManager selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:loginManager selector:@selector(loginFailure:) name:LoginFailNotification object:nil];
    });
    
    return loginManager;
}

- (void)checkLoginStateWithLoginResult:(LoginResultBlock)completion
{
    _loginBlock = completion;
    
    if ([self checkLoginState]) {
        [self loginSuccess:nil];
    }
}

- (BOOL)checkLoginState
{
    if (LOGIN_USER) {
        return YES;
    }
    else {
        [self showLoginView];
        return NO;
    }
}

- (void)showLoginView
{
    // 弹出登录界面
    self.loginEntryView.y = 0;
    [[MDDeviceManager sharedInstance].window addSubview:_loginEntryView];
    _loginEntryView.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        _loginEntryView.y = -kLoginEntryViewSize.height;
        _loginEntryView.alpha = 1.0;
    }];
}

- (void)removeLoginView
{
    // 移除登录界面
    [_loginEntryView endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        _loginEntryView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:_loginEntryView];
        [_loginEntryView removeFromSuperview];
        _loginEntryView = nil;
    }];
}

- (void)loginSuccess:(NSNotification *)noti
{
    // 登录成功(第三方和手机号都会发)
    [self removeLoginView];
    
    if (self.loginBlock) {
        self.loginBlock(YES);
        _loginBlock = nil;
    }
}

- (void)loginFailure:(NSNotification *)noti
{
    // 登录失败回调(第三方通知)
    [self removeLoginView];
    if (self.loginBlock) {
        self.loginBlock(NO);
        _loginBlock = nil;
    }
}

- (XHCLoginEntryView *)loginEntryView
{
    if (!_loginEntryView) {
        _loginEntryView = [[XHCLoginEntryView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT + kLoginEntryViewSize.height)];
        MDWeakPtr(weakPtr, self);
        // 手机号登陆时关闭页面的回调
        _loginEntryView.loginViewCloseBlock = ^(){
            
            [weakPtr loginFailure:nil];
        };
    }
    
    return _loginEntryView;
}

@end
