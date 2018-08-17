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
@property (nonatomic, strong) UIButton      *distanceTipsBtn;   /**< 距离提示 */
@property (nonatomic, strong) UILabel       *shopDescLblView;   /**< 店面描述 */
@property (nonatomic, strong) UILabel       *shopLocationLbl;   /**< 店面地址 */
@property (nonatomic, strong) UIButton      *heartBtnView;      /**< 收藏icon */
@property (nonatomic, strong) UIButton      *shareShopBtnView;  /**< 分享 */

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
    
    _containerView    = [[UIView alloc] init];
    _shopShowImgView  = [[UIImageView alloc] init];
    _distanceTipsBtn  = [[UIButton alloc] init];
    _shopDescLblView  = [[UILabel alloc] init];
    _shopLocationLbl  = [[UILabel alloc] init];
    _heartBtnView     = [[UIButton alloc] init];
    _shareShopBtnView = [[UIButton alloc] init];
    UIView *lineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_containerView];
    [_containerView addSubview:_shopShowImgView];
    [_containerView addSubview:_distanceTipsBtn];
    [_containerView addSubview:_shopDescLblView];
    [_containerView addSubview:_shopLocationLbl];
    [_containerView addSubview:_heartBtnView];
    [_containerView addSubview:_shareShopBtnView];
    [_containerView addSubview:lineView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [_shopShowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, SCR_WIDTH * 0.71));
    }];
    [_distanceTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.f, 25.f));
        make.bottom.equalTo(self.shopDescLblView.mas_top).offset(-30.f);
        make.left.equalTo(self.shopShowImgView).offset(20.f);
    }];
    [_shopDescLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopShowImgView).offset(20.f);
        make.right.equalTo(self.shopShowImgView).offset(-20.f);
        make.bottom.equalTo(self.shopShowImgView).offset(-20.f);
    }];
    [_shopLocationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(10.f);
        make.top.equalTo(self.shopShowImgView.mas_bottom).offset(15.f);
        //make.width.mas_equalTo(150.f);// 临时宽度
        make.right.equalTo(self.heartBtnView.mas_right);
    }];
    [_heartBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.f, 35.f));
        make.centerY.equalTo(self.shareShopBtnView);
        make.right.equalTo(lineView.mas_left).offset(-5.f);
    }];
    [_shareShopBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.f, 35.f));
        make.centerY.equalTo(self.shopLocationLbl);
        make.right.equalTo(self.containerView).offset(-20.f);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareShopBtnView);
        make.right.equalTo(self.shareShopBtnView.mas_left).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(1.f, 20.f));
    }];
    
    lineView.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
    
    _shopShowImgView.contentMode = UIViewContentModeScaleAspectFill;
    _shopShowImgView.layer.masksToBounds = YES;
    
    [_heartBtnView setTitle:@"10011" forState:UIControlStateNormal];
    [_heartBtnView setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    _heartBtnView.titleLabel.font = FONT_SYSTEM_BOLD(15);
    [_heartBtnView setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    
    _heartBtnView.titleEdgeInsets = UIEdgeInsetsMake(0, _heartBtnView.titleLabel.bounds.size.width + 15, 0, -_heartBtnView.titleLabel.bounds.size.width);
    _shopLocationLbl.font = FONT_SYSTEM_NORMAL(16);
    _shopLocationLbl.textColor = kDefaultTitleColor;
    _shopLocationLbl.text = @"万达广场城西二旗店";
    _distanceTipsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _distanceTipsBtn.titleLabel.bounds.size.width + 15, 0, -_distanceTipsBtn.titleLabel.bounds.size.width);
    [_distanceTipsBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [_distanceTipsBtn setTitle:@"距您 2km" forState:UIControlStateNormal];
    _distanceTipsBtn.titleLabel.font = FONT_SYSTEM_NORMAL(14);
    [_distanceTipsBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    
    _shareShopBtnView.backgroundColor = [UIColor purpleColor];
    
    //TODO: - 测试数据
    [_shopShowImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/2007/20078742/raw_1526138607.png" placeholderImage:IMAGE(@"navi_right_icon")];
    
}


@end

