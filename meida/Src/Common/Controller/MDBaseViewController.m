//
//  MDBaseViewController.m
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDBaseViewController.h"

@interface MDBaseViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView    *navigation;
@property (nonatomic, strong) UIButton  *backBtn;
@property (nonatomic, strong) UIButton  *leftBtn;
@property (nonatomic, strong) UIButton  *rightBtn;
@property (nonatomic, strong) UILabel   *titleLbl;
@property (nonatomic, strong) UIView    *lineview;

@property (nonatomic, strong) UIButton *backToTopBtn;
@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@end

@implementation MDBaseViewController

- (BOOL)willDealloc {
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf assertNotDealloc];
    });
    return YES;
}

- (void)assertNotDealloc {
    NSString *clasName = NSStringFromClass([self class]);
    if ([clasName isEqualToString:@"MDMineControl"])
    {
        return;
    }
    NSAssert(NO, @"断言 ---------------------> 泄漏了");
}

#pragma mark - 系统函数

- (instancetype)init
{
    if (self = [super init]) {
        DLog(@"init ViewCtrl:%@",NSStringFromClass([self class]));
    }
    return self;
}

- (void)dealloc
{
    if(self.cancelTask) {
        //取消当前关闭界面的数据请求.
        [self.cancelTask cancel];
    }
    
    DLog(@"dealloc ViewCtrl:%@",NSStringFromClass([self class]));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stack_info = [Util getCurrentStackInfo];
    
    [self layoutBaseView];
    
    [self canLeftMove];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationNetchangedStatus:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    // 全局设置 控制列表页的偏移
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
#endif
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count > 1)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.banCanLeft;
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark-滑动返回
- (void)canLeftMove
{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

#pragma mark-基类UI布局
- (void)layoutBaseView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
}

- (UIView *)navigation
{
    if (!_navigation)
    {
        _navigation = [UIView newAutoLayoutView];
        _navigation.backgroundColor = UIColorFromRGB(0xffffff);
        [self.view addSubview:_navigation];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, SCR_HEIGHT-kHeaderHeight, 0);
        [_navigation autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeBottom];
        [_navigation autoSetDimension:ALDimensionHeight toSize:kHeaderHeight];
        
        self.lineview = [UIView newAutoLayoutView];
        _lineview.backgroundColor = UIColorFromRGB(0xececee);
        [_navigation addSubview:_lineview];
        [_lineview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [_lineview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [_lineview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [_lineview autoSetDimension:ALDimensionHeight toSize:OnePixScale];
    }
    
    return _navigation;
}

- (void)addNavBackBtn
{
    if (!_backBtn)
    {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[UIImage imageNamed:@"so_back_black"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigation addSubview:_backBtn];
        
        [_backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight];
        [_backBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
    }
}

- (void)addTitle
{
    if (!_titleLbl)
    {
        _titleLbl = [UILabel newAutoLayoutView];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.numberOfLines = 1;
        _titleLbl.font = [UIFont systemFontOfSize:16.f];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.navigation addSubview:_titleLbl];
        [_titleLbl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight];
        [_titleLbl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:80];
        [_titleLbl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:80];
        [_titleLbl autoSetDimension:ALDimensionHeight toSize:44];
    }
}

- (void)addRightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorFromRGB(0xd8d8d8) forState:UIControlStateDisabled];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _rightBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [_rightBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigation addSubview:_rightBtn];
        [_rightBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_rightBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight];
        [_rightBtn autoSetDimensionsToSize:CGSizeMake(64, 44)];
    }
}


- (void)addLeftBtn
{
    if (!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColorFromRGB(0xd8d8d8) forState:UIControlStateDisabled];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _leftBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [_leftBtn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigation addSubview:_leftBtn];
        [_leftBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_leftBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight];
        [_leftBtn autoSetDimensionsToSize:CGSizeMake(64, 44)];
    }
}


#pragma mark-基类公共函数

- (void)setNavigationType:(MDNavigationType)navType
{
    switch (navType)
    {
        case NavHide:
        {
            self.navigation.hidden = YES;
        }
            break;
        case NavOnlyShowBack:
        {
            [self addNavBackBtn];
        }
            break;
        case NavShowBackAndTitle:
        {
            [self addTitle];
            [self addNavBackBtn];
        }
            break;
        case NavOnlyShowRight:
        {
            [self addRightBtn];
        }
            break;
        case NavShowTitleAndRiht:
        {
            [self addTitle];
            [self addRightBtn];
        }
            break;
        case NavOnlyShowTitle:
        {
            [self addTitle];
        }
            break;
        case NavShowBackAndTitleAndRight:
        {
            [self addNavBackBtn];
            [self addTitle];
            [self addRightBtn];
        }
            break;
        case NavCustom:
        {
            [self addLeftBtn];
            [self addTitle];
            [self addRightBtn];
        }
            break;
        default:
            break;
    }
    
}

- (UIView *) getBaseNaviagtionVw
{
    return _navigation;
}

- (UIButton *) getRightBtn
{
    return _rightBtn;
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    if (_titleLbl)
    {
        _titleLbl.text = title;
    }
}

