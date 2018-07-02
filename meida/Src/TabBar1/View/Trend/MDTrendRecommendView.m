//
//  MDTrendRecommendView.m
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendRecommendView.h"

#pragma mark -  潮流 -> 推荐 -> view ################################################----------

static NSString *kTrendRecommendViewUserCellID    = @"MDTrendRecommendViewUserCell";
static NSString *kTrendRecommendViewContentCellID = @"MDTrendRecommendViewContentCell";

@interface MDTrendRecommendView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *listView;

@end

@implementation MDTrendRecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_listView];
    _listView.dataSource = self;
    _listView.delegate = self;
    _listView.showsVerticalScrollIndicator = NO;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listView registerClass:[MDTrendRecommendViewUserCell class] forCellReuseIdentifier:kTrendRecommendViewUserCellID];
    [_listView registerClass:[MDTrendRecommendViewContentCell class] forCellReuseIdentifier:kTrendRecommendViewContentCellID];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _listView.backgroundColor = [UIColor clearColor];
    
    MDWeakPtr(weakPtr, self);
    // 下拉刷新
    MDRefreshGifHeader *refreshHeader = [MDRefreshGifHeader headerWithRefreshingBlock:^{
        [weakPtr refreshListData];
    }];
    _listView.mj_header = refreshHeader;
    
    // 上拉加载
    MDRefreshGifFooter *refreshFooter = [MDRefreshGifFooter footerWithRefreshingBlock:^{
        [weakPtr loadMoreListData];
    }];
    _listView.mj_footer = refreshFooter;
    //[_listView.mj_header beginRefreshing];
    
}

- (void)refreshListData
{
    
}

- (void)loadMoreListData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        MDTrendRecommendViewUserCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrendRecommendViewUserCellID];
        return cell;
    }
    else{
        MDTrendRecommendViewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrendRecommendViewContentCellID];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row) {
        return 146.f;
    }
    else{
        return 350;
    }
}

@end


#pragma mark -  潮流 -> 推荐 -> user cell view ################################################----------
static NSString *MDTrendRecommendViewUserCellItemID = @"MDTrendRecommendViewUserCellItem";
@interface MDTrendRecommendViewUserCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView      *userListView;

@end

@implementation MDTrendRecommendViewUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 15.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = padding;
    flowLayout.minimumLineSpacing = padding;
    flowLayout.itemSize = CGSizeMake(80.f, 135.f);
    
    _userListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _userListView.delegate   = self;
    _userListView.dataSource = self;
    _userListView.backgroundColor = COLOR_WITH_WHITE;
    _userListView.showsVerticalScrollIndicator   = NO;
    _userListView.showsHorizontalScrollIndicator = NO;
    _userListView.scrollEnabled = YES;
    [_userListView registerClass:[MDTrendRecommendViewUserCellItem class] forCellWithReuseIdentifier:MDTrendRecommendViewUserCellItemID];
    [self.contentView addSubview:_userListView];
    [_userListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10.f);
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDTrendRecommendViewUserCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendRecommendViewUserCellItemID forIndexPath:indexPath];
    return cell;
}
#pragma mark - collectionView DelegateFlowLayout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
    CGFloat itemTotalWitdh = (numberOfItems * collectionView.height) + (numberOfItems - 1) * 5.f;
    if (itemTotalWitdh >= SCR_WIDTH) return UIEdgeInsetsMake(0, 15, 0, 15) ;
    CGFloat combinedItemWidth = (numberOfItems * collectionView.height) + ((numberOfItems - 1) * 5);
    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth) * 0.5 ;
    return UIEdgeInsetsMake(0, padding, 0, padding);
}

@end

@interface MDTrendRecommendViewUserCellItem ()

@property (nonatomic, strong) UIImageView       *userHeadIcon;
@property (nonatomic, strong) UILabel           *userNickLbl;
@property (nonatomic, strong) UIButton          *followUserBtn;

@end

@implementation MDTrendRecommendViewUserCellItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.contentView.backgroundColor   = COLOR_WITH_WHITE;
    self.contentView.layer.borderColor = kDefaultBorderColor.CGColor;
    self.contentView.layer.borderWidth = 1.f;
    
    _userHeadIcon  = [[UIImageView alloc] init];
    _userNickLbl   = [[UILabel alloc] init];
    _followUserBtn = [[UIButton alloc] init];
    
    [self.contentView addSubview:_userHeadIcon];
    [self.contentView addSubview:_userNickLbl];
    [self.contentView addSubview:_followUserBtn];
    
    [_userHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15.f);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
    }];
    [_userNickLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_userHeadIcon.mas_bottom).offset(5.f);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    [_followUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_userNickLbl.mas_bottom).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
        make.centerX.equalTo(self.contentView);
    }];
    _userHeadIcon.layer.cornerRadius  = 50 * 0.5f;
    _userHeadIcon.layer.masksToBounds = YES;
    _userNickLbl.font = FONT_SYSTEM_NORMAL(11);
    _userNickLbl.textColor = kDefaultTitleColor;
    _userNickLbl.text = @"令狐冲";
    _userNickLbl.textAlignment = NSTextAlignmentCenter;
    _followUserBtn.backgroundColor = COLOR_HEX_STR(@"#0D0D0D");
    [_followUserBtn setTitleColor:COLOR_WITH_WHITE forState:UIControlStateNormal];
    [_followUserBtn setTitle:@"+关注她" forState:UIControlStateNormal];
    _followUserBtn.titleLabel.font = FONT_SYSTEM_NORMAL(11);
    _followUserBtn.layer.cornerRadius  = 5.f;
    _followUserBtn.layer.masksToBounds = YES;
    
    [_userHeadIcon sd_setImageWithURL:[NSURL URLWithString:@"https://pro.modao.cc/uploads3/images/1665/16650324/raw_1516588548.png"] placeholderImage:IMAGE(@"navi_right_icon")];
    
}

@end


#pragma mark -  潮流 -> 推荐 -> content cell view ################################################----------
static NSString *MDTrendRecommendViewContentCellItemID = @"MDTrendRecommendViewContentCellItem";
@interface MDTrendRecommendViewContentCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView        *sepLineView;       /**< 分割线 */

@property (nonatomic, strong) UIView        *headContentView;   /**< 顶部view：昵称 信息 关注 容器 */
@property (nonatomic, strong) UIImageView   *userHeadIcon;
@property (nonatomic, strong) UILabel       *nickNameLbl;
@property (nonatomic, strong) UILabel       *otherInfoLbl;
@property (nonatomic, strong) UILabel       *timeTipsLbl;
@property (nonatomic, strong) UIButton      *followUserBtn;

@property (nonatomic, strong) UILabel       *contentdescLbl;    /**< 内容描述 */
@property (nonatomic, strong) UICollectionView  *contentPicsView;   /**< 滚动图 */

@property (nonatomic, strong) UIView        *footerContentView; /**< 点赞 评论 分享 */
@property (nonatomic, strong) UIButton      *praiseBtn;
@property (nonatomic, strong) UIButton      *commentBtn;
@property (nonatomic, strong) UIButton      *shareBtn;

@end

