//
//  MDAddClothMatchCell.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDAddClothMatchCell.h"

#import "MDAddClothTagModel.h"

#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 Camera cell #############################################----------
@interface MDAddClothMatchCameraCell ()

@property (nonatomic, strong) UIImageView   *showImgView;
@property (nonatomic, strong) UIButton      *addBtnView;

@end

@implementation MDAddClothMatchCameraCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _showImgView = [[UIImageView alloc] init];
    _addBtnView  = [[UIButton alloc] init];
    UIView *lineView = [[UIView alloc] init];
    
    [self.contentView addSubview:_showImgView];
    [self.contentView addSubview:_addBtnView];
    [self.contentView addSubview:lineView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, SCR_WIDTH));
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    [_addBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, SCR_WIDTH));
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 1.f));
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [_addBtnView setImage:IMAGE(@"camera_icon") forState:UIControlStateNormal];
    [_addBtnView setTitle:@"拍下您的新搭配" forState:UIControlStateNormal];
    [_addBtnView setTitleColor:COLOR_HEX_STR(@"#8C959F") forState:UIControlStateNormal];
    _addBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(15);
    _addBtnView.userInteractionEnabled = NO;
    CGFloat offset = 25.f;
    _addBtnView.titleEdgeInsets = UIEdgeInsetsMake(_addBtnView.imageView.height + offset, -_addBtnView.imageView.width, 55,0);
    _addBtnView.imageEdgeInsets = UIEdgeInsetsMake(0, _addBtnView.titleLabel.width/2, _addBtnView.titleLabel.height + 85, -_addBtnView.titleLabel.width/2);
    lineView.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
    _showImgView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setShootImg:(UIImage *)shootImg
{
    if (!shootImg) return;
    _shootImg = shootImg;
    _addBtnView.hidden = _shootImg;
    _showImgView.image = _shootImg;
}

@end



#pragma mark -  衣橱 -> 我的衣橱 -> 搭配物件 cell         #############################################----------
static NSString *MDAddClothMatchObjCellItemID = @"MDAddClothMatchObjCellItem";

@interface MDAddClothMatchObjCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel           *titleLblView;
@property (nonatomic, strong) UICollectionView  *collectionView;

@end

@implementation MDAddClothMatchObjCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 1. 标题
    _titleLblView   = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLblView];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.top.equalTo(self.contentView).offset(kOffset);
    }];
    _titleLblView.font = FONT_SYSTEM_BOLD(12);
    _titleLblView.textColor = kDefaultTitleColor;
    _titleLblView.text = @"搭配物件";
    
    // 2.1 flowLayout
    NSInteger cellNum = 0;
    if (SCR_WIDTH >= 375){
        cellNum = 6;
    }
    else if (SCR_WIDTH >= 320){
        cellNum = 5;
    }
    CGFloat margin = 10;
    CGFloat itemW = (SCR_WIDTH - (cellNum + 1) * margin) / cellNum;
    CGFloat itemH = 40.f;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    
    [_collectionView registerClass:[MDAddClothMatchObjCellItem class] forCellWithReuseIdentifier:MDAddClothMatchObjCellItemID];
    
    // 设置collectionView
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLblView.mas_bottom).offset(5.f);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    //3. 分割线
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 1.f));
    }];
    lineView.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectionView reloadData];
}

@end

@interface MDAddClothMatchObjCellItem ()

@end

@implementation MDAddClothMatchObjCellItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = [UIColor orangeColor];
}

@end




#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 tags 场所&天气 cell #############################################----------
static NSString *MDAddClothMatchTagCellItemID = @"MDAddClothMatchTagCellItem";
@interface MDAddClothMatchTagCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel           *titleLblView;
@property (nonatomic, strong) UICollectionView  *collectionView;

@end

@implementation MDAddClothMatchTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 1. 标题
    _titleLblView   = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLblView];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.top.equalTo(self.contentView).offset(kOffset);
    }];
    _titleLblView.font = FONT_SYSTEM_BOLD(12);
    _titleLblView.textColor = kDefaultTitleColor;
    _titleLblView.text = @"搭配物件";
    
    // 2.1 flowLayout
    NSInteger cellNum = 0;
    if (SCR_WIDTH >= 375){
        cellNum = 6;
    }
    else if (SCR_WIDTH >= 320){
        cellNum = 5;
    }
    CGFloat margin = 10;
    CGFloat itemW = (SCR_WIDTH - (cellNum + 1) * margin) / cellNum;
    CGFloat itemH = 40.f;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    
    [_collectionView registerClass:[MDAddClothMatchTagCellItem class] forCellWithReuseIdentifier:MDAddClothMatchTagCellItemID];
    
    // 设置collectionView
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLblView.mas_bottom).offset(5.f);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    self.groupTag = [[MDAddClothGroupTagModel alloc] init];
    self.groupTag.tagsArr = [NSMutableArray array];
    for (int i = 0 ; i < 10; ++i) {
        MDAddClothTagModel *model = [[MDAddClothTagModel alloc] init];
        model.name = [NSString stringWithFormat:@"选择%u",i];
        model.isSelected = NO;
        [self.groupTag.tagsArr addObject:model];
    }
    [_collectionView reloadData];
    
    //3. 分割线
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 1.f));
    }];
    lineView.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupTag.tagsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.groupTag.tagsArr.count) {
        MDAddClothMatchTagCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDAddClothMatchTagCellItemID forIndexPath:indexPath];
        cell.tagModel = self.groupTag.tagsArr[indexPath.row];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (MDAddClothTagModel *model  in self.groupTag.tagsArr) {
        model.isSelected = NO;
    }
    MDAddClothTagModel *tagModel = self.groupTag.tagsArr[indexPath.row];
    tagModel.isSelected = YES;
    [_collectionView reloadData];
}

@end

@interface MDAddClothMatchTagCellItem ()

@property (nonatomic, strong) UILabel   *titleLblview;

@end

@implementation MDAddClothMatchTagCellItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = COLOR_WITH_WHITE;
    _titleLblview = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLblview];
    [_titleLblview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).inset(5.f);
    }];
    _titleLblview.font = FONT_SYSTEM_NORMAL(14);
    _titleLblview.textAlignment = NSTextAlignmentCenter;
    _titleLblview.layer.cornerRadius  = 4.f;
    _titleLblview.layer.masksToBounds = YES;
}

- (void)setTagModel:(MDAddClothTagModel *)tagModel
{
    if (!tagModel) return;
    
    _tagModel = tagModel;
    _titleLblview.text = _tagModel.name;
    
    if (_tagModel.isSelected) {
        _titleLblview.backgroundColor = COLOR_HEX_STR(@"#FEEA8D");
        _titleLblview.textColor = kDefaultTitleColor;
    }
    else{
        _titleLblview.backgroundColor = COLOR_WITH_WHITE;
        _titleLblview.textColor = COLOR_HEX_STR(@"#8C959F");
    }
}

@end



