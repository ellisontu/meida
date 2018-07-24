//
//  MDChannelDetailCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDChannelDetailCtrl.h"
#import "ChannelDetailShowImgCell.h"
#import "ChannelDetailInfoCell.h"

static NSString *ChannelDetailShowImgCellID = @"ChannelDetailShowImgCell";
static NSString *ChannelDetailInfoCellID    = @"ChannelDetailInfoCell";

@interface MDChannelDetailCtrl ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MDChannelDetailCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    [self setNavigationType:NavShowBackAndTitle];
    [self setTitle:@"专题详情"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[ChannelDetailShowImgCell class] forCellReuseIdentifier:ChannelDetailShowImgCellID];
    [self.tableView registerClass:[ChannelDetailInfoCell class] forCellReuseIdentifier:ChannelDetailInfoCellID];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        ChannelDetailShowImgCell *cell = [tableView dequeueReusableCellWithIdentifier:ChannelDetailShowImgCellID];
        return cell;
    }
    else if (1 == row){
        ChannelDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ChannelDetailInfoCellID];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        return SCR_WIDTH * 0.71;
    }
    else if (1 == row){
        return 300;
    }
    return 0.01f;
}


@end
