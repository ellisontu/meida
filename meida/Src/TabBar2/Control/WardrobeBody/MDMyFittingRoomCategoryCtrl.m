//
//  MDMyFittingRoomCategoryCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDMyFittingRoomCategoryCtrl.h"

static NSString *MDMyFittingRoomCategoryCtrlCellID = @"MDMyFittingRoomCategoryCtrlCell";

@interface MDMyFittingRoomCategoryCtrl ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDMyFittingRoomCategoryCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kOffset, kOffset, 0, kOffset);
    layout.minimumLineSpacing = kOffset;
    layout.minimumInteritemSpacing = kOffset;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = COLOR_WITH_WHITE;
    [self.collectionView registerClass:[MDMyFittingRoomCategoryCtrlCell class] forCellWithReuseIdentifier:MDMyFittingRoomCategoryCtrlCellID];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDMyFittingRoomCategoryCtrlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDMyFittingRoomCategoryCtrlCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cell_W = (SCR_WIDTH - 3 * kOffset) * 0.5;
    CGFloat cell_H = cell_W + 55.f;
    return CGSizeMake(cell_W, cell_H);
}
@end


#pragma mark -  衣橱 -> 我的试衣间 -> cell #############################################----------

@interface MDMyFittingRoomCategoryCtrlCell ()

@property (nonatomic, strong) UIImageView   *showImgView;

@end

@implementation MDMyFittingRoomCategoryCtrlCell

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
    _showImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_showImgView];
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16651199/raw_1516589335.png" placeholderImage:IMAGE(@"place_holer_icon")];
    
}

@end