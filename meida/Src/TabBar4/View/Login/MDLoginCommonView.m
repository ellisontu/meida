//
//  MDLoginCommonView.m
//  meida
//
//  Created by ToTo on 2018/7/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDLoginCommonView.h"

#pragma mark - 登录 view ############ -------------------
@interface MDLoginView ()

@property (nonatomic, strong) UITextField   *phoneTextField;    /**<  */
@property (nonatomic, strong) UIView        *phoneTextLine;     /**<  */
@property (nonatomic, strong) UITextField   *pwordTextField;    /**<  */
@property (nonatomic, strong) UIView        *pwordTextLine;     /**<  */
@property (nonatomic, strong) UIButton      *forgotBtnView;     /**<  */
@property (nonatomic, strong) UIButton      *loginBtnView;      /**<  */

@property (nonatomic, weak) UIView          *mainView;


@end

@implementation MDLoginView

- (instancetype)initWithFrame:(CGRect)frame withMainView:(UIView *)mainView
{
    if (self = [super initWithFrame:frame]) {
        
        self.mainView = mainView;
        
        [self initView];
    }
    return self;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextLine  = [[UIView alloc] init];
    _pwordTextField = [[UITextField alloc] init];
    _pwordTextLine  = [[UIView alloc] init];
    _forgotBtnView  = [[UIButton alloc] init];
    _loginBtnView   = [[UIButton alloc] init];
    
    [self addSubview:_phoneTextField];
    [self addSubview:_phoneTextLine];
    [self addSubview:_pwordTextField];
    [self addSubview:_pwordTextLine];
    [self addSubview:_forgotBtnView];
    [self addSubview:_loginBtnView];
    

    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.top.equalTo(self).offset(kOffPadding);
        make.height.mas_equalTo(25.f);
    }];
    [_phoneTextLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(5.f);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(OnePixScale);
    }];
    [_pwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.top.equalTo(self.phoneTextLine.mas_bottom).offset(kOffPadding);
        make.height.mas_equalTo(25.f);
    }];
    [_pwordTextLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwordTextField.mas_bottom).offset(5.f);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(OnePixScale);
    }];
    [_forgotBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwordTextField.mas_bottom).offset(kOffPadding);
        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
        make.centerX.equalTo(self.pwordTextLine);
    }];
    [_loginBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kOffPadding);
        make.right.equalTo(self).offset(-kOffPadding);
        make.top.equalTo(self.forgotBtnView).offset(25.f);
        make.height.mas_equalTo(40.f);
    }];
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentCenter;
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"用户名" attributes:
                                      @{NSForegroundColorAttributeName:COLOR_HEX_STR(@"#FEEA8D"),
                                        NSFontAttributeName:FONT_SYSTEM_NORMAL(20),
                                        NSParagraphStyleAttributeName:style1
                                        }];
    _phoneTextField.attributedPlaceholder = attrString1;
    _phoneTextLine.backgroundColor = COLOR_HEX_STR(@"#DEDEDE");
    
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.alignment = NSTextAlignmentCenter;
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"密码" attributes:
                                      @{NSForegroundColorAttributeName:COLOR_HEX_STR(@"#FEEA8D"),
                                        NSFontAttributeName:FONT_SYSTEM_NORMAL(20),
                                        NSParagraphStyleAttributeName:style2
                                        }];
    _pwordTextField.attributedPlaceholder = attrString2;
    _pwordTextLine.backgroundColor = COLOR_HEX_STR(@"#DEDEDE");
    
    [_forgotBtnView setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgotBtnView setTitleColor:COLOR_HEX_STR(@"#B4B4B4") forState:UIControlStateNormal];
    _forgotBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    _loginBtnView.layer.cornerRadius  = 40.f * 0.5;
    _loginBtnView.layer.masksToBounds = YES;
    _loginBtnView.layer.borderColor   = COLOR_HEX_STR(@"#FEEA8D").CGColor;
    _loginBtnView.layer.borderWidth   = OnePixScale;
    [_loginBtnView setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(15);
    [_loginBtnView setTitleColor:COLOR_HEX_STR(@"#FEEA8D") forState:UIControlStateNormal];
    [_loginBtnView addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneTextField.tag = 10001;
    _pwordTextField.tag = 10002;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    [_pwordTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    
}

- (void)textFieldChange:(UITextField *)textField
{
    if (textField.tag == 10001) {
        // main
        //XLog(@"main： ==== %@", textField.text);
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    else if (textField.tag == 10002){
        // 密码
        //XLog(@"密码： ==== %@", textField.text);
    }
}

- (void)loginBtnAction:(UIButton *)sender
{
    if (![Util isPhoneNumber:_phoneTextField.text]) {
        [Util showMessage:@"请输入正确的手机号" inView:MDAPPDELEGATE.window];
        return;
    }
    if (stringIsEmpty(_pwordTextField.text)) {
        [Util showMessage:@"请输入密码" inView:MDAPPDELEGATE.window];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTextField.text forKey:@"phone"];
    [params setObject:_pwordTextField.text forKey:@"password"];
    
    [[MDNetWorking sharedClient] requestWithPath:URL_POST_USER_LOGIN params:params httpMethod:MethodPost callback:^(BOOL rs, NSObject *obj) {
        if (rs) {
            
        }
        else{
            [Util showErrorMessage:obj forDuration:1.f];
        }
    }];
}

- (void)cancelAllEidit
{
    [_phoneTextField endEditing:YES];
    [_pwordTextField endEditing:YES];
}

- (void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self layoutIfNeeded];
    
    if ([notification.name isEqual:UIKeyboardWillHideNotification]) {
        self.mainView.y = kHeaderHeight;
    }
    else {
        self.mainView.y = -kHeaderHeight;
    }
    
    [UIView commitAnimations];
}


@end

#pragma mark - 注册 view ############ -------------------
@interface MDRegisterView ()

@property (nonatomic, strong) UILabel       *phoneTipsLbl;
@property (nonatomic, strong) UITextField   *phoneTextField;    /**<  */
@property (nonatomic, strong) UIView        *phoneTextLine;
@property (nonatomic, strong) UILabel       *pCodeTipsLbl;
@property (nonatomic, strong) UITextField   *pCodeTextField;    /**<  */
@property (nonatomic, strong) UIView        *pCodeTextLine;     /**<  */
@property (nonatomic, strong) UIButton      *pCodeRecivBtn;
@property (nonatomic, strong) UILabel       *pwordTipsLbl;
@property (nonatomic, strong) UITextField   *pwordTextField;
@property (nonatomic, strong) UIView        *pwordTextLine;
@property (nonatomic, strong) UIButton      *registerBtn;
@property (nonatomic, weak) UIView          *mainView;

@end

@implementation MDRegisterView

- (instancetype)initWithFrame:(CGRect)frame withMainView:(UIView *)mainView
{
    if (self = [super initWithFrame:frame]) {
        
        self.mainView = mainView;
        
        [self initView];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    
    _phoneTipsLbl   = [[UILabel alloc] init];
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextLine  = [[UIView alloc] init];
    _pCodeTextField = [[UITextField alloc] init];
    _pCodeTipsLbl   = [[UILabel alloc] init];
    _pCodeTextLine  = [[UIView alloc] init];
    _pCodeRecivBtn  = [[UIButton alloc] init];
    _pwordTipsLbl   = [[UILabel alloc] init];
    _pwordTextField = [[UITextField alloc] init];
    _pwordTextLine  = [[UIView alloc] init];
    _registerBtn    = [[UIButton alloc] init];
    
    [self addSubview:_phoneTipsLbl];
    [self addSubview:_phoneTextField];
    [self addSubview:_phoneTextLine];
    [self addSubview:_pCodeTipsLbl];
    [self addSubview:_pCodeTextField];
    [self addSubview:_pCodeTextLine];
    [self addSubview:_pCodeRecivBtn];
    [self addSubview:_pwordTipsLbl];
    [self addSubview:_pwordTextField];
    [self addSubview:_pwordTextLine];
    [self addSubview:_registerBtn];
    
    CGFloat tipsWW = 70.f;
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kOffPadding);
        make.right.equalTo(self.phoneTextLine);
        make.height.mas_equalTo(25.f);
        make.left.equalTo(self.phoneTextLine).offset(tipsWW);
    }];
    [_phoneTextLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(OnePixScale);
    }];
    [_phoneTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTextField);
        make.left.equalTo(self.phoneTextLine);
    }];
    
    [_pCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextLine.mas_bottom).offset(kOffPadding);
        make.right.equalTo(self.pCodeTextLine);
        make.height.mas_equalTo(25.f);
        make.left.equalTo(self.pCodeTextLine).offset(tipsWW);
    }];
    [_pCodeRecivBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pCodeTextField).offset(10);
        make.centerY.equalTo(self.pCodeTextField);
        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
    }];
    [_pCodeTextLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pCodeTextField.mas_bottom);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(OnePixScale);
    }];
    [_pCodeTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pCodeTextField);
        make.left.equalTo(self.pCodeTextLine);
    }];
    [_pwordTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pCodeTipsLbl);
        make.centerY.equalTo(self.pwordTextField);
    }];
    [_pwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.pCodeTextField);
        make.centerX.equalTo(self.pCodeTextField);
        make.top.equalTo(self.pCodeTipsLbl.mas_bottom).offset(kOffset);
    }];
    [_pwordTextLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwordTextField.mas_bottom);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(OnePixScale);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kOffPadding);
        make.right.equalTo(self).offset(-kOffPadding);
        make.top.equalTo(self.pwordTextLine).offset(25.f);
        make.height.mas_equalTo(40.f);
    }];
    
