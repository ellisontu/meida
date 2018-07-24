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
