//
//  ShareView.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "ShareView.h"
#import "ShareViewCell.h"
#import "ShareManager.h"

@interface ShareView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MDShareInfoModel  *model;
@property (nonatomic, strong) UICollectionView  *platCollectionView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSArray           *platformArray;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) UIView            *coverView;
@property (nonatomic, strong) UIView            *customView;        /**< 分享平台上面的自定义view */

@end

@implementation ShareView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPlatformsArray:(NSArray *)platforms shareInfoModel:(MDShareInfoModel *)model
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
        _platformArray = platforms;
        _model = model;
        _dataArray = [NSMutableArray array];

        [self initView];
        [self initData];
        // 配置自定义view到 分享页面
//        _customViewHeight = 0.f;
        if (_model.customView) {
            [self initCustomViewWithView:_model.customView];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroundNotification) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)appDidEnterBackgroundNotification
{
    [self dismiss];
}

#pragma mark - 定制UI -
- (void)initView
{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.3;
    [self addSubview:self.coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.coverView addGestureRecognizer:tap];
    
    
    if (!self.platCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(SCR_WIDTH / 4, SCR_WIDTH / 4);
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.headerReferenceSize = CGSizeMake(SCR_WIDTH, 40);
        flowLayout.footerReferenceSize = CGSizeMake(SCR_WIDTH, 60);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.platCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, SCR_HEIGHT - kHeaderHeight) collectionViewLayout:flowLayout];
        self.platCollectionView.backgroundColor = COLOR_WITH_WHITE;
        self.platCollectionView.showsVerticalScrollIndicator = NO;
        self.platCollectionView.delegate = self;
        self.platCollectionView.dataSource = self;
        [self addSubview:self.platCollectionView];
        
        [self.platCollectionView registerNib:[UINib nibWithNibName:@"ShareViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShareViewCellID"];
        [self.platCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCellID"];
        [self.platCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCellID"];
    }
}

// 根据传入的model 添加自定view
- (void)initCustomViewWithView:(UIView *)customView
{
    _customView = customView;
    
    if (_model.shareViewType == ShareViewTypeOrderGroup) {
        // 团购订单详情页 待成团状态
        self.coverView.alpha = 0.6;
        //外部已设定 frame，此处不需要设置 frame；
    }
    else {
        _customView.frame = CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, _customView.height);
    }
    
    [self addSubview:_customView];
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
    [self.platCollectionView reloadData];
}

- (void)show
{
    [MDAPPDELEGATE.window addSubview:self];
    CGFloat height = (_dataArray.count / 5 + 1) * SCR_WIDTH / 4 + 40 + 60 + kTabBarBottomHeight;
    self.platCollectionView.frame = CGRectMake(0, SCR_HEIGHT, SCR_WIDTH, height);
    [UIView animateWithDuration:0.3f animations:^{
        if (_model.shareViewType != ShareViewTypeOrderGroup) {
            self.customView.y = SCR_HEIGHT - height;
        }
        self.platCollectionView.y   = SCR_HEIGHT - height;
    }];
}

#pragma mark - 内部方法 -
- (void)tapAction
{
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.platCollectionView.y = SCR_HEIGHT;
        self.coverView.alpha = 0;
        if (_model.shareViewType == ShareViewTypeOrderGroup) {
            self.customView.alpha = 0;
        }
        else {
            self.customView.y = SCR_HEIGHT;
        }
    } completion:^(BOOL finished) {
        self.customView.alpha = 1;
        [self removeFromSuperview];
        [self.customView removeFromSuperview];
        if (_dismissBlock) {
            _dismissBlock();
        }
    }];
}

#pragma mark - UICollectionViewDataSource -

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareViewCellID" forIndexPath:indexPath];
    if (_dataArray.count > indexPath.item) {
        cell.snsName = _dataArray[indexPath.item];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *plat = _dataArray[indexPath.item];
    if (_SharePlatformSeletedBlock) {
        _SharePlatformSeletedBlock(plat);
    }
    [self dismiss];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCellID" forIndexPath:indexPath];
        
        UIView *backView = [[UIView alloc] initWithFrame:view.bounds];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_SYSTEM_NORMAL(14);
        label.text = @"分享到";
        [label sizeToFit];
        label.center = backView.center;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
        [view addSubview:backView];
        view.backgroundColor = [UIColor whiteColor];
        reusableView = view;
    }
    else if(kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCellID" forIndexPath:indexPath];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, SCR_WIDTH - 40, 44)];
        [footer addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_WITH_BLACK forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = FONT_SYSTEM_NORMAL(14);
        cancelBtn.layer.cornerRadius = 22;
        cancelBtn.layer.borderWidth = 1;
        cancelBtn.layer.borderColor = kDefaultSeparationLineColor.CGColor;
        reusableView = footer;
        
    }
    return reusableView;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 60.f;
}

@end
