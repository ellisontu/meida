//
//  MDWardrobeControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeControl.h"

#import "MDWardrobeViewCell.h"

static NSString *MDWardrobeViewFirstCellID = @"MDWardrobeViewFirstCell";
static NSString *MDWardrobeViewVerbCellID  = @"MDWardrobeViewVerbCell";
static NSString *MDWardrobeViewPlanCellID  = @"MDWardrobeViewPlanCell";

@interface MDWardrobeControl ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MDWardrobeControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavHide];
    
    [self initView];
    
}

- (void)initView
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
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeaderHeight + rightBtn.height);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[MDWardrobeViewFirstCell class] forCellReuseIdentifier:MDWardrobeViewFirstCellID];
    [self.tableView registerClass:[MDWardrobeViewVerbCell class] forCellReuseIdentifier:MDWardrobeViewVerbCellID];
    [self.tableView registerClass:[MDWardrobeViewPlanCell class] forCellReuseIdentifier:MDWardrobeViewPlanCellID];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        MDWardrobeViewFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:MDWardrobeViewFirstCellID];
        return cell;
    }
    else if (1 == row){
        MDWardrobeViewVerbCell *cell = [tableView dequeueReusableCellWithIdentifier:MDWardrobeViewVerbCellID];
        return cell;
    }
    else if (2 == row){
        MDWardrobeViewPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:MDWardrobeViewPlanCellID];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        return 85.f;
    }
    else if (1 == row){
        return 200.f;
    }
    else if (2 == row){
        return 150.f;
    }
    return 0.01f;
}



@end
