//
//  MDUploadNewDetailCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDUploadNewDetailCtrl.h"
#import "UploadNewDetailScrollView.h"
#import "UploadNewDetailPriceCell.h"

static CGFloat kbottomViewH = 60.f;
static NSString *UploadNewDetailPriceCellID     = @"UploadNewDetailPriceCell";
@interface MDUploadNewDetailCtrl ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UploadNewDetailScrollView *headScrollView;
@property (nonatomic, strong) UploadNewDetailBottomView *bottomView;

@end

@implementation MDUploadNewDetailCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    [self setNavigationType:NavShowBackAndTitle];
    [self setTitle:@"上新详情"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight - kbottomViewH) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[UploadNewDetailPriceCell class] forCellReuseIdentifier:UploadNewDetailPriceCellID];
    self.headScrollView.picsArr = @[@"https://pro.modao.cc/uploads3/images/2007/20078316/raw_1526137029.png",
                                    @"https://pro.modao.cc/uploads3/images/2007/20078316/raw_1526137029.png",
                                    @"https://pro.modao.cc/uploads3/images/2007/20078316/raw_1526137029.png"];
    self.bottomView.hidden = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row){
        UploadNewDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:UploadNewDetailPriceCellID];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row){
        return 200.f;
    }
    return 0.01f;
}

- (UploadNewDetailScrollView *)headScrollView
{
    if (!_headScrollView) {
        _headScrollView = [[UploadNewDetailScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_WIDTH * 0.71)];
        self.tableView.tableHeaderView = _headScrollView;
    }
    return _headScrollView;
}

- (UploadNewDetailBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UploadNewDetailBottomView alloc] init];
        _bottomView.hidden = YES;
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, kbottomViewH));
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _bottomView;
}

@end
