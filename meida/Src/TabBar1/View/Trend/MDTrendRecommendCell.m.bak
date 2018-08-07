//
//  MDTrendRecommendCell.m
//  meida
//
//  Created by ToTo on 2018/7/20.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendRecommendCell.h"

static NSString *MDTrendRecommendCellItemCellID = @"MDTrendRecommendCellItemCell";

@interface MDTrendRecommendCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

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

@implementation MDTrendRecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    _sepLineView = [[UIView alloc] init];
    [self.contentView addSubview:_sepLineView];
    _sepLineView.backgroundColor = kDefaultBackgroundColor;
    [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
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
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 2 * kOffPadding, 80.f));
    }];
    [_userHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
        make.centerY.equalTo(self.headContentView);
        make.left.equalTo(self.headContentView);
    }];
    [_nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userHeadIcon);
        make.left.equalTo(self.userHeadIcon.mas_right).offset(5.f);
    }];
    [_otherInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeadIcon);
        make.left.equalTo(self.nickNameLbl);
    }];
    [_timeTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLbl);
        make.bottom.equalTo(self.userHeadIcon);
    }];
    [_followUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
        make.right.equalTo(self.headContentView);
        make.centerY.equalTo(self.otherInfoLbl);
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
    [_userHeadIcon imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650324/raw_1516588548.png" placeholderImage:IMAGE(@"navi_right_icon")];
    
    //2. 图片scroll
    _contentdescLbl = [[UILabel alloc] init];
    [self.contentView addSubview:_contentdescLbl];
    [_contentdescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headContentView.mas_bottom);
        make.left.equalTo(self.contentView).offset(kOffPadding);
        make.right.equalTo(self.contentView).offset(-kOffPadding);
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
    [_contentPicsView registerClass:[MDTrendRecommendCellItemCell class] forCellWithReuseIdentifier:MDTrendRecommendCellItemCellID];
    [self.contentView addSubview:_contentPicsView];
    [_contentPicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentdescLbl.mas_bottom).offset(kOffPadding);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-54.f);
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
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 49.f));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentPicsView.mas_bottom);
    }];
    
    [_praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerContentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH / 3, 44.f));
        make.centerY.equalTo(self.footerContentView).offset(-2.5);
    }];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseBtn);
        make.right.equalTo(self.shareBtn);
        make.centerY.equalTo(self.praiseBtn).offset(-2.5);
        make.height.mas_equalTo(44.f);
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footerContentView);
        make.height.mas_equalTo(44.f);
        make.centerY.equalTo(self.praiseBtn).offset(-2.5);
        make.width.equalTo(self.praiseBtn);
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
    MDTrendRecommendCellItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendRecommendCellItemCellID forIndexPath:indexPath];
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


@interface MDTrendRecommendCellItemCell ()

@end

@implementation MDTrendRecommendCellItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    [_imageView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650985/raw_1516589142.png" placeholderImage:IMAGE(@"navi_right_icon")];
    
}

@end



