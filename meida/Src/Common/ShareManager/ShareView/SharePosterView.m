//
//  SharePosterView.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "SharePosterView.h"
#import "ShareManager.h"

#define ShareViewCellID @"ShareViewCellID"

@interface SharePosterView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSString *sourceType;       /**< 分享来源类型（goods：商品、vip:会员） */
    CGFloat  customView_H;      /**< 自定义view高度 */
    CGFloat  shareBottomView_H; /**< 底部自定义View+分享平台View高度 */
}
@property (nonatomic, strong) MDShareInfoModel  *model;
@property (nonatomic, strong) UIView            *bgView;            /**< 黑色半透明View */
@property (nonatomic, strong) UIImageView       *posterView;        /**< 海报缩略图 */
@property (nonatomic, strong) UIView            *bottomBgView;      /**< 底部 附加View + 分享平台View */
@property (nonatomic, strong) UIView            *extraView;         /**< 附加View */
@property (nonatomic, strong) UICollectionView  *platformView;      /**< 分享平台View */
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSArray           *platformArray;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign, readonly) BOOL    isSharePoster;      /**< 标记是否分享海报 默认：YES */
@property (nonatomic, strong) UIView            *customView;        /**< 分享平台上面的自定义view */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation SharePosterView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPlatformsArray:(NSArray *)platforms shareInfoModel:(MDShareInfoModel *)model
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
        _platformArray = platforms;
        _dataArray = [NSMutableArray array];
        _isSharePoster = YES;
        _model = model;
        
        [self initData];
        
        // 配置自定义view到 分享页面
        [self initCustomViewWithView:model.customView];
        
        [self initView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroundNotification) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)appDidEnterBackgroundNotification
{
    [self dismiss];
}


- (void)initData
{
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    
    for (int i = 0; i < _platformArray.count; i++ ) {
        NSString *platform = _platformArray[i];
        if (![platform isKindOfClass:[NSString class]]) {
            continue;
        }
        if ([platform isEqualToString:ShareManagerToQQ] || [platform isEqualToString:ShareManagerToQzone])  {
            if ([QQApiInterface isQQInstalled]) {
                [_dataArray addObject:platform];
            }
            continue;
        }
        if ([platform isEqualToString:ShareManagerToWechatSession] || [platform isEqualToString:ShareManagerToWechatTimeline]) {
            if ([WXApi isWXAppInstalled]) {
                [_dataArray addObject:platform];
            }
            continue;
        }
        [_dataArray addObject:platform];
    }
    
    [_platformView reloadData];
}

// 根据传入的model 添加自定义view
- (void)initCustomViewWithView:(UIView *)customView
{
    if (_model.shareViewType == ShareViewTypePosterGoods) {
        sourceType = @"goods";
        _customView = customView;
        customView_H = customView.height;
    }
    else if (_model.shareViewType == ShareViewTypePosterVip) {
        sourceType = @"vip";
        _customView = [self getHeaderCellViewWithTitle:@"发布邀请海报"];
        customView_H = 60.f;
    }
    shareBottomView_H = SCR_WIDTH * 0.31f + customView_H;
}

- (void)initView
{
    _bgView = [UIView newAutoLayoutView];
    _bgView.backgroundColor = [COLOR_WITH_BLACK colorWithAlphaComponent:0.7f];
    [self addSubview:_bgView];
    [_bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_bgView addGestureRecognizer:tap];
    
    //CGFloat posterView_W = SCR_WIDTH - 120.f;
    CGFloat posterView_W = SCR_WIDTH * 0.68f;
    _posterView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, SCR_HEIGHT, posterView_W, posterView_W*1.582f)];
    //_posterView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, SCR_HEIGHT, posterView_W, SCR_HEIGHT)];
    //_posterView.image = IMAGE(@"image0");
    _posterView.centerX = SCR_WIDTH/2.f;
    //_posterView.contentMode = UIViewContentModeBottom;
    [self addSubview:_posterView];
    [self getPosterImage];
    //_posterView.height = posterView_W * (_posterView.image.size.height/_posterView.image.size.width);

    
    _bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, shareBottomView_H)];
    _bottomBgView.backgroundColor = COLOR_WITH_WHITE;
    [self addSubview:_bottomBgView];
    
    if (_customView) {
        _customView.frame = CGRectMake(0, 0, SCR_WIDTH, customView_H);
        [_bottomBgView addSubview:_customView];
    }
    
    CGFloat item_H = SCR_WIDTH * 0.31f;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //_flowLayout.itemSize = CGSizeMake(SCR_WIDTH / _dataArray.count, SCR_WIDTH * 0.31f);
    _flowLayout.itemSize = CGSizeMake(SCR_WIDTH / 5.f - 6.5f, item_H);
    _flowLayout.minimumLineSpacing = 0.f;
    _flowLayout.minimumInteritemSpacing = 0.f;
    //_flowLayout.headerReferenceSize = CGSizeMake(SCR_WIDTH, customView_H);
    
    //_flowLayout.footerReferenceSize = CGSizeMake(SCR_WIDTH, 60);
    //_flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _platformView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, customView_H, SCR_WIDTH, item_H) collectionViewLayout:_flowLayout];
    _platformView.backgroundColor = COLOR_WITH_WHITE;
    _platformView.showsVerticalScrollIndicator = NO;
    _platformView.showsHorizontalScrollIndicator = NO;
    _platformView.delegate = self;
    _platformView.dataSource = self;
    [_bottomBgView addSubview:_platformView];
    
    [_platformView registerClass:[SharePosterViewCell class] forCellWithReuseIdentifier:ShareViewCellID];
    //[_platformView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCellID"];
    //[_platformView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCellID"];
}

