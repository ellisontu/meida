//
//  UploadNewDetailPriceCell.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UploadNewDetailPriceCell.h"

@interface UploadNewDetailPriceCell ()

@property (nonatomic, strong) UIView    *priceContainerView;
@property (nonatomic, strong) UILabel   *numberLblView;
@property (nonatomic, strong) UILabel   *priceLblView;

@property (nonatomic, strong) UILabel   *titleLblView;
@property (nonatomic, strong) UILabel   *descLblView;

@end

@implementation UploadNewDetailPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    //1. 编号 价格
    _priceContainerView = [[UIView alloc] init];
    _numberLblView = [[UILabel alloc] init];
    _priceLblView  = [[UILabel alloc] init];
    UIView *lineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_priceContainerView];
    [_priceContainerView addSubview:_numberLblView];
    [_priceContainerView addSubview:_priceLblView];
    [_priceContainerView addSubview:lineView];
    
    [_priceContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 49.f));
        make.centerX.equalTo(self.contentView);
    }];
    [_numberLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceContainerView);
        make.left.equalTo(self.priceContainerView).offset(kOffPadding);
    }];
    [_priceLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceContainerView);
        make.right.equalTo(self.priceContainerView).offset(-kOffPadding);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceContainerView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 1.f));
        make.centerX.equalTo(self.priceContainerView);
    }];
    
    _numberLblView.font = FONT_SYSTEM_BOLD(15);
    _numberLblView.textColor = kDefaultTitleColor;
    _numberLblView.text = @"NO. 65904";
    _priceLblView.font  = FONT_SYSTEM_NORMAL(15);
    _priceLblView.textColor = COLOR_HEX_STR(@"#8C959F");
    _priceLblView.text = @"¥ 800.00元";
    lineView.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
    
    //2. 标题 描述
    _titleLblView = [[UILabel alloc] init];
    _descLblView  = [[UILabel alloc] init];
    
    [self.contentView addSubview:_titleLblView];
    [self.contentView addSubview:_descLblView];
    
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.top.equalTo(self.priceContainerView.mas_bottom).offset(kOffset);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
    }];
    [_descLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLblView.mas_bottom).offset(kOffset);
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
    }];
    _titleLblView.font = FONT_SYSTEM_BOLD(14);
    _titleLblView.textColor = kDefaultTitleColor;
    _titleLblView.text = @"货品描述";
    _descLblView.font = FONT_SYSTEM_NORMAL(14);
    _descLblView.textColor = COLOR_HEX_STR(@"#8C959F");
    _descLblView.numberOfLines = 0;
    _descLblView.text = @"品牌名称：诗丹帝国\n"
    "更多参数产品参数：\n"
    "上市年份季节: 2018年夏季材质成分: 棉95%\n 聚氨酯弹性纤维(氨纶)5%货号: DSA409-2-PK26销售渠道类型: 纯电商(只在线上销售)面料分类: 针织料品牌: 诗丹帝国厚薄: 薄基础风格: 青春流行";
    
    
}

@end
