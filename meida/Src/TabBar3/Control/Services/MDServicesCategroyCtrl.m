//
//  MDServicesCategroyCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDServicesCategroyCtrl.h"
#import "MDServicesBaseSortCell.h"
#define kBannerHH 249

static NSString *MDServicesBaseSortCellID = @"MDServicesBaseSortCell";
static NSString *MDServicesReusableViewID = @"MDServicesReusableViewID";

@interface MDServicesCategroyCtrl ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDServicesCategroyCtrl

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
    [self.collectionView registerClass:[MDServicesBaseSortCell class] forCellWithReuseIdentifier:MDServicesBaseSortCellID];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MDServicesReusableViewID];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDServicesBaseSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDServicesBaseSortCellID forIndexPath:indexPath];
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


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCR_WIDTH, kBannerHH);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //从缓存中获取 Headercell
    UICollectionReusableView *view = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MDServicesReusableViewID forIndexPath:indexPath];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat f = scrollView.contentOffset.y;
    if (_delegate && [_delegate respondsToSelector:@selector(ServicesCategroyScrollTo:)]) {
        [_delegate ServicesCategroyScrollTo:f];
    }
}

@end