- (void)indicatorViewStartAnimating
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.center = CGPointMake(SCR_WIDTH/2.f, SCR_HEIGHT/2.f-30.f);
        _indicatorView.color = RED;
        [self addSubview:_indicatorView];
    }
    [_indicatorView startAnimating];
}

- (void)getPosterImage
{
    if (_model.posterThumData) {
        _posterView.image = [UIImage imageWithData:_model.posterThumData];
        _posterView.height = _posterView.width * _model.posterThumImgH_W;
    }
    else {
        MDWeakPtr(weakPtr, self);
        [self indicatorViewStartAnimating];
        [_posterView imageWithUrlStr:_model.poster_thum_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakPtr.indicatorView stopAnimating];
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
                weakPtr.model.posterThumData = imageData;
                weakPtr.model.posterThumImgH_W = image.size.height/image.size.width;
                weakPtr.posterView.height = weakPtr.posterView.width * weakPtr.model.posterThumImgH_W;
                weakPtr.posterView.y = SCR_HEIGHT - self->shareBottomView_H;
                weakPtr.posterView.alpha = 0.f;
                [UIView animateWithDuration:0.3f animations:^{
                    weakPtr.posterView.y = SCR_HEIGHT - self->shareBottomView_H - weakPtr.posterView.height;
                    weakPtr.posterView.alpha = 1.f;
                }];
            }
        }];
    }
}

#pragma mark - 内部方法 -
- (void)tapAction
{
    [self dismiss];
}

#pragma mark - 展示分享海报样式 -
- (void)show
{
    [MDAPPDELEGATE.window addSubview:self];
    _bottomBgView.frame = CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, shareBottomView_H);
    _posterView.alpha = 0.f;
    [UIView animateWithDuration:0.3f animations:^{
        _bottomBgView.y = SCR_HEIGHT - shareBottomView_H;
        _posterView.y = SCR_HEIGHT - shareBottomView_H - _posterView.height;
        _posterView.alpha = 1.f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        _bottomBgView.y = SCR_HEIGHT;
        _posterView.y = SCR_HEIGHT;
        _posterView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_dismissBlock) {
            _dismissBlock();
        }
    }];
}

#pragma mark - 展示普通分享样式 -
//点击分享链接更换分享样式
- (void)tapShareLinkAction
{
    _isSharePoster = NO;
    if ([_indicatorView isAnimating]) {
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
    }
    [UIView animateWithDuration:0.3f animations:^{
        _bottomBgView.y = SCR_HEIGHT;
        _posterView.y = SCR_HEIGHT;
        _posterView.alpha = 0;
    } completion:^(BOOL finished) {
        [_posterView removeFromSuperview];
        if (_model.shareViewType == ShareViewTypePosterVip) {
            [_customView removeFromSuperview];
            _customView = [self getHeaderCellViewWithTitle:@"分享到"];
            [_bottomBgView addSubview:_customView];
        }
        [self showShareLinkView];
    }];
}

//展示文案分享样式
- (void)showShareLinkView
{
    NSArray *allPlatform = @[ShareManagerToWechatSession, ShareManagerToWechatTimeline, ShareManagerToSina, ShareManagerToQQ, ShareManagerToQzone];
    _platformArray = allPlatform;
    [self initData];
    
    _bottomBgView.frame = CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, shareBottomView_H);
    
    [UIView animateWithDuration:0.3f animations:^{
        _bottomBgView.y = SCR_HEIGHT - shareBottomView_H;
        
    }];
}

#pragma mark - UICollectionViewDataSource -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SharePosterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShareViewCellID forIndexPath:indexPath];
    if (indexPath.item < _dataArray.count) {
        cell.platformName = _dataArray[indexPath.item];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *platform = _dataArray[indexPath.item];
    if ([platform isEqualToString:ShareManagerShareLink]) {
        //展示普通分享（卡片样式）
        [self tapShareLinkAction];
    }
    else {
        if (_isSharePoster) {
            if (!_model.posterThumData || !_model.posterData) {
                [Util showMessage:@"正在获取海报" forDuration:1.5f inView:MDAPPDELEGATE.window];
                return;
            }
        }
        
        if (_SharePlatformSeletedBlock) {
            _SharePlatformSeletedBlock(platform, _isSharePoster);
        }
        if (![platform isEqualToString:ShareManagerSavePoster]) {
            [self dismiss];
        }
    }
}


