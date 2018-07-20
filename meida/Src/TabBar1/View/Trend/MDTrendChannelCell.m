//
//  MDTrendChannelCell.m
//  meida
//
//  Created by ToTo on 2018/7/20.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendChannelCell.h"

@interface MDTrendChannelCell ()

@property (nonatomic, strong) UIView        *sepLineView;
@property (nonatomic, strong) UILabel       *titleLblView;
@property (nonatomic, strong) UILabel       *descLblView;
@property (nonatomic, strong) UIImageView   *contentImgView;
@property (nonatomic, strong) UIButton      *lookBtnView;


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
    
    _sepLineView  = [[UIView alloc] init];
    _titleLblView = [[UILabel alloc] init];
    _descLblView  = [[UILabel alloc] init];
    _contentImgView = [[UIImageView alloc] init];
    _lookBtnView  = [[UIButton alloc] init];
    
    [self.contentView addSubview:_sepLineView];
    [self.contentView addSubview:_titleLblView];
    [self.contentView addSubview:_descLblView];
    [self.contentView addSubview:_contentImgView];
    [self.contentView addSubview:_lookBtnView];
    
    MDWeakPtr(weakPtr, self);
    [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPtr.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 10.f));
        make.centerX.equalTo(weakPtr.contentView);
    }];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPtr.sepLineView.mas_bottom).offset(20.f);
        make.centerX.equalTo(weakPtr.contentView);
        make.width.mas_equalTo(SCR_WIDTH - 30.f);
    }];
    [_descLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPtr.titleLblView.mas_bottom).offset(kOffPadding);
        make.centerX.equalTo(weakPtr.contentView);
        make.width.mas_equalTo(SCR_WIDTH - 30.f);
    }];
    [_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPtr.descLblView.mas_bottom).offset(kOffPadding);
        make.centerX.equalTo(weakPtr.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, SCR_WIDTH));
    }];
    [_lookBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPtr.contentImgView.mas_bottom).offset(20.f);
        make.centerX.equalTo(weakPtr.contentView);
        make.size.mas_equalTo(CGSizeMake(100.f, 40.f));
    }];
    
    _sepLineView.backgroundColor = kDefaultBackgroundColor;
    _titleLblView.textAlignment  = NSTextAlignmentCenter;
    _titleLblView.font = FONT_SYSTEM_NORMAL(20);
    _titleLblView.textColor = kDefaultTitleColor;
    _titleLblView.text = @"霸气侧漏的星姐装束";
    _descLblView.textAlignment = NSTextAlignmentCenter;
    _descLblView.textColor = kDefaultTitleColor;
    _descLblView.font = FONT_SYSTEM_NORMAL(17);
    _descLblView.text = @"红地毯和机场的T台秀";
    _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImgView.layer.masksToBounds = YES;
    [_contentImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/2007/20077619/raw_1526134582.png" placeholderImage:IMAGE(@"place_holer_icon")];
    
    [_lookBtnView setTitle:@"去看看" forState:UIControlStateNormal];
    [_lookBtnView setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [_lookBtnView setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    
    _lookBtnView.titleEdgeInsets = UIEdgeInsetsMake(0, -_lookBtnView.imageView.bounds.size.width + 2, 0, _lookBtnView.imageView.bounds.size.width);
    _lookBtnView.imageEdgeInsets = UIEdgeInsetsMake(0, _lookBtnView.titleLabel.bounds.size.width + 15, 0, -_lookBtnView.titleLabel.bounds.size.width);
    
}


@end
