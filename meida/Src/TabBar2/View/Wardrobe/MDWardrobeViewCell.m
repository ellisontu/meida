//
//  MDWardrobeViewCell.m
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeViewCell.h"

#pragma mark -  衣橱 -> 头部 -> cell view #############################################----------

@implementation MDWardrobeViewFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    UIButton *creativeBtn     = [[UIButton alloc] init];    // 创意按钮
    UIButton *afterClothesBtn = [[UIButton alloc] init];    // 明日装
    UIButton *fashionBtn      = [[UIButton alloc] init];    // 依尚圈
    UIButton *idleBtn         = [[UIButton alloc] init];    // 闲置
    UIView   *separaLine      = [[UIView alloc] init];
    
    [self.contentView addSubview:creativeBtn];
    [self.contentView addSubview:afterClothesBtn];
    [self.contentView addSubview:fashionBtn];
    [self.contentView addSubview:idleBtn];
    [self.contentView addSubview:separaLine];
    
    separaLine.backgroundColor = kDefaultSeparationLineColor;
    [separaLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 2 * koffset, 1.f));
        make.bottom.equalTo(self.contentView);
    }];
    
    CGFloat btnWW = SCR_WIDTH / 4.f;
    CGFloat btnHH = 65.f;
    [creativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    [afterClothesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(creativeBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    [fashionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(afterClothesBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    [idleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(fashionBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    
    // creativeBtn 标题的偏移量
    [creativeBtn setTitle:@"创意" forState:UIControlStateNormal];
    [creativeBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [creativeBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    creativeBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    creativeBtn.titleEdgeInsets = UIEdgeInsetsMake(creativeBtn.imageView.frame.size.height + 5, -creativeBtn.imageView.bounds.size.width, 0,0);
    creativeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, creativeBtn.titleLabel.frame.size.width/2, creativeBtn.titleLabel.frame.size.height+5, -creativeBtn.titleLabel.frame.size.width/2);
    
}

@end

#pragma mark -  衣橱 -> 分类 -> cell view #############################################----------
@interface MDWardrobeViewVerbCell ()

@end

@implementation MDWardrobeViewVerbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
}


@end



#pragma mark -  衣橱 -> 穿衣计划 -> cell view #############################################----------
@interface MDWardrobeViewPlanCell ()

@end

@implementation MDWardrobeViewPlanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
}


@end