//    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
//    style1.alignment = NSTextAlignmentCenter;
//    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"用户名" attributes:
//                                       @{NSForegroundColorAttributeName:COLOR_HEX_STR(@"#FEEA8D"),
//                                         NSFontAttributeName:FONT_SYSTEM_NORMAL(20),
//                                         NSParagraphStyleAttributeName:style1
//                                         }];
//    _phoneTextField.attributedPlaceholder = attrString1;
//
//    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
//    style2.alignment = NSTextAlignmentCenter;
//    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"验证码" attributes:
//                                       @{NSForegroundColorAttributeName:COLOR_HEX_STR(@"#FEEA8D"),
//                                         NSFontAttributeName:FONT_SYSTEM_NORMAL(20),
//                                         NSParagraphStyleAttributeName:style2
//                                         }];
//    _pCodeTextField.attributedPlaceholder = attrString2;
    
    _phoneTipsLbl.font = FONT_SYSTEM_NORMAL(20);
    _phoneTipsLbl.textColor = COLOR_HEX_STR(@"#FEEA8D");
    _phoneTipsLbl.text = @"手机号";
    _pCodeTipsLbl.font = FONT_SYSTEM_NORMAL(20);
    _pCodeTipsLbl.textColor = COLOR_HEX_STR(@"#FEEA8D");
    _pCodeTipsLbl.text = @"验证码";
    _pwordTipsLbl.font = FONT_SYSTEM_NORMAL(20);
    _pwordTipsLbl.textColor = COLOR_HEX_STR(@"#FEEA8D");
    _pwordTipsLbl.text = @"密码";
    
    _phoneTextLine.backgroundColor = COLOR_HEX_STR(@"#DEDEDE");
    _pCodeTextLine.backgroundColor = COLOR_HEX_STR(@"#DEDEDE");
    _pwordTextLine.backgroundColor = COLOR_HEX_STR(@"#DEDEDE");
    
    _registerBtn.layer.cornerRadius  = 40.f * 0.5;
    _registerBtn.layer.masksToBounds = YES;
    _registerBtn.layer.borderColor   = COLOR_HEX_STR(@"#FEEA8D").CGColor;
    _registerBtn.layer.borderWidth   = OnePixScale;
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = FONT_SYSTEM_NORMAL(15);
    [_registerBtn setTitleColor:COLOR_HEX_STR(@"#FEEA8D") forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pCodeRecivBtn setTitle:@"验证码" forState:UIControlStateNormal];
    _phoneTextField.tag = 10001;
    _pCodeTextField.tag = 10002;
    _pwordTextField.tag = 10003;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _pCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _pwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    [_pCodeTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    [_pwordTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
    
}

- (void)textFieldChange:(UITextField *)textField
{
    if (textField.tag == 10001) {
        // 手机号
        //XLog(@"手机号： ==== %@", textField.text);
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    else if (textField.tag == 10002){
        // 验证码
        //XLog(@"验证码： ==== %@", textField.text);
    }
    else if (_pwordTextField.tag == 10003){
        //XLog(@"密码： ==== %@", textField.text);
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (void)registerBtnAction:(UIButton *)sender
{
    
    if (![Util isPhoneNumber:_phoneTextField.text]) {
        [Util showMessage:@"请输入正确的手机号" inView:MDAPPDELEGATE.window];
        return;
    }
    if (stringIsEmpty(_pCodeTextField.text)) {
        [Util showMessage:@"请输入验证码" inView:MDAPPDELEGATE.window];
        return;
    }
    if (stringIsEmpty(_pwordTextField.text)) {
        [Util showMessage:@"请输入密码" inView:MDAPPDELEGATE.window];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTextField.text forKey:@"phone"];
    [params setObject:_pCodeTextField.text forKey:@"phoneCode"];
    [params setObject:_pwordTextField.text forKey:@"password"];
    [[MDNetWorking sharedClient] requestWithPath:URL_POST_USER_REGISTER params:params httpMethod:MethodPost callback:^(BOOL rs, NSObject *obj) {
        if (rs) {
            
        }
        else{
            [Util showErrorMessage:obj forDuration:1.f];
        }
    }];
    
}

- (void)cancelAllEidit
{
    [_phoneTextField endEditing:YES];
    [_pCodeTextField endEditing:YES];
    [_pwordTextField endEditing:YES];
}

- (void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self layoutIfNeeded];
    
    if ([notification.name isEqual:UIKeyboardWillHideNotification]) {
        self.mainView.y = kHeaderHeight;
    }
    else {
        self.mainView.y = -kHeaderHeight;
    }
    
    [UIView commitAnimations];
}

@end

#pragma mark - 第三方登录或注册 view ############ -------------------
@interface MDThirdPlatformView ()

@property (nonatomic, strong) UIImageView   *seplineView;
@property (nonatomic, strong) UIView        *containerView;
@property (nonatomic, assign) LoginPlatform paltformType;


@end

@implementation MDThirdPlatformView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    _seplineView   = [[UIImageView alloc] init];
    _containerView = [[UIView alloc] init];
    
    [self addSubview:_seplineView];
    [self addSubview:_containerView];
    
    [_seplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(20.f);
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seplineView.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    _seplineView.contentMode = UIViewContentModeScaleAspectFill;
    _seplineView.layer.masksToBounds = YES;
    _containerView.backgroundColor = [UIColor clearColor];
    
    CGFloat btnWW = 26.f;
    CGFloat padding = (SCR_WIDTH - 3 * btnWW) / 4;
    for (int i = 0; i < 3; ++i) {
        UIButton *btn = [[UIButton alloc] init];
        [_containerView addSubview:btn];
        btn.tag = 10000 + i;
        btn.backgroundColor = [UIColor orangeColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWW, btnWW));
            make.centerY.equalTo(self.containerView);
            make.left.equalTo(self.containerView).offset(padding + padding * i + btnWW * i);
        }];
        [btn addTarget:self action:@selector(thirdPlatformBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

- (void)thirdPlatformBtnAction:(UIButton *)sender
{
    if (sender.tag == 10000) {
        // 微信
        _paltformType = LoginPlatformWechat;
    }
    else if (sender.tag == 10001){
        // QQ
        _paltformType = LoginPlatformQQ;
    }
    else if (sender.tag == 10002){
        // 新浪
        _paltformType = LoginPlatformSina;
    }
    
    if (_thirdPlatformBlock) {
        _thirdPlatformBlock(_paltformType);
    }
}

@end
