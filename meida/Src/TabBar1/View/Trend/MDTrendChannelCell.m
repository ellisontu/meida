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
@property (nonatomic, strong) UILabel       *titleLblView;

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
    _titleLblView = [[UILabel alloc] init];
    
    [self.contentView addSubview:_contentImgView];
    [self.contentView addSubview:_titleLblView];
    
    [_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kOffPadding);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 2 * kOffPadding, SCR_WIDTH - 2 * kOffPadding));
        make.centerX.equalTo(self.contentView);
    }];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom).offset(20.f);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(SCR_WIDTH - 30.f);
    }];
    _titleLblView.textAlignment  = NSTextAlignmentCenter;
    _titleLblView.font = FONT_SYSTEM_NORMAL(20);
    _titleLblView.textColor = kDefaultTitleColor;
    _titleLblView.text = @"霸气侧漏的星姐装束";
    _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImgView.layer.masksToBounds = YES;
    [_contentImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/2007/20077619/raw_1526134582.png" placeholderImage:IMAGE(@"place_holer_icon")];
    
}


@end
