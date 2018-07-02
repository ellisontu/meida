//
//  MDWardrobeControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeControl.h"

@interface MDWardrobeControl ()

@end

@implementation MDWardrobeControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBackgroundColor;
    
    [self setNavigationType:NavHide];
    
    [self setupTitleMenuView];
    
}

- (void)setupTitleMenuView
{
    
    // 设置头部信息
    UILabel *tipsLblView = [[UILabel alloc] init];
    [self.view addSubview:tipsLblView];
    tipsLblView.font = FONT_SYSTEM_NORMAL(20);
    tipsLblView.textColor = kDefaultTitleColor;
    tipsLblView.text = @"发现";
    [tipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeaderHeight + 10);
        make.left.equalTo(self.view).offset(koffset);
    }];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_WIDTH - 44.f, kStatusBarHeight, 44.f, 44.f)];
    [self.view addSubview:rightBtn];
    [rightBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [rightBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
}

@end
