//
//  MDTrendUploadNewPopView.m
//  meida
//
//  Created by ToTo on 2018/8/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendUploadNewPopView.h"

#pragma mark -  潮流 -> 上新 -> 点击 pop view ################################################----------
@interface MDTrendUploadNewPopView ()

@property (nonatomic, strong) UIView        *bgCoverView;   /**< 黑色背景view */
@property (nonatomic, strong) UIView        *containerView; /**<  */

@property (nonatomic, strong) UILabel       *headTipsLblView;   /**< new */
@property (nonatomic, strong) UILabel       *dateTipsLblView;   /**< 日期 */
@property (nonatomic, strong) UILabel       *seasoTipsLblView;  /**< 季节 */
@property (nonatomic, strong) UILabel       *timeTipsLblView;   /**< 时间 */
@property (nonatomic, strong) UIImageView   *shopShowImgView;   /**< 店铺展示 */
@property (nonatomic, strong) UILabel       *shopLeadLblView;   /**< 店长 */
@property (nonatomic, strong) UILabel       *shopDescLblView;   /**< 店铺描述 */


@end

@implementation MDTrendUploadNewPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    //1. 主体view
    _bgCoverView    = [[UIView alloc] init];
    _containerView  = [[UIView alloc] init];
    
    [self addSubview:_bgCoverView];
    [self addSubview:_containerView];
    
    [_bgCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 60.f, SCR_HEIGHT - 110));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kHeaderHeight);
    }];
    _bgCoverView.alpha = 0.4f;
    _bgCoverView.backgroundColor = COLOR_WITH_BLACK;
    _containerView.backgroundColor = COLOR_WITH_WHITE;
    self.alpha = 0.01f;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)]];
    
    //2.1 subview
    UIButton *colseBtn = [[UIButton alloc] init];

    [_containerView addSubview:colseBtn];
    [colseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.top.equalTo(self.containerView).offset(5.f);
        make.right.equalTo(self.containerView).offset(-5.f);
    }];
    colseBtn.backgroundColor = [UIColor purpleColor];
    [colseBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    
    //2.2 subviews
    _headTipsLblView  = [[UILabel alloc] init];
    _dateTipsLblView  = [[UILabel alloc] init];
    _seasoTipsLblView = [[UILabel alloc] init];
    _timeTipsLblView  = [[UILabel alloc] init];
    
    [_containerView addSubview:_headTipsLblView];
    [_containerView addSubview:_dateTipsLblView];
    [_containerView addSubview:_seasoTipsLblView];
    [_containerView addSubview:_timeTipsLblView];
    
    [_headTipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(40.f);
        make.centerX.equalTo(self.containerView);
    }];
    [_dateTipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headTipsLblView.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.containerView);
    }];
    [_seasoTipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.dateTipsLblView.mas_bottom).offset(10.f);
    }];
    [_timeTipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seasoTipsLblView.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.containerView);
    }];
    _headTipsLblView.text = @"NEW";
    _dateTipsLblView.text = @"2018夏季上新";
    _seasoTipsLblView.text = @"夏上新";
    _timeTipsLblView.text = @"7月7日 10：00上新";
    
    //2.3 subviews
    _shopShowImgView = [[UIImageView alloc] init];
    _shopLeadLblView = [[UILabel alloc] init];
    _shopDescLblView = [[UILabel alloc] init];
    
    [_containerView addSubview:_shopShowImgView];
    [_containerView addSubview:_shopLeadLblView];
    [_containerView addSubview:_shopDescLblView];
    [_shopShowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTipsLblView.mas_bottom).offset(35.f);
        make.left.equalTo(self.containerView).offset(50.f);
        make.right.equalTo(self.containerView).offset(-50.f);
        make.height.mas_equalTo(110.f);
    }];
    [_shopLeadLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopShowImgView.mas_bottom).offset(20.f);
        make.centerX.equalTo(self.shopShowImgView);
    }];
    [_shopDescLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopLeadLblView.mas_bottom).offset(25.f);
        make.left.equalTo(self.containerView).offset(40.f);
        make.right.equalTo(self.containerView).offset(-40.f);
    }];
    
    _shopShowImgView.contentMode = UIViewContentModeScaleAspectFill;
    _shopShowImgView.layer.masksToBounds = YES;
    _shopLeadLblView.text = @"店长：张小玲";
    _shopDescLblView.text = @"万达广场旗舰店是当地最大的品牌店，店内有专业工作人员10名，试衣间5个。";
    _shopDescLblView.numberOfLines = 0;
    [_shopShowImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/2007/20078742/raw_1526138607.png" placeholderImage:IMAGE(@"navi_right_icon")];
    
}

- (void)showView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.f;
    }];
}

- (void)hiddenView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.01f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
