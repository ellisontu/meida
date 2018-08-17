//
//  MDTrendChannelCell.m
//  meida
//
//  Created by ToTo on 2018/7/20.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendChannelCell.h"

@interface MDTrendChannelCell ()

@property (nonatomic, strong) UIImageView   *contentImgView;
@property (nonatomic, strong) UILabel       *tipsLblView;
@property (nonatomic, strong) UILabel       *titleLblView;
@property (nonatomic, strong) UIButton      *praiseBtnView;

@end

@implementation MDTrendChannelCell

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
    
    _contentImgView = [[UIImageView alloc] init];
    _tipsLblView    = [[UILabel alloc] init];
    _titleLblView   = [[UILabel alloc] init];
    _praiseBtnView  = [[UIButton alloc] init];
    
    
    [self.contentView addSubview:_contentImgView];
    [self.contentView addSubview:_titleLblView];
    [self.contentView addSubview:_praiseBtnView];
    [_contentImgView addSubview:_tipsLblView];
    
    CGFloat imgWW = SCR_WIDTH - 2 * kOffPadding;
    
    [_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kOffPadding);
        make.size.mas_equalTo(CGSizeMake(imgWW, imgWW));
        make.centerX.equalTo(self.contentView);
    }];
    [_tipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42.f, 20.f));
        make.right.equalTo(self.contentImgView).offset(-7.f);
        make.top.equalTo(self.contentImgView).offset(10.f);
    }];
    [_praiseBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19.f, 19.f));
        make.centerY.equalTo(self.titleLblView);
        make.right.equalTo(self.contentImgView);
    }];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom).offset(13.f);
        make.left.equalTo(self.contentImgView);
        make.right.equalTo(self.praiseBtnView.mas_left).offset(-5.f);
    }];
    _titleLblView.font = FONT_SYSTEM_NORMAL(20);
    _titleLblView.textColor = kDefaultTitleColor;
    _titleLblView.text = @"霸气侧漏的星姐装束";
    _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImgView.layer.masksToBounds = YES;
    [_contentImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/2007/20077619/raw_1526134582.png" placeholderImage:IMAGE(@"place_holer_icon")];
    _tipsLblView.backgroundColor = COLOR_HEX_STR(@"#00C160");
    _tipsLblView.textColor = COLOR_WITH_WHITE;
    _tipsLblView.text = @"NEW";
    _tipsLblView.textAlignment = NSTextAlignmentCenter;
    _tipsLblView.font = FONT_SYSTEM_BOLD(9);
    _praiseBtnView.backgroundColor = [UIColor purpleColor];
    [_praiseBtnView addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)praiseBtnAction:(UIButton *)sender
{
    
}


@end
