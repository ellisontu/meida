//
//  ChannelDetailInfoCell.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "ChannelDetailInfoCell.h"

@interface ChannelDetailInfoCell ()

@property (nonatomic, strong) UILabel   *priceLblView;
@property (nonatomic, strong) UILabel   *titleLblView;
@property (nonatomic, strong) UILabel   *descLblView;

@end

@implementation ChannelDetailInfoCell

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
    
    _priceLblView = [[UILabel alloc] init];
    _titleLblView = [[UILabel alloc] init];
    _descLblView  = [[UILabel alloc] init];
    
    [self.contentView addSubview:_priceLblView];
    [self.contentView addSubview:_titleLblView];
    [self.contentView addSubview:_descLblView];
    
    [_priceLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kOffset);
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
    }];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLblView.mas_bottom).offset(kOffset);
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
    }];
    [_descLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLblView.mas_bottom).offset(kOffset);
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
    }];
    
    _priceLblView.font = FONT_SYSTEM_NORMAL(12);
    _priceLblView.textColor = COLOR_HEX_STR(@"#CAB188");
    _priceLblView.text = @"¥ 1000.001";
    _titleLblView.font = FONT_SYSTEM_NORMAL(17);
    _titleLblView.textColor = COLOR_HEX_STR(@"#2C3240");
    _titleLblView.text = @"隔壁女神的文艺范";
    _descLblView.font  = FONT_SYSTEM_NORMAL(14);
    _descLblView.textColor = COLOR_HEX_STR(@"#2C3240");
    _descLblView.numberOfLines = 0;
    _descLblView.text = @"步骤："
    "1.登录余额充足账号，点击《仕途多娇》第77章"
    "2.弹出单章购买弹窗"
    "3.点击优惠阅读"
    "4.切换章节至200章 赠送600书券"
    "5.点击充值，返回至优惠阅读弹窗，观察书币书券数"
    "期望结果：充值6元，点击返回优惠阅读弹窗，书币增加600，书券数增加30"
    "实际结果：充值6元，点击返回优惠阅读弹窗，书币未增加600，书券数未增加30";
    
}

@end
