//
//  MDServicesBaseSortCell.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDServicesBaseSortCell.h"
#import "MDStarView.h"
#import "MDCycleScrollView.h"

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
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    CGFloat cell_W = (SCR_WIDTH - 30) * 0.5;
    
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
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16651199/raw_1516589335.png" placeholderImage:IMAGE(@"place_holer_icon")];
    
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


#pragma mark -  服务 -> head -> cell view #############################################----------

@interface MDServicesHeaderView ()<MDCycleScrollViewDelegate>

@property (nonatomic, strong) UIView        *searchBorderView;
@property (nonatomic, strong) UILabel       *searchContentLbl;
@property (nonatomic, strong) UIImageView   *searchImgView;



@end

@implementation MDServicesHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    
    // 1. 搜索 view
    _searchBorderView = [[UIView alloc] init];
    _searchContentLbl = [[UILabel alloc] init];
    _searchImgView    = [[UIImageView alloc] init];
    
    [self addSubview:_searchBorderView];
    [_searchBorderView addSubview:_searchContentLbl];
    [_searchBorderView addSubview:_searchImgView];
    
    [_searchBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kOffPadding);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 2 * kOffPadding, 25.f));
        make.centerX.equalTo(self);
    }];
    [_searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBorderView);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
        make.right.equalTo(self.searchBorderView).offset(-kOffPadding);
    }];
    [_searchContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBorderView).offset(kOffPadding);
        make.right.equalTo(self.searchImgView.mas_left).offset(-kOffPadding);
        make.centerY.equalTo(self.searchBorderView);
    }];
    
    _searchBorderView.layer.cornerRadius  = 25.f * 0.5;
    _searchBorderView.layer.masksToBounds = YES;
    _searchBorderView.layer.borderColor = kDefaultBorderColor.CGColor;
    _searchBorderView.layer.borderWidth = 1.f;
    
    _searchContentLbl.font = FONT_SYSTEM_NORMAL(11);
    _searchContentLbl.textColor = kDefaultThirdTitleColor;
    _searchContentLbl.text = @"搜索搭配师、整理师、服务意见~";
    _searchImgView.image = IMAGE(@"navi_right_icon");
    
    
    //TODO: - 测试数据
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    NSArray *titles = @[@"新建交流QQ群：185534916 ",
                        @"disableScrollGesture可以设置禁止拖动",
                        @"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com"
                        ];
    MDCycleScrollView *cycleScrollView = [MDCycleScrollView cycleScrollViewWithFrame:CGRectMake(kOffPadding, 55.f, SCR_WIDTH - 2 * kOffPadding, 135.f) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.ControlAliment = ContolAlimentRight;
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self addSubview:cycleScrollView];
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
}



@end