@implementation MDTrendRecommendViewContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    _sepLineView = [[UIView alloc] init];
    [self.contentView addSubview:_sepLineView];
    _sepLineView.backgroundColor = kDefaultBackgroundColor;
    [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 10.f));
        make.centerX.equalTo(self.contentView);
    }];
    
    //1. head view
    _headContentView = [[UIView alloc] init];
    _userHeadIcon    = [[UIImageView alloc] init];
    _nickNameLbl     = [[UILabel alloc] init];
    _otherInfoLbl    = [[UILabel alloc] init];
    _timeTipsLbl     = [[UILabel alloc] init];
    _followUserBtn   = [[UIButton alloc] init];
    
    [self.contentView addSubview:_headContentView];
    [_headContentView addSubview:_userHeadIcon];
    [_headContentView addSubview:_nickNameLbl];
    [_headContentView addSubview:_otherInfoLbl];
    [_headContentView addSubview:_timeTipsLbl];
    [_headContentView addSubview:_followUserBtn];
    
    [_headContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_sepLineView.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 2 * koffset, 80.f));
    }];
    [_userHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
        make.centerY.equalTo(self->_headContentView);
        make.left.equalTo(self->_headContentView);
    }];
    [_nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_userHeadIcon);
        make.left.equalTo(self->_userHeadIcon.mas_right).offset(5.f);
    }];
    [_otherInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_userHeadIcon);
        make.left.equalTo(self->_nickNameLbl);
    }];
    [_timeTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_nickNameLbl);
        make.bottom.equalTo(self->_userHeadIcon);
    }];
    [_followUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
        make.right.equalTo(self->_headContentView);
        make.centerY.equalTo(self->_otherInfoLbl);
    }];
    
    _headContentView.backgroundColor = COLOR_WITH_WHITE;
    _userHeadIcon.layer.cornerRadius = 50 * 0.5f;
    _userHeadIcon.layer.masksToBounds = YES;
    _nickNameLbl.font = FONT_SYSTEM_NORMAL(11);
    _nickNameLbl.text = @"令狐冲";
    _nickNameLbl.textColor = kDefaultTitleColor;
    _otherInfoLbl.font = FONT_SYSTEM_NORMAL(10);
    _otherInfoLbl.textColor = kDefaultTitleColor;
    _otherInfoLbl.text = @"身高190cm | 血压 210 | 这件衣服";
    _timeTipsLbl.font = FONT_SYSTEM_NORMAL(10);
    _timeTipsLbl.textColor = kDefaultThirdTitleColor;
    _timeTipsLbl.text = @"刚刚";
    
    _followUserBtn.backgroundColor = RED;
    [_followUserBtn setTitleColor:COLOR_WITH_WHITE forState:UIControlStateNormal];
    [_followUserBtn setTitle:@"+关注她" forState:UIControlStateNormal];
    _followUserBtn.titleLabel.font = FONT_SYSTEM_NORMAL(11);
    _followUserBtn.layer.cornerRadius  = 5.f;
    _followUserBtn.layer.masksToBounds = YES;
    [_userHeadIcon sd_setImageWithURL:[NSURL URLWithString:@"https://pro.modao.cc/uploads3/images/1665/16650324/raw_1516588548.png"] placeholderImage:IMAGE(@"navi_right_icon")];
    
    //2. 图片scroll
    _contentdescLbl = [[UILabel alloc] init];
    [self.contentView addSubview:_contentdescLbl];
    [_contentdescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_headContentView.mas_bottom);
        make.left.equalTo(self.contentView).offset(koffset);
        make.right.equalTo(self.contentView).offset(-koffset);
    }];
    
    UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 15.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = padding;
    flowLayout.minimumLineSpacing = padding;
    flowLayout.itemSize = CGSizeMake(160.f, 160.f);
    
    _contentPicsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _contentPicsView.delegate   = self;
    _contentPicsView.dataSource = self;
    _contentPicsView.backgroundColor = COLOR_WITH_WHITE;
    _contentPicsView.showsVerticalScrollIndicator   = NO;
    _contentPicsView.showsHorizontalScrollIndicator = NO;
    _contentPicsView.scrollEnabled = YES;
    [_contentPicsView registerClass:[MDTrendRecommendViewContentCellItem class] forCellWithReuseIdentifier:MDTrendRecommendViewContentCellItemID];
    [self.contentView addSubview:_contentPicsView];
    [_contentPicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_contentdescLbl.mas_bottom).offset(koffset);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-44.f);
    }];
    
    _contentdescLbl.font = FONT_SYSTEM_NORMAL(11);
    _contentdescLbl.textColor = kDefaultTitleColor;
    _contentdescLbl.numberOfLines = 2;
    _contentdescLbl.text = @"我这个瘦子应该怎么办? 穿出来都没有什么范儿。可怜了我的这个价值不菲的大衣，呜呜呜呜~~~~";
    //3. footer view
    _footerContentView = [[UIView alloc] init];
    _praiseBtn  = [[UIButton alloc] init];
    _commentBtn = [[UIButton alloc] init];
    _shareBtn   = [[UIButton alloc] init];
    
    [self.contentView addSubview:_footerContentView];
    [_footerContentView addSubview:_praiseBtn];
    [_footerContentView addSubview:_commentBtn];
    [_footerContentView addSubview:_shareBtn];
    
    [_footerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 44.f));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_footerContentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH / 3, 44.f));
        make.centerY.equalTo(self->_footerContentView);
    }];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_praiseBtn);
        make.right.equalTo(self->_shareBtn);
        make.centerY.equalTo(self->_footerContentView);
        make.height.mas_equalTo(44.f);
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_footerContentView);
        make.height.mas_equalTo(44.f);
        make.centerY.equalTo(self->_footerContentView);
        make.width.equalTo(self->_praiseBtn);
    }];
    
    CGFloat offset = 10.f;
    _praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _praiseBtn.titleLabel.bounds.size.width + offset, 0, -_praiseBtn.titleLabel.bounds.size.width);
    _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _commentBtn.titleLabel.bounds.size.width + offset, 0, -_commentBtn.titleLabel.bounds.size.width);
    _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _shareBtn.titleLabel.bounds.size.width + offset, 0, -_shareBtn.titleLabel.bounds.size.width);
    
    [_praiseBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    [_commentBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    [_shareBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    
    [_praiseBtn setTitle:@"1000" forState:UIControlStateNormal];
    [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    
    [_praiseBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [_commentBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [_shareBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    
    _praiseBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    _commentBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    _shareBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDTrendRecommendViewContentCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendRecommendViewContentCellItemID forIndexPath:indexPath];
    return cell;
}
#pragma mark - collectionView DelegateFlowLayout

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
    CGFloat itemTotalWitdh = (numberOfItems * collectionView.height) + (numberOfItems - 1) * 5.f;
    if (itemTotalWitdh >= SCR_WIDTH) return UIEdgeInsetsMake(0, 15, 0, 15) ;
    CGFloat combinedItemWidth = (numberOfItems * collectionView.height) + ((numberOfItems - 1) * 5);
    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth) * 0.5 ;
    return UIEdgeInsetsMake(0, padding, 0, padding);
}

@end


@interface MDTrendRecommendViewContentCellItem ()

@end

@implementation MDTrendRecommendViewContentCellItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"https://pro.modao.cc/uploads3/images/1665/16650985/raw_1516589142.png"] placeholderImage:IMAGE(@"navi_right_icon")];
    
}

@end



