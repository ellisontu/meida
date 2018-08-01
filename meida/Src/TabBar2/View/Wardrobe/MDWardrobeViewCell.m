//
//  MDWardrobeViewCell.m
//  meida
//
//  Created by ToTo on 2018/7/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  新衣橱 cell

#import "MDWardrobeViewCell.h"

#import "MDMyWardrobeCtrl.h"
#import "MDMyFittingRoomCtrl.h"
#import "MDWardrobeAfterClothCtrl.h"

#pragma mark -  衣橱 -> cell view #############################################----------
@interface MDWardrobeViewCell ()

@property (nonatomic, strong) UIImageView   *showImgView;
@property (nonatomic, strong) UILabel       *nameLblView;
@property (nonatomic, strong) UILabel       *countLblView;

@end

@implementation MDWardrobeViewCell


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
    self.contentView.layer.borderColor = COLOR_HEX_STR(@"#D7E1E4").CGColor;
    self.contentView.layer.borderWidth = 1.f;
    
    _showImgView  = [[UIImageView alloc] init];
    _nameLblView  = [[UILabel alloc] init];
    _countLblView = [[UILabel alloc] init];
    
    [self.contentView addSubview:_showImgView];
    [self.contentView addSubview:_nameLblView];
    [self.contentView addSubview:_countLblView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(40.f);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(48.f, 48.f));
    }];
    [_nameLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showImgView.mas_bottom).offset(kOffPadding);
        make.centerX.equalTo(self.contentView);
    }];
    [_countLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLblView.mas_bottom).offset(7.f);
        make.centerX.equalTo(self.contentView);
    }];
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    _nameLblView.font = FONT_SYSTEM_BOLD(16);
    _nameLblView.textColor = kDefaultTitleColor;
    _countLblView.font = FONT_SYSTEM_NORMAL(12);
    _countLblView.textColor = COLOR_HEX_STR(@"#8C959F");
    
}

- (void)setDict:(NSDictionary *)dict
{
    if (!dict)  return;
    
    _dict = dict;
    
    _showImgView.image = dict[@"image"];
    _nameLblView.text = dict[@"name"];
    _countLblView.text = dict[@"count"];
    
}

@end


#pragma mark -  衣橱 -> 头部 view #############################################----------
@interface WardrobeAfterClothHeadView ()

@end

@implementation WardrobeAfterClothHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = COLOR_HEX_STR(@"#F4F4F4");
    
    CGFloat btnWW = (SCR_WIDTH - 4 * kOffPadding) / 3.f;
    for (int i = 0; i < 3; ++i) {
        
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWW, 30.f));
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kOffPadding + i * (btnWW + kOffPadding));
        }];
        btn.tag = 1000 + i;
        btn.layer.cornerRadius  = 30 * 0.5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = COLOR_HEX_STR(@"#E7E7E7").CGColor;
        btn.layer.borderWidth = 1.f;
        btn.titleLabel.font = FONT_SYSTEM_NORMAL(15);
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:
            {//
                [btn setTitle:@"我的衣橱" forState:UIControlStateNormal];
                [btn setTitleColor:COLOR_HEX_STR(@"#8C959F") forState:UIControlStateNormal];
                btn.backgroundColor = COLOR_HEX_STR(@"#F4F4F4");
            }
                break;
            case 1:
            {
                [btn setTitle:@"试衣间" forState:UIControlStateNormal];
                [btn setTitleColor:COLOR_HEX_STR(@"#8C959F") forState:UIControlStateNormal];
                btn.backgroundColor = COLOR_HEX_STR(@"#F4F4F4");
            }
                break;
            case 2:
            {
                [btn setTitle:@"明日装" forState:UIControlStateNormal];
                [btn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
                btn.backgroundColor = COLOR_WITH_WHITE;
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)btnClickAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
        {// 点击 "我的衣橱"
            MDMyWardrobeCtrl *vc = [[MDMyWardrobeCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        case 1001:
        {// 点击 "试衣间"
            MDMyFittingRoomCtrl *vc = [[MDMyFittingRoomCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        case 1002:
        {// 点击 "明日装"
            MDWardrobeAfterClothCtrl *vc = [[MDWardrobeAfterClothCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end


#pragma mark -  衣橱 -> 底部 ->  view #############################################----------
@interface WardrobeAfterClothFooterView ()


@end

@implementation WardrobeAfterClothFooterView

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
    UIButton *addbtn = [[UIButton alloc] init];
    [self addSubview:addbtn];
    [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(kOffPadding);
    }];
    addbtn.titleLabel.font = FONT_SYSTEM_NORMAL(15);
    [addbtn setTitleColor:COLOR_HEX_STR(@"#8C959F") forState:UIControlStateNormal];
    [addbtn setTitle:@"新增分类" forState:UIControlStateNormal];
    addbtn.backgroundColor = COLOR_HEX_STR(@"#F4F4F4");
    [addbtn addTarget:self action:@selector(addClassifyAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addClassifyAction:(UIButton *)sender
{
    XLog(@"%s",__func__);
}

@end

