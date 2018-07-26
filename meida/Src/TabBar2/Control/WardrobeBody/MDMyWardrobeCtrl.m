//
//  MDMyWardrobeCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDMyWardrobeCtrl.h"
#import "MDWardrobeRecordCtrl.h"

#pragma mark -  衣橱 -> 我的衣橱 -> vc #############################################----------
static NSString *MDMyWardrobeCtrlCellID = @"MDMyWardrobeCtrlCell";
@interface MDMyWardrobeCtrl ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDMyWardrobeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    self.view.backgroundColor = COLOR_WITH_WHITE;
    [self setNavigationType:NavShowBackAndTitleAndRight];
    [self setTitle:@"我的衣橱"];
    [self setRightBtnWith:@"" image:IMAGE(@"camera_icon")];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kOffset, kOffset, 0, kOffset);
    layout.minimumLineSpacing = kOffset;
    layout.minimumInteritemSpacing = kOffset;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = kDefaultBackgroundColor;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = COLOR_WITH_WHITE;
    [self.collectionView registerClass:[MDMyWardrobeCtrlCell class] forCellWithReuseIdentifier:MDMyWardrobeCtrlCellID];
    
}

- (void)rightBtnTapped:(id)sender
{
    [super rightBtnTapped:sender];
    MDWardrobeRecordCtrl *vc = [[MDWardrobeRecordCtrl alloc] init];
    [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDMyWardrobeCtrlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDMyWardrobeCtrlCellID forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cell_W = (SCR_WIDTH - 3 * kOffset) * 0.5;
    CGFloat cell_H = cell_W + 30.f;
    return CGSizeMake(cell_W, cell_H);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end


#pragma mark -  衣橱 -> 我的衣橱 -> cell view #######################################----------
@interface MDMyWardrobeCtrlCell ()

@property (nonatomic, strong) UIImageView       *showImgView;
@property (nonatomic, strong) UILabel           *nameLblView;
@property (nonatomic, strong) UILabel           *countLblView;

@end

@implementation MDMyWardrobeCtrlCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    CGFloat cell_W = (SCR_WIDTH - 3 * kOffset) * 0.5;
    
    _showImgView  = [[UIImageView alloc] init];
    _nameLblView  = [[UILabel alloc] init];
    _countLblView = [[UILabel alloc] init];
    
    [self.contentView addSubview:_showImgView];
    [self.contentView addSubview:_nameLblView];
    [self.contentView addSubview:_countLblView];
    
    CGFloat padding = 20.f;
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(padding);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(cell_W - 2 * padding, cell_W - 2 * padding));
    }];
    [_nameLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showImgView.mas_bottom).offset(kOffset);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(cell_W - kOffset);
    }];
    [_countLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLblView.mas_bottom).offset(kOffset);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(cell_W - kOffset);
    }];
    
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    _nameLblView.font = FONT_SYSTEM_BOLD(14);
    _nameLblView.textColor = kDefaultTitleColor;
    _nameLblView.textAlignment = NSTextAlignmentCenter;
    _countLblView.font = FONT_SYSTEM_NORMAL(11);
    _countLblView.textColor = kDefaultThirdTitleColor;
    _countLblView.textAlignment = NSTextAlignmentCenter;
    
    //TODO: - 测试数据
    _nameLblView.text = @"上衣 上衣";
    _countLblView.text = @"1990件";
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16654097/raw_1516592335.png" placeholderImage:IMAGE(@"place_holer_icon")];
}


@end

