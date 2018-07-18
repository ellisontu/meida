//
//  MDLoginControl.m
//  meida
//
//  Created by ToTo on 2018/7/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDLoginControl.h"
#import "MDLoginCommonView.h"

static CGFloat duration = 0.25f;
@interface MDLoginControl ()

@property (nonatomic, strong) UIView        *mainView;       /**< 容器 */
@property (nonatomic, strong) UIImageView   *bgImgView;      /**< 背景imageview */
@property (nonatomic, strong) UIImageView   *iconImgView;    /**< app icon imageView */

@property (nonatomic, strong) UIButton      *loginBtnView;   /**< 登录 切换按钮  */
@property (nonatomic, strong) UIButton      *regisBtnView;   /**< 注册 切换按钮 */
@property (nonatomic, assign) UserClickType clickType;       /**< 标记是登录还是注册 */

@property (nonatomic, strong) MDLoginView           *loginView;     /**< 登录view */
@property (nonatomic, strong) MDRegisterView        *registerView;  /**< 注册view */
@property (nonatomic, strong) MDThirdPlatformView   *thirdPlatView; /**< 第三方登录或者注册 */

@end

@implementation MDLoginControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    self.view.backgroundColor = COLOR_WITH_WHITE;
    [self setNavigationType:NavShowBackAndTitle];
    [self setTitle:@"登录"];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight)];
    [self.view addSubview:self.mainView];
    
    _bgImgView    = [[UIImageView alloc] init];
    _iconImgView  = [[UIImageView alloc] init];
    _loginBtnView = [[UIButton alloc] init];
    _regisBtnView = [[UIButton alloc] init];
    
    _loginView     = [[MDLoginView alloc] initWithFrame:CGRectZero withMainView:_mainView];
    _registerView  = [[MDRegisterView alloc] initWithFrame:CGRectZero withMainView:_mainView];
    _thirdPlatView = [[MDThirdPlatformView alloc] init];
    
    [self.mainView addSubview:_bgImgView];
    [self.mainView addSubview:_iconImgView];
    [self.mainView addSubview:_loginBtnView];
    [self.mainView addSubview:_regisBtnView];
    [self.mainView addSubview:_loginView];
    [self.mainView addSubview:_registerView];
    [self.mainView addSubview:_thirdPlatView];

    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainView);
    }];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(65.f);
        make.size.mas_equalTo(CGSizeMake(70.f, 68.f));
        make.centerX.equalTo(self.mainView);
    }];
    
    [_loginBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 23.f));//CGSizeMake(39.f, 19.f)
        make.centerX.equalTo(self.mainView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(25.f);
    }];
    [_regisBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.f, 19.f));
        make.centerY.equalTo(self.loginBtnView);
        make.centerX.equalTo(self.mainView).offset(65.f);
    }];
    
    CGFloat padding = 80.f;
    CGFloat _viewWW = SCR_WIDTH - 2 * padding;
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_viewWW, 100.f));
        make.centerX.equalTo(self.mainView);
        make.top.equalTo(self.regisBtnView.mas_bottom).offset(kOffPadding);
    }];
    [_registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_viewWW, 100.f));
        make.centerX.equalTo(self.mainView).offset(_viewWW);
        make.top.equalTo(self.regisBtnView.mas_bottom).offset(kOffPadding);
    }];
    [_thirdPlatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView);
        make.right.equalTo(self.mainView);
        make.bottom.equalTo(self.mainView);
        make.height.mas_equalTo(75.f);
    }];
    
    _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgView.layer.masksToBounds = YES;
    
    
    [_loginBtnView setTitleColor:COLOR_HEX_STR(@"#FEEA8D") forState:UIControlStateNormal];
    _loginBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(25);
    [_loginBtnView setTitle:@"登录" forState:UIControlStateNormal];
    
    [_regisBtnView setTitleColor:COLOR_HEX_STR(@"#B4B4B4") forState:UIControlStateNormal];
    _regisBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(20);
    [_regisBtnView setTitle:@"注册" forState:UIControlStateNormal];
    
    [self.mainView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAllEidit:)]];
    
    _loginBtnView.tag = 10001;
    _regisBtnView.tag = 10002;
    [_loginBtnView addTarget:self action:@selector(switchLoginOrRegisAction:) forControlEvents:UIControlEventTouchUpInside];
    [_regisBtnView addTarget:self action:@selector(switchLoginOrRegisAction:) forControlEvents:UIControlEventTouchUpInside];
    _registerView.alpha = 0.01f;
    
    //TODO: - 测试数据
    _registerView.backgroundColor  = [UIColor purpleColor];
    _thirdPlatView.backgroundColor = kDefaultBackgroundColor;
    
}

/**
 * 点击两个 view 动画切换登录或者注册
 */
- (void)switchLoginOrRegisAction:(UIButton *)sender
{
    if (sender.tag == 10001) {
        // 登录
        _clickType = ClickTypeLogin;
    }
    else if (sender.tag == 10002){
        // 注册
        _clickType = ClickTypeRegister;
    }
    // 执行动画
    [self animationLoginViewAndRegisterView];
}

- (void)animationLoginViewAndRegisterView
{
    
    CGFloat padding = 80.f;
    CGFloat _viewWW = SCR_WIDTH - 2 * padding;
    
    if (_clickType == ClickTypeLogin) {
        // 动画切换 登录
        // 1. 更新按钮
        [self.loginBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60.f, 23.f));//CGSizeMake(39.f, 19.f)
            make.centerX.equalTo(self.mainView);
        }];
        [self.regisBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50.f, 19.f));
            make.centerX.equalTo(self.mainView).offset(65.f);
        }];
        
        // 2. 更新主体view
        [_loginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mainView);
        }];
        [_registerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mainView).offset(_viewWW);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.registerView.alpha = 0.01f;
            self.loginView.alpha = 1.f;
            [self.mainView layoutIfNeeded];
        }];
        
        [_loginBtnView setTitleColor:COLOR_HEX_STR(@"#FEEA8D") forState:UIControlStateNormal];
        _loginBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(25);
        
        [_regisBtnView setTitleColor:COLOR_HEX_STR(@"#B4B4B4") forState:UIControlStateNormal];
        _regisBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(20);

    }
    else if (_clickType == ClickTypeRegister){
        // 动画切换 注册
        // 1. 更新按钮
        [self.loginBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50.f, 19.f));
            make.centerX.equalTo(self.mainView).offset(-65.f);;
        }];
        [self.regisBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60.f, 23.f));
            make.centerX.equalTo(self.mainView);
        }];
        
        // 2. 更新其他view
        [_loginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mainView).offset(-_viewWW);
        }];
        [_registerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mainView);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.registerView.alpha = 1.f;
            self.loginView.alpha = 0.01f;
            [self.mainView layoutIfNeeded];
        }];
        
        [_loginBtnView setTitleColor:COLOR_HEX_STR(@"#B4B4B4") forState:UIControlStateNormal];
        _loginBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(20);

        [_regisBtnView setTitleColor:COLOR_HEX_STR(@"#FEEA8D") forState:UIControlStateNormal];
        _regisBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(25);
    }
}

#pragma mark - 结束所有键盘 编辑模式
- (void)cancelAllEidit:(UITapGestureRecognizer *)tapGesture
{
    [_loginView cancelAllEidit];
    [_registerView cancelAllEidit];
}

@end
