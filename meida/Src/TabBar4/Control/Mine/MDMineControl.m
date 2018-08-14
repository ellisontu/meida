//
//  MDMineControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDMineControl.h"

#import "MDMineContentCell.h"

static NSString *MDMineContentCommonCellID = @"MDMineContentCommonCell";

@interface MDMineControl ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MDMineContentHeadView     *headView;
@property (nonatomic, strong) NSArray       *section0Arr;
@property (nonatomic, strong) NSArray       *section1Arr;

@end

@implementation MDMineControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavHide];
    
    [self initView];
}

- (void)initView
{
    // init view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[MDMineContentCommonCell class] forCellReuseIdentifier:MDMineContentCommonCellID];
    
    // init headview
    self.tableView.tableHeaderView = [[MDMineContentHeadView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_WIDTH)];
    
    // init data
    _section0Arr = @[@{@"type":@"0",
                       @"title":@"服搭师"
                       },
                     @{@"type":@"1",
                       @"title":@"服务订单"
                       },
                     @{@"type":@"3",
                       @"title":@"我的礼劵"
                       }];
    _section1Arr = @[@{@"type":@"4",
                       @"title":@"帮助"
                       },
                     @{@"type":@"5",
                       @"title":@"邀请好友"
                       }];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_WIDTH - 44.f, kStatusBarHeight, 44.f, 44.f)];
    [self.view addSubview:rightBtn];
    [rightBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [rightBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return _section0Arr.count;
    }
    else if (1 == section){
        return _section1Arr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    MDMineContentCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:MDMineContentCommonCellID];
    if (0 == section) {
        if (indexPath.row < _section0Arr.count) {
            cell.infoDict = _section0Arr[indexPath.row];
        }
    }
    else if (1 == section){
        if (indexPath.row < _section1Arr.count) {
            cell.infoDict = _section1Arr[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 10.f)];
    view.backgroundColor = COLOR_WITH_WHITE;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - 禁止下拉 ################## -------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0){
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}


@end
