//
//  MDAddClothMatchCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDAddClothMatchCtrl.h"

@interface MDAddClothMatchCtrl () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MDAddClothMatchCtrl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    [self setNavigationType:NavShowBackAndTitleAndRight];
    [self setTitle:@"添加搭配"];
    [self setRightBtnWith:@"" image:IMAGE(@"navi_right_icon")];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tableView registerClass:[MDTrendRecommendViewUserCell class] forCellReuseIdentifier:kTrendRecommendViewUserCellID];
    //[self.tableView registerClass:[MDTrendRecommendViewContentCell class] forCellReuseIdentifier:kTrendRecommendViewContentCellID];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

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
    //[self.tableView.mj_header beginRefreshing];
    
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
    NSInteger row = indexPath.row;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        return 156.f;
    }
    else{
        return 350;
    }
}

@end