- (UIView *)getHeaderCellViewWithTitle:(NSString *)title
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCR_WIDTH, customView_H);
    headerView.backgroundColor = COLOR_WITH_WHITE;
    
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.font = FONT_SYSTEM_NORMAL(14.f);
    titleLabel.textColor = COLOR_WITH_YELLOW;
    titleLabel.text = title;
    [headerView addSubview:titleLabel];
    [titleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:headerView withOffset:20.f];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UIImageView *lipsIcon = [UIImageView newAutoLayoutView];
    lipsIcon.image = IMAGE(@"mine_lips_vip");
    [headerView addSubview:lipsIcon];
    [lipsIcon autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:titleLabel withOffset:-5.f];
    [lipsIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [lipsIcon autoSetDimensionsToSize:CGSizeMake(30.f, 30.f)];
    
    UIButton *closeBtn = [UIButton newAutoLayoutView];
    [closeBtn setImage:IMAGE(@"know_verify_colse_icon") forState:UIControlStateNormal];
    [headerView addSubview:closeBtn];
    [closeBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [closeBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [closeBtn autoSetDimensionsToSize:CGSizeMake(60.f, 60.f)];
    
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


#pragma mark - SharePosterViewCell -
@interface SharePosterViewCell ()

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *platformNameLabel;

@end


@implementation SharePosterViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    CGFloat iconImg_WH = SCR_WIDTH * 0.133f;
    _iconImg = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_iconImg];
    [_iconImg autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.f];
    [_iconImg autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_iconImg autoSetDimensionsToSize:CGSizeMake(iconImg_WH, iconImg_WH)];
    
    _platformNameLabel = [UILabel newAutoLayoutView];
    _platformNameLabel.font = FONT_SYSTEM_NORMAL(11.f);
    [self.contentView addSubview:_platformNameLabel];
    [_platformNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_iconImg withOffset:8.f];
    [_platformNameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
}

- (void)setPlatformName:(NSString *)platformName
{
    _platformName = platformName;
    
    NSString *iconName = nil;
    if ([platformName isEqualToString:ShareManagerToQQ]) {
        _platformNameLabel.text = @"QQ";
        iconName = @"share_qq";
    }
    else if ([platformName isEqualToString:ShareManagerToQzone]) {
        _platformNameLabel.text = @"QQ空间";
        iconName = @"share_qzone";
    }
    else if ([platformName isEqualToString:ShareManagerToWechatSession]) {
        _platformNameLabel.text = @"微信好友";
        iconName = @"share_wechat";
    }
    else if ([platformName isEqualToString:ShareManagerToWechatTimeline]) {
        _platformNameLabel.text = @"朋友圈";
        iconName = @"share_firend";
    }
    else if ([platformName isEqualToString:ShareManagerToSina]) {
        _platformNameLabel.text = @"微博";
        iconName = @"share_sina";
    }
    else if ([platformName isEqualToString:ShareManagerReport]) {   // （视频|晒单）举报
        _platformNameLabel.text = @"举报";
        iconName = @"report";
    }
    else if ([platformName isEqualToString:ShareManagerDelete]) {   // （视频|晒单）删除
        _platformNameLabel.text = @"删除";
        iconName = @"delete";
    }
    else if ([platformName isEqualToString:ShareManagerBackToHome]) {// （视频|晒单）返回首页
        _platformNameLabel.text = @"回到推荐";
        iconName = @"v_back_root_image";
    }
    else if ([platformName isEqualToString:ShareManagerCopyLink]) { // （视频|晒单）复制链接
        _platformNameLabel.text = @"复制链接";
        iconName = @"v_shareLink_image";
    }
    else if ([platformName isEqualToString:ShareManagerShareLink]) { // （商品）分享链接
        _platformNameLabel.text = @"分享链接";
        iconName = @"v_shareLink_image";
    }
    else if ([platformName isEqualToString:ShareManagerSavePoster]) { // 保存海报
        _platformNameLabel.text = @"保存";
        iconName = @"share_save_poster";
    }
    else if ([platformName isEqualToString:@"photoReport"]) {// 晒单举报
        _platformNameLabel.text = @"举报";
        iconName = @"report";
    }
    else if ([platformName isEqualToString:@"photoDelete"]) {// 晒单删除
        _platformNameLabel.text = @"删除";
        iconName = @"delete";
    }
    
    _iconImg.image = IMAGE(iconName);
}

@end






