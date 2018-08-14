//
//  UploadNewDetailScrollView.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UploadNewDetailScrollView.h"
#import "CustomPageControl.h"

@interface UploadNewDetailScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) CustomPageControl *pageControl;
@property (nonatomic, assign) NSInteger         currentPage;
@property (nonatomic, strong) NSString          *coverImageUrl;

@end

@implementation UploadNewDetailScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame
{
    self.backgroundColor = COLOR_WITH_WHITE;
    
    //1. scorll view
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    //_scrollView.backgroundColor = [UIColor greenColor];
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //2. pageControl
    _pageControl = [[CustomPageControl alloc] initWithFrame:CGRectZero currentImage:IMAGE(@"dot_icon_red") defaultImage:IMAGE(@"dot_icon_gray")];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 10));
        make.bottom.equalTo(self).offset(-kOffPadding);
    }];
    
    //3. 分割线
    UIView  *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 1.f));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
    lineView.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentPage = (NSInteger)(scrollView.contentOffset.x / self.width + 0.5) + 1;
    _pageControl.currentPage = _currentPage - 1;
}

- (void)setPicsArr:(NSArray *)picsArr
{
    if (arrayIsEmpty(picsArr)) return;
    _picsArr = picsArr;
    
    _scrollView.contentSize = CGSizeMake(_picsArr.count * self.bounds.size.width, self.bounds.size.height);
    _scrollView.backgroundColor = COLOR_WITH_WHITE;
    
    if (!_currentPage)
    {
        _currentPage = 0;
    }
    
    _pageControl.hidden = _picsArr.count <= 1 ? YES : NO;
    _pageControl.numberOfPages = _picsArr.count;
    
    for (int i = 0; i < _picsArr.count; ++i ) {
        _coverImageUrl = _picsArr[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.width, 0, _scrollView.width, _scrollView.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView imageWithUrlStr:_picsArr[i] placeholderImage:IMAGE_LOADING];
        [_scrollView addSubview:imageView];
    }
    
}

@end



@interface UploadNewDetailBottomView ()

@end

@implementation UploadNewDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = COLOR_WITH_WHITE;
    
    UIButton *consultBtn   = [[UIButton alloc] init];
    UIButton *callChiefBtn = [[UIButton alloc] init];
    
    [self addSubview:consultBtn];
    [self addSubview:callChiefBtn];
    
    [consultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.height.equalTo(self);
        make.right.equalTo(callChiefBtn.mas_left);
    }];
    [callChiefBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(consultBtn);
    }];
    
    [consultBtn setBackgroundColor:COLOR_HEX_STR(@"#FEEA8D")];
    [consultBtn setImage:IMAGE(@"consult_icon") forState:UIControlStateNormal];
    [consultBtn setTitle:@"  咨询服搭师" forState:UIControlStateNormal];
    [consultBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    consultBtn.titleLabel.font = FONT_SYSTEM_NORMAL(17);
    
    [callChiefBtn setBackgroundColor:COLOR_HEX_STR(@"#3E84E0")];
    [callChiefBtn setImage:IMAGE(@"call_chief_icon") forState:UIControlStateNormal];
    [callChiefBtn setTitle:@"  对话店长" forState:UIControlStateNormal];
    [callChiefBtn setTitleColor:COLOR_WITH_WHITE forState:UIControlStateNormal];
    callChiefBtn.titleLabel.font = FONT_SYSTEM_NORMAL(17);
    
}

@end