- (void) setRightBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleSize:(CGFloat)titleSize
{
    [self setRightBtnWith:title image:nil];
    if (titleColor)
    {
        [_rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (titleSize != 0)
    {
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    }
}

- (void)setRightBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont
{
    [self setRightBtnWithTitle:title titleColor:titleColor titleSize:15.f];
    _rightBtn.titleLabel.font = titleFont;
}

- (void) setRightBtnWith:(NSString *)title image:(UIImage *)img
{
    [self addRightBtn];
    
    if (title)
    {
        [_rightBtn setTitle:title forState:UIControlStateNormal];
    }
    else if(img)
    {
        [_rightBtn setImage:img forState:UIControlStateNormal];
    }
}
- (void) setLeftBtnWith:(NSString *)title image:(UIImage *)img
{
    [self addLeftBtn];
    if (title)
    {
        [_leftBtn setTitle:title forState:UIControlStateNormal];
    }
    else if(img)
    {
        [_leftBtn setImage:img forState:UIControlStateNormal];
    }
}

-(void)setupLineView:(BOOL)show
{
    if (show)
    {
        self.lineview.hidden = NO;
    }
    else
    {
        self.lineview.hidden = YES;
    }
}

- (void) rightBtnTapped:(id)sender
{
    
}

- (void) leftBtnTapped:(id)sender
{
    
}


- (void) back:(id)sender
{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) disableLeftBtn
{
    if (_leftBtn)
    {
        _leftBtn.enabled = NO;
    }
}
- (void) enableLeftBtn
{
    if (_leftBtn)
    {
        _leftBtn.enabled = YES;
    }
}

- (void) disableRightBtn
{
    if (_rightBtn)
    {
        _rightBtn.enabled = NO;
    }
}
- (void) enableRightBtn
{
    if (_rightBtn)
    {
        _rightBtn.enabled = YES;
    }
}

#pragma mark - 上下滚动返回按钮
- (UIButton *)backToTopBtn
{
    if (!_backToTopBtn)
    {
        CGRect frame = CGRectMake(SCR_WIDTH - 60.f, SCR_HEIGHT, 38.f, 38.f);
        _backToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backToTopBtn.frame = frame;
        _backToTopBtn.hidden = YES;
        //_backToTopBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _backToTopBtn.backgroundColor = [UIColor clearColor];
        [_backToTopBtn setImage:[UIImage imageNamed:@"backToTop"] forState:UIControlStateNormal];
        [_backToTopBtn addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToTopBtn];
        
        //        [_backToTopBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        //        [_backToTopBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:60];
        //        [_backToTopBtn autoSetDimensionsToSize:CGSizeMake(30, 30)];
    }
    
    return _backToTopBtn;
}

- (void)backToTop:(id)sender
{
    if (_tableView || _collectionView) {
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [_collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    else if(_scrollView) {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    //此处逻辑有问题，当点击后不应该隐藏_backToTopBtn （若为滑到顶部也会隐藏）
    //_backToTopBtn.hidden = YES;
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isAlwaysHideBackToTopBtn) {
        if (scrollView.contentOffset.y > SCR_HEIGHT-kHeaderHeight && _isAnimation == NO) {
            self.backToTopBtn.hidden = NO;
            _isAnimation = YES;
            CGFloat offset = 26.f + 38.f + kTabBarBottomHeight;
            if (_backToTopBtn_bottomOffset > 0) {
                offset += _backToTopBtn_bottomOffset;
            }
            [UIView animateWithDuration:0.2f animations:^{
                self.backToTopBtn.y = SCR_HEIGHT - offset;
            } completion:^(BOOL finished) {
                self->_isAnimation = NO;
            }];
        }
        else if (scrollView.contentOffset.y <= SCR_HEIGHT-kHeaderHeight && _isAnimation == NO) {
            //self.backToTopBtn.hidden = YES;
            _isAnimation = YES;
            [UIView animateWithDuration:0.2f animations:^{
                self.backToTopBtn.y = SCR_HEIGHT;
            } completion:^(BOOL finished) {
                self.backToTopBtn.hidden = YES;
                self->_isAnimation = NO;
            }];
        }
    }
}

/**
 *  显示返回顶部按钮
 */
- (void)showBackToTopBtn
{
    self.backToTopBtn.hidden = NO;
    [self.view bringSubviewToFront:_backToTopBtn];
}

/**
 *  隐藏返回顶部按钮
 */
- (void)hideBackToTopBtn
{
    self.backToTopBtn.hidden = YES;
}


- (void)showRigntBtn
{
    self.rightBtn.hidden = NO;
}

- (void)hideRightBtn
{
    self.rightBtn.hidden = YES;
}

- (void) receiveNotificationNetchangedStatus:(NSNotification *)notification
{
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    [self networkReachabilityStatusDidChange:status];
}

#pragma mark --- 继承于基类的控制器 重写父类方法实现网络状态变化控制器相应的处理
- (void) networkReachabilityStatusDidChange:(AFNetworkReachabilityStatus) status
{
    
}

- (void)tabbarDoubleClick
{
    DLog(@"%@ --- %s",[self class],__func__);
}

@end
