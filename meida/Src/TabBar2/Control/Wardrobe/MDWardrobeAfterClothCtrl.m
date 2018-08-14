//
//  MDWardrobeAfterClothCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeAfterClothCtrl.h"

#import "MDFlipCarFlowLayout.h"
#import "MDPageControl.h"
#import "WardrobeAfterClothCell.h"

static CGFloat kpageControlHH = 49.f;
static NSString *WardrobeAfterClothCellID = @"WardrobeAfterClothCell";

@interface MDWardrobeAfterClothCtrl ()<UICollectionViewDelegate,UICollectionViewDataSource,MDFlipCarFlowLayoutDelegate, MDPageControlDelegate>

@property (nonatomic, strong) MDPageControl         *pageControl;
@property (nonatomic, strong) MDFlipCarFlowLayout   *flowLayout;
@property (nonatomic, strong) NSMutableArray        *dataSourceArr;

@end

@implementation MDWardrobeAfterClothCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    [self setNavigationType:NavShowBackAndTitleAndRight];
    [self setTitle:@"明天 ⤵️"];
    [self setRightBtnWith:@"" image:IMAGE(@"share_icon")];
    
    _flowLayout = [[MDFlipCarFlowLayout alloc]init];
    _flowLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeaderHeight + kOffPadding, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight - kpageControlHH - kOffPadding) collectionViewLayout:_flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.decelerationRate = 0;
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.bouncesZoom = YES;
    self.collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = COLOR_WITH_WHITE;
    [self.collectionView registerClass:[WardrobeAfterClothCell class] forCellWithReuseIdentifier:WardrobeAfterClothCellID];
    
    self.pageControl = [[MDPageControl alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - kpageControlHH, SCR_WIDTH, kpageControlHH)];
    [self.view addSubview:self.pageControl];
    self.pageControl.delegate = self;
    self.pageControl.dotSize = CGSizeMake(8.f, 3.5f);
    self.pageControl.spacingBetweenDots = 10;
    self.pageControl.currentDotImage = IMAGE(@"dot_icon_red");
    self.pageControl.dotImage = IMAGE(@"dot_icon_gray");
    
    //TODO: - 测试数据
    self.dataSourceArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        if (i % 2 == 1) {
            [self.dataSourceArr addObject:@"https://pro.modao.cc/uploads3/images/1661/16612735/raw_1516357173.png"];
        }
        else{
            [self.dataSourceArr addObject:@"https://pro.modao.cc/uploads3/images/1661/16613226/raw_1516358230.png"];
        }
    }
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = self.dataSourceArr.count;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WardrobeAfterClothCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WardrobeAfterClothCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataSourceArr.count) {
        cell.urlStr = (NSString *)self.dataSourceArr[indexPath.section];
    }
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat width = ((collectionView.frame.size.width - 280) - (10 * 2)) / 2;
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, width + 10, 0, 0);
    }
    else if(section == self.dataSourceArr.count) {
        return UIEdgeInsetsMake(0, 0, 0, width + 10);
    }
    else {
        return UIEdgeInsetsMake(0, 10, 0, 0);
    }
}

- (void)MDPageControl:(MDPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    XLog(@"didSelectPageAtIndex == %ld", index);
}

- (void)scrollToItemAtIndexPath:(NSInteger)indexPath andSection:(NSInteger)section withAnimated:(BOOL)animated
{

    UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath inSection:section]];
    [self.collectionView scrollToItemAtIndexPath:attr.indexPath
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:animated];
    _flowLayout.previousOffsetX = (indexPath + section * self.dataSourceArr.count) * 290 ;
}



@end
