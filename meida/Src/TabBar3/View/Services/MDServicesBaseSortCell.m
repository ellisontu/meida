//
//  MDServicesBaseSortCell.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDServicesBaseSortCell.h"
#import "MDStarView.h"

@interface MDServicesBaseSortCell ()

@property (nonatomic, strong) UIImageView   *showImgView;
@property (nonatomic, strong) UILabel       *priceLblView;
@property (nonatomic, strong) MDStarView    *starView;
@property (nonatomic, strong) UILabel       *descLblView;


@end

@implementation MDServicesBaseSortCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    CGFloat cell_W = (SCR_WIDTH - 10 - 2 * kOffset) * 0.5;
    
    _showImgView  = [[UIImageView alloc] init];
    _priceLblView = [[UILabel alloc] init];
    CGFloat starWW = cell_W * 0.5;
    _starView     = [[MDStarView alloc] initWithFrame:CGRectMake(starWW, cell_W + 10, cell_W * 0.4, 15) numberOfStar:4];
    _descLblView  = [[UILabel alloc] init];
    
    [self.contentView addSubview:_showImgView];
    [self.contentView addSubview:_priceLblView];
    [self.contentView addSubview:_starView];
    [self.contentView addSubview:_descLblView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(cell_W);
    }];
    [_priceLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(-10.f);
        make.centerY.equalTo(self.starView);
        make.width.mas_equalTo(cell_W * 0.5);
    }];
    [_descLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLblView.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(cell_W);
    }];
    
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    [_showImgView sd_setImageWithURL:[NSURL URLWithString:@"https://pro.modao.cc/uploads3/images/1665/16651199/raw_1516589335.png"] placeholderImage:IMAGE(@"place_holer_icon")];
    
    _starView.userInteractionEnabled = NO;
    [_starView setScore:0.5 withAnimation:YES];
    
    _priceLblView.text = @"¥ 99";
    _priceLblView.font = FONT_SYSTEM_BOLD(11);
    _priceLblView.textColor = kDefaultTitleColor;
    _priceLblView.textAlignment = NSTextAlignmentRight;
    _descLblView.text = @"擅长: 商务搭配";
    _descLblView.font = FONT_SYSTEM_NORMAL(10);
    _descLblView.textColor = kDefaultTitleColor;
    _descLblView.textAlignment = NSTextAlignmentCenter;
    
    
}

@end
