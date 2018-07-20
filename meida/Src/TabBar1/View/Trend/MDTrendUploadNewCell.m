//
//  MDTrendUploadNewCell.m
//  meida
//
//  Created by ToTo on 2018/7/20.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendUploadNewCell.h"

@interface MDTrendUploadNewCell ()

@property (nonatomic, strong) UIView        *containerView;
@property (nonatomic, strong) UIImageView   *shopShowImgView;   /**< 店面展示 image */
@property (nonatomic, strong) UIImageView   *shopLogoImgView;   /**< 店面logo */
@property (nonatomic, strong) UIButton      *heartBtnView;      /**< 收藏icon */
@property (nonatomic, strong) UILabel       *shopLocationLbl;   /**< 店面地址 */
@property (nonatomic, strong) UIButton      *distanceTipsBtn;   /**< 距离提示 */

@end

@implementation MDTrendUploadNewCell

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
    
    _containerView   = [[UIView alloc] init];
    _shopLogoImgView = [[UIImageView alloc] init];
    _shopShowImgView = [[UIImageView alloc] init];
    _heartBtnView    = [[UIButton alloc] init];
    _shopLocationLbl = [[UILabel alloc] init];
    _distanceTipsBtn = [[UIButton alloc] init];
    
    [self.contentView addSubview:_containerView];
    [_containerView addSubview:_shopShowImgView];
    [_containerView addSubview:_shopLogoImgView];
    [_containerView addSubview:_heartBtnView];
    [_containerView addSubview:_shopLocationLbl];
    [_containerView addSubview:_distanceTipsBtn];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
        make.bottom.equalTo(self.contentView).offset(-kOffPadding);
    }];
    [_shopShowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self->_containerView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 30.f, SCR_WIDTH * 0.6 - 40.f));
    }];
    [_heartBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.f, 35.f));
        make.top.equalTo(self->_shopShowImgView).offset(5.f);
        make.right.equalTo(self->_shopShowImgView).offset(-5.f);
    }];
    [_shopLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_shopShowImgView).offset(5.f);
        make.top.equalTo(self->_shopShowImgView).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(65.f, 40.f));
    }];
    [_shopLocationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_containerView).offset(10.f);
        make.bottom.equalTo(self->_containerView).offset(-17.f);
        make.width.mas_equalTo(150.f);// 临时宽度
    }];
    
    [_distanceTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.f, 40.f));
        make.centerY.equalTo(self->_shopLocationLbl);
        make.right.equalTo(self->_containerView).offset(-10.f);
    }];
    
    _containerView.layer.borderColor = kDefaultBorderColor.CGColor;
    _containerView.layer.borderWidth = 1.f;
    
    _shopShowImgView.contentMode = UIViewContentModeScaleAspectFill;
    _shopShowImgView.layer.masksToBounds = YES;
    
    [_heartBtnView setTitle:@"10011" forState:UIControlStateNormal];
    [_heartBtnView setTitleColor:COLOR_WITH_WHITE forState:UIControlStateNormal];
    _heartBtnView.titleLabel.font = FONT_SYSTEM_BOLD(16);
    [_heartBtnView setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    _heartBtnView.userInteractionEnabled = NO;
    
    _heartBtnView.titleEdgeInsets = UIEdgeInsetsMake(0, _heartBtnView.titleLabel.bounds.size.width + 15, 0, -_heartBtnView.titleLabel.bounds.size.width);
    _shopLogoImgView.contentMode =  UIViewContentModeScaleAspectFit;
    _shopLogoImgView.backgroundColor = [UIColor clearColor];
    
    _shopLocationLbl.font = FONT_SYSTEM_NORMAL(16);
    _shopLocationLbl.textColor = kDefaultTitleColor;
    _shopLocationLbl.text = @"万达广场城西二旗店";
    _distanceTipsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _distanceTipsBtn.titleLabel.bounds.size.width + 15, 0, -_distanceTipsBtn.titleLabel.bounds.size.width);
    [_distanceTipsBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [_distanceTipsBtn setTitle:@"距您 2km" forState:UIControlStateNormal];
    _distanceTipsBtn.titleLabel.font = FONT_SYSTEM_NORMAL(14);
    [_distanceTipsBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    
    //TODO: - 测试数据
    [_shopShowImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/2007/20078742/raw_1526138607.png" placeholderImage:IMAGE(@"navi_right_icon")];
    
}


@end
