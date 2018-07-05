//
//  MDFanshionCircleCategoryCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  时尚圈 分类 vc

#import "MDFanshionCircleCategoryCtrl.h"
#import "MDTrendRecommendView.h"

static NSString *MDTrendRecommendViewContentCellID = @"MDTrendRecommendViewContentCell";

@interface MDFanshionCircleCategoryCtrl ()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation MDFanshionCircleCategoryCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MDTrendRecommendViewContentCell class] forCellReuseIdentifier:MDTrendRecommendViewContentCellID];
    
    
    MDWeakPtr(weakPtr, self);
    // 下拉刷新
    MDRefreshGifHeader *refreshHeader = [MDRefreshGifHeader headerWithRefreshingBlock:^{
        [weakPtr refreshListData];
    }];
    self.tableView.mj_header = refreshHeader;
    
    // 上拉加载
    MDRefreshGifFooter *refreshFooter = [MDRefreshGifFooter footerWithRefreshingBlock:^{
        [weakPtr loadMoreListData];
    }];
    self.tableView.mj_footer = refreshFooter;
    //[_listView.mj_header beginRefreshing];
    
}

- (void)refreshListData
{
    
}

- (void)loadMoreListData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDTrendRecommendViewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:MDTrendRecommendViewContentCellID];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 355.f;
}


@end
