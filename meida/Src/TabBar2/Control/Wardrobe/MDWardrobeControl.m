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
    
    [self initView];
    
}

- (void)initView
{
    // 设置头部信息
    [self setNavigationType:NavShowTitleAndRiht];
    [self setTitle:@"衣橱"];
    [self setRightBtnWith:@"" image:IMAGE(@"navi_right_icon")];
    [self setupLineView:NO];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeaderHeight);
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
        return SCR_WIDTH;
    }
    else if (2 == row){
        return SCR_WIDTH / 3.f + 90;
    }
    return 0.01f;
}



@end
