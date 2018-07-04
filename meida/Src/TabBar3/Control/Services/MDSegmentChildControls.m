//
//  MDSegmentChildControls.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDSegmentChildControls.h"
#import "MDServicesBaseSortCell.h"

static NSString *MDServicesBaseSortCellID = @"MDServicesBaseSortCell";

@interface MDSegmentChildControls ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDSegmentChildControls

/**
 *  服务器告诉 展示什么样的 cell
 */
- (instancetype)initStyle:(SegmentChildViewType )controlType
{
    if (self = [super init]) {
        switch (controlType) {
            case TypeCollectionView:
            {
                
            }
                break;
            case TypeTabeleView:
            {
                
            }
                break;
            default:
                break;
        }
    }
    return self;
}

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



@end
