//
//  MDTrendChildCtrl.m
//  meida
//
//  Created by ToTo on 2018/8/16.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendChildCtrl.h"

#import "MDTrendChannelCell.h"
#import "MDTrendUploadNewCell.h"
#import "MDTrendRecommendCell.h"

#import "MDChannelDetailCtrl.h"
#import "MDRecommendDetailCtrl.h"
#import "MDUploadNewDetailCtrl.h"
#import "MDTrendUploadNewPopView.h"

#define ksegmentHH 49
static NSString *MDTrendChannelCellID   = @"MDTrendChannelCell";
static NSString *MDTrendUploadNewCellID = @"MDTrendUploadNewCell";
static NSString *MDTrendRecommendCellID = @"MDTrendRecommendCell";
static NSString *MDServicesReusableViewID = @"MDServicesReusableViewID";


@interface MDTrendChildCtrl ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString     *currentPage;
@property (nonatomic, strong) NSString     *pageSize;
@property (nonatomic, assign) BOOL          flag;


@end

@implementation MDTrendChildCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    _currentPage = @"0";
    _pageSize = @"10";
    
    if (self.cellType == CellTypeChannel || self.cellType == CellTypeRecommend) {
        [self refreshData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.cellType == CellTypeUploadNew && !self.flag) {
        [self refreshData];
        self.flag = YES;
    }
}

- (void)initView
{
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    
    switch (self.cellType) {
        case CellTypeChannel:
        {// 频道
            UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
            CGFloat padding = 0.f;
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
            CGFloat padding = 0.f;
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
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.minimumInteritemSpacing = kOffPadding;
            flowLayout.minimumLineSpacing = kOffPadding;
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
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)refreshData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (self.cellType) {
        case CellTypeChannel:
        {// 频道
            [[MDNetWorking sharedClient] requestWithPath:URL_GET_SUBJECT_LIST params:params httpMethod:MethodGet callback:^(BOOL rs, NSObject *obj) {
                if (rs) {
                    XLog(@"-------------%@",obj);
                }
                else{
                    [Util showErrorMessage:obj forDuration:1.0f];
                }
            }];
        }
            break;
        case CellTypeUploadNew:
        {// 上新
            [params setObject:_currentPage forKey:@"currentPage"];
            [params setObject:_pageSize forKey:@"pageSize"];
            [params setObject:stringIsEmpty(LOGIN_USER.longitude) ? @"" : LOGIN_USER.longitude forKey:@"mylng"];
            [params setObject:stringIsEmpty(LOGIN_USER.latitude) ? @"" : LOGIN_USER.latitude forKey:@"mylat"];
            [[MDNetWorking sharedClient] requestWithPath:URL_GET_STORE_LIST params:params httpMethod:MethodGet callback:^(BOOL rs, NSObject *obj) {
                if (rs) {
                    XLog(@"-------------%@",obj);
                }
                else{
                    [Util showErrorMessage:obj forDuration:1.0f];
                }
            }];
        }
            break;
        case CellTypeRecommend:
        {// 推荐
            
        }
            break;
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.cellType) {
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
    switch (self.cellType) {
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
    switch (self.cellType) {
        case CellTypeChannel:
        {// 频道
            return CGSizeMake(SCR_WIDTH, SCR_WIDTH + kOffPadding + 20);
        }
            break;
        case CellTypeUploadNew:
        {// 上新
            return CGSizeMake(SCR_WIDTH, 290.f);
        }
            break;
        case CellTypeRecommend:
        {// 推荐
            return CGSizeMake(SCR_WIDTH, 350.f);
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellType == CellTypeChannel) {
        //
        MDChannelDetailCtrl *vc = [[MDChannelDetailCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
    }
    else if (self.cellType == CellTypeUploadNew){
        MDTrendUploadNewPopView *popView = [[MDTrendUploadNewPopView alloc] initWithFrame:MDAPPDELEGATE.window.frame];
        [MDAPPDELEGATE.window addSubview:popView];
        [popView showView];
    }
    else if (self.cellType == CellTypeRecommend){
        MDUploadNewDetailCtrl *vc = [[MDUploadNewDetailCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        //MDRecommendDetailCtrl *vc = [[MDRecommendDetailCtrl alloc] init];
        //[MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
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
    if (_delegate && [_delegate respondsToSelector:@selector(trendChildScrollTo:)]) {
        [_delegate trendChildScrollTo:f];
    }
}

@end

