//
//  MDMineControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDMineControl.h"

@interface MDMineControl ()

@end

@implementation MDMineControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavHide];
    
    [self setupTitleMenuView];
}

- (void)setupTitleMenuView
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_WIDTH - 44.f, kStatusBarHeight, 44.f, 44.f)];
    [self.view addSubview:rightBtn];
    [rightBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [rightBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
}


@end
