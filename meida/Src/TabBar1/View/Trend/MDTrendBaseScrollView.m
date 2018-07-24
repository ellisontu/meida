//
//  MDTrendBaseScrollView.m
//  meida
//
//  Created by ToTo on 2018/7/20.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendBaseScrollView.h"

#import "MDTrendChannelCell.h"
#import "MDTrendUploadNewCell.h"
#import "MDTrendRecommendCell.h"

#import "MDChannelDetailCtrl.h"
#import "MDRecommendDetailCtrl.h"
#import "MDUploadNewDetailCtrl.h"

#define ksegmentHH 49
static NSString *MDTrendChannelCellID   = @"MDTrendChannelCell";
static NSString *MDTrendUploadNewCellID = @"MDTrendUploadNewCell";
static NSString *MDTrendRecommendCellID = @"MDTrendRecommendCell";
static NSString *MDServicesReusableViewID = @"MDServicesReusableViewID";

@interface MDTrendBaseScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) TrendScrollCellType   cellType;

@end

@implementation MDTrendBaseScrollView

- (instancetype)initWithFrame:(CGRect)frame withCellType:(TrendScrollCellType )cellType
{
    
    if (self = [super initWithFrame:frame]) {
        _cellType =  cellType;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = COLOR_WITH_WHITE;
    
    
    switch (_cellType) {
        case CellTypeChannel:
        {// 频道
            UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
            CGFloat padding = 15.f;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.minimumInteritemSpacing = padding;
            flowLayout.minimumLineSpacing = padding;
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            [self.collectionView registerClass:[MDTrendChannelCell class] forCellWithReuseIdentifier:MDTrendChannelCellID];
        }
            break;
        case CellTypeUploadNew:
        {// 上新
            UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
            CGFloat padding = 15.f;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.minimumInteritemSpacing = padding;
            flowLayout.minimumLineSpacing = padding;
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            [self.collectionView registerClass:[MDTrendUploadNewCell class] forCellWithReuseIdentifier:MDTrendUploadNewCellID];
        }
            break;
        case CellTypeRecommend:
        {// 推荐
            UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
            CGFloat padding = 15.f;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.minimumInteritemSpacing = padding;
            flowLayout.minimumLineSpacing = padding;
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            [self.collectionView registerClass:[MDTrendRecommendCell class] forCellWithReuseIdentifier:MDTrendRecommendCellID];
        }
            break;
        default:
            break;
    }
    
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = COLOR_WITH_WHITE;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MDServicesReusableViewID];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (_cellType) {
        case CellTypeChannel:
        {// 频道
            return 5;
        }
            break;
        case CellTypeUploadNew:
        {// 上新
            return 5;
        }
            break;
        case CellTypeRecommend:
        {// 推荐
            return 5;
        }
            break;
        default:
            break;
    }
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_cellType) {
        case CellTypeChannel:
        {// 频道
            MDTrendChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendChannelCellID forIndexPath:indexPath];
            return cell;
        }
            break;
        case CellTypeUploadNew:
        {// 上新
            MDTrendUploadNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendUploadNewCellID forIndexPath:indexPath];
            return cell;
        }
            break;
        case CellTypeRecommend:
        {// 推荐
            MDTrendRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendRecommendCellID forIndexPath:indexPath];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_cellType) {
        case CellTypeChannel:
        {// 频道
            return CGSizeMake(SCR_WIDTH, 185 + SCR_WIDTH);
        }
            break;
        case CellTypeUploadNew:
        {// 上新
            return CGSizeMake(SCR_WIDTH, SCR_WIDTH * 0.7);
        }
            break;
        case CellTypeRecommend:
        {// 推荐
            return CGSizeMake(SCR_WIDTH, 350);
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType == CellTypeChannel) {
        // 
        MDChannelDetailCtrl *vc = [[MDChannelDetailCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
    }
    else if (_cellType == CellTypeUploadNew){
        MDUploadNewDetailCtrl *vc = [[MDUploadNewDetailCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
    }
    else if (_cellType == CellTypeRecommend){
        MDRecommendDetailCtrl *vc = [[MDRecommendDetailCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
    }
}


#pragma mark - collectionView DelegateFlowLayout

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
//    CGFloat itemTotalWitdh = (numberOfItems * collectionView.height) + (numberOfItems - 1) * 5.f;
//    if (itemTotalWitdh >= SCR_WIDTH) return UIEdgeInsetsMake(0, 15, 0, 15) ;
//    CGFloat combinedItemWidth = (numberOfItems * collectionView.height) + ((numberOfItems - 1) * 5);
//    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth) * 0.5 ;
//    return UIEdgeInsetsMake(0, padding, 0, padding);
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCR_WIDTH, ksegmentHH);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //从缓存中获取 Headercell
    UICollectionReusableView *view = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MDServicesReusableViewID forIndexPath:indexPath];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - scroll delegate DelegateFlowLayout

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat f = scrollView.contentOffset.y;
    if (_delegate && [_delegate respondsToSelector:@selector(trendBaseScrollViewScrollTo:)]) {
        [_delegate trendBaseScrollViewScrollTo:f];
    }
}

@end