//#pragma mark -  潮流 -> 推荐 -> user cell view ################################################----------
//static NSString *MDTrendRecommendViewUserCellItemID = @"MDTrendRecommendViewUserCellItem";
//@interface MDTrendRecommendViewUserCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
//
//@property (nonatomic, strong) UICollectionView      *userListView;
//
//@end
//
//@implementation MDTrendRecommendViewUserCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self initView];
//    }
//    return self;
//}
//
//- (void)initView
//{
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = COLOR_WITH_WHITE;
//    
//    UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat padding = 15.f;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumInteritemSpacing = padding;
//    flowLayout.minimumLineSpacing = padding;
//    flowLayout.itemSize = CGSizeMake(80.f, 135.f);
//    
//    _userListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//    _userListView.delegate   = self;
//    _userListView.dataSource = self;
//    _userListView.backgroundColor = COLOR_WITH_WHITE;
//    _userListView.showsVerticalScrollIndicator   = NO;
//    _userListView.showsHorizontalScrollIndicator = NO;
//    _userListView.scrollEnabled = YES;
//    [_userListView registerClass:[MDTrendRecommendViewUserCellItem class] forCellWithReuseIdentifier:MDTrendRecommendViewUserCellItemID];
//    [self.contentView addSubview:_userListView];
//    [_userListView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView).offset(-20.f);
//    }];
//    UIView *sepLineView = [[UIView alloc] init];
//    [self.contentView addSubview:sepLineView];
//    [sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH, 10.f));
//        make.bottom.equalTo(self.contentView);
//        make.centerX.equalTo(self.contentView);
//    }];
//    sepLineView.backgroundColor = kDefaultBackgroundColor;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    MDTrendRecommendViewUserCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDTrendRecommendViewUserCellItemID forIndexPath:indexPath];
//    return cell;
//}
//#pragma mark - collectionView DelegateFlowLayout
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
//    CGFloat itemTotalWitdh = (numberOfItems * collectionView.height) + (numberOfItems - 1) * 5.f;
//    if (itemTotalWitdh >= SCR_WIDTH) return UIEdgeInsetsMake(0, 15, 0, 15) ;
//    CGFloat combinedItemWidth = (numberOfItems * collectionView.height) + ((numberOfItems - 1) * 5);
//    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth) * 0.5 ;
//    return UIEdgeInsetsMake(0, padding, 0, padding);
//}
//
//@end
//
//@interface MDTrendRecommendViewUserCellItem ()
//
//@property (nonatomic, strong) UIImageView       *userHeadIcon;
//@property (nonatomic, strong) UILabel           *userNickLbl;
//@property (nonatomic, strong) UIButton          *followUserBtn;
//
//@end
//
//@implementation MDTrendRecommendViewUserCellItem
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self initView];
//    }
//    return self;
//}
//
//- (void)initView
//{
//    self.contentView.backgroundColor   = COLOR_WITH_WHITE;
//    self.contentView.layer.borderColor = kDefaultBorderColor.CGColor;
//    self.contentView.layer.borderWidth = 1.f;
//    
//    _userHeadIcon  = [[UIImageView alloc] init];
//    _userNickLbl   = [[UILabel alloc] init];
//    _followUserBtn = [[UIButton alloc] init];
//    
//    [self.contentView addSubview:_userHeadIcon];
//    [self.contentView addSubview:_userNickLbl];
//    [self.contentView addSubview:_followUserBtn];
//    
//    [_userHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(15.f);
//        make.centerX.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
//    }];
//    [_userNickLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userHeadIcon.mas_bottom).offset(5.f);
//        make.centerX.equalTo(self.contentView);
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//    }];
//    [_followUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userNickLbl.mas_bottom).offset(10.f);
//        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
//        make.centerX.equalTo(self.contentView);
//    }];
//    _userHeadIcon.layer.cornerRadius  = 50 * 0.5f;
//    _userHeadIcon.layer.masksToBounds = YES;
//    _userNickLbl.font = FONT_SYSTEM_NORMAL(11);
//    _userNickLbl.textColor = kDefaultTitleColor;
//    _userNickLbl.text = @"令狐冲";
//    _userNickLbl.textAlignment = NSTextAlignmentCenter;
//    _followUserBtn.backgroundColor = COLOR_HEX_STR(@"#0D0D0D");
//    [_followUserBtn setTitleColor:COLOR_WITH_WHITE forState:UIControlStateNormal];
//    [_followUserBtn setTitle:@"+关注她" forState:UIControlStateNormal];
//    _followUserBtn.titleLabel.font = FONT_SYSTEM_NORMAL(11);
//    _followUserBtn.layer.cornerRadius  = 5.f;
//    _followUserBtn.layer.masksToBounds = YES;
//    
//    [_userHeadIcon imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650324/raw_1516588548.png" placeholderImage:IMAGE(@"navi_right_icon")];
//    
//}
//
//@end

