//
//  MDWardrobeControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeControl.h"

#import "MDWardrobeViewCell.h"

static NSString *MDWardrobeViewCellID = @"MDWardrobeViewCell";
static NSString *WardrobeAfterClothHeadViewID   = @"WardrobeAfterClothHeadView";
static NSString *WardrobeAfterClothFooterViewID = @"WardrobeAfterClothFooterView";
@interface MDWardrobeControl ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDWardrobeControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self initView];
    
}

- (void)initView
{
    // 设置头部信息
    [self setNavigationType:NavShowTitleAndRiht];
    [self setTitle:@"衣橱"];
    [self setRightBtnWith:@"" image:IMAGE(@"navi_right_icon")];
    [self setupLineView:NO];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kOffPadding, kOffPadding, 0, kOffPadding);
    layout.minimumLineSpacing = kOffPadding;
    layout.minimumInteritemSpacing = kOffPadding;
    CGFloat itemWW = (SCR_WIDTH - 3 * kOffPadding) / 2;
    layout.itemSize = CGSizeMake(itemWW, itemWW);
    layout.footerReferenceSize = CGSizeMake(SCR_WIDTH, 100);
    layout.headerReferenceSize = CGSizeMake(SCR_WIDTH, 50);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight - kTabBarHeight) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = kDefaultBackgroundColor;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = COLOR_WITH_WHITE;
    [self.collectionView registerClass:[MDWardrobeViewCell class] forCellWithReuseIdentifier:MDWardrobeViewCellID];
    [self.collectionView registerClass:[WardrobeAfterClothHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WardrobeAfterClothHeadViewID];
    [self.collectionView registerClass:[WardrobeAfterClothFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WardrobeAfterClothFooterViewID];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDWardrobeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDWardrobeViewCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // headView
        WardrobeAfterClothHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WardrobeAfterClothHeadViewID forIndexPath:indexPath];
        return headView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        // footView
        WardrobeAfterClothFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WardrobeAfterClothFooterViewID forIndexPath:indexPath];
        return footerView;
    }
    return nil;
    
}

@end
