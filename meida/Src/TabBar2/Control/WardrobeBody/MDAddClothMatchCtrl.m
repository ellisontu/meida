//
//  MDAddClothMatchCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDAddClothMatchCtrl.h"
#import "MDAddClothMatchCell.h"
#import "MDChoosePhotosCtrl.h"

static NSString *MDAddClothMatchCameraCellID = @"MDAddClothMatchCameraCell";
static NSString *MDAddClothMatchTagCellID    = @"MDAddClothMatchTagCell";
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[MDAddClothMatchCameraCell class] forCellReuseIdentifier:MDAddClothMatchCameraCellID];
    [self.tableView registerClass:[MDAddClothMatchTagCell class] forCellReuseIdentifier:MDAddClothMatchTagCellID];

    /*
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
    [self.tableView.mj_header beginRefreshing];
     */
    
}

- (void)refreshListData
{
    
}

- (void)loadMoreListData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        MDAddClothMatchCameraCell *cell = [tableView dequeueReusableCellWithIdentifier:MDAddClothMatchCameraCellID];
        return cell;
    }
    else if (1 == row){
        MDAddClothMatchTagCell *cell = [tableView dequeueReusableCellWithIdentifier:MDAddClothMatchTagCellID];
        return cell;
    }
    else if (2 == row){
        MDAddClothMatchTagCell *cell = [tableView dequeueReusableCellWithIdentifier:MDAddClothMatchTagCellID];
        return cell;
    }
    else if (3 == row){
        MDAddClothMatchTagCell *cell = [tableView dequeueReusableCellWithIdentifier:MDAddClothMatchTagCellID];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        MDChoosePhotosCtrl *vc = [[MDChoosePhotosCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (0 == row) {
        return SCR_WIDTH * 0.71f;
    }
    else if (1 == row){
        return 150;
    }
    else if (2 == row){
        return 110;
    }
    else if (3 == row){
        return 110;
    }
    return 0.01f;
}

@end
