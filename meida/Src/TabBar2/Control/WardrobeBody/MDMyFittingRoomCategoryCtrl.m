//
//  MDMyFittingRoomCategoryCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDMyFittingRoomCategoryCtrl.h"

#import "MDAddClothMatchCtrl.h"

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
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        // 点击 第0个item 添加搭配
        MDAddClothMatchCtrl *vc = [[MDAddClothMatchCtrl alloc] init];
        [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
    }
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
@property (nonatomic, strong) UIView        *addClothView;

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
    _showImgView  = [[UIImageView alloc] init];
    _addClothView = [[UIView alloc] init];
    UIImageView *addIcon = [[UIImageView alloc] init];
    UILabel *addLbl = [[UILabel alloc] init];
    
    [self.contentView addSubview:_showImgView];
    [self.contentView addSubview:_addClothView];
    [_addClothView addSubview:addIcon];
    [_addClothView addSubview:addLbl];
    
    _showImgView.hidden  = YES;
    _addClothView.hidden = YES;
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [_addClothView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
        make.centerX.equalTo(self.addClothView);
        make.centerY.equalTo(self.addClothView).offset(-35.f);
    }];
    
    [addLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addIcon);
        make.top.equalTo(addIcon.mas_bottom).offset(kOffPadding);
    }];
    
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    addIcon.image = IMAGE(@"add_cloth_icon");
    addLbl.font = FONT_SYSTEM_NORMAL(15);
    addLbl.textColor = COLOR_HEX_STR(@"#8C959F");
    addLbl.text = @"新增搭配";
    
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16651199/raw_1516589335.png" placeholderImage:IMAGE(@"place_holer_icon")];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _showImgView.hidden  = YES;
    _addClothView.hidden = YES;
    
    if (0 == indexPath.row) {
        _addClothView.hidden = NO;
    }
    else{
        _showImgView.hidden  = NO;
    }
}

@end
