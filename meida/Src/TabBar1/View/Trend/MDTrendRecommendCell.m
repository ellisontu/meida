//
//  MDTrendRecommendCell.m
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendRecommendCell.h"

@interface MDTrendRecommendCell ()

@property (nonatomic, strong) UIImageView   *showImgView;
@property (nonatomic, strong) UILabel       *titleLblView;
@property (nonatomic, strong) UILabel       *numIdLblView;

@end

@implementation MDTrendRecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    _showImgView  = [[UIImageView alloc] init];
    _titleLblView = [[UILabel alloc] init];
    _numIdLblView = [[UILabel alloc] init];
    
    [self.contentView addSubview:_showImgView];
    [self.contentView addSubview:_titleLblView];
    [self.contentView addSubview:_numIdLblView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.height.mas_equalTo(70.f);
    }];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImgView);
        make.top.equalTo(self.showImgView.mas_bottom).offset(13.f);
        make.right.equalTo(self.showImgView);
    }];
    [_numIdLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLblView.mas_bottom).offset(8.f);
        make.left.equalTo(self.titleLblView);
        make.right.equalTo(self.titleLblView);
    }];
    
    _showImgView.layer.cornerRadius  =  3.f;
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    _titleLblView.font = FONT_SYSTEM_BOLD(16);
    _titleLblView.textColor = kDefaultTitleColor;
    _numIdLblView.font = FONT_SYSTEM_NORMAL(12);
    _numIdLblView.textColor = COLOR_HEX_STR(@"#8C959F");
    
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650985/raw_1516589142.png" placeholderImage:IMAGE(@"navi_right_icon")];
    _titleLblView.text = @"鸭舌帽";
    _numIdLblView.text = @"NO: 123456";
    
}

@end
