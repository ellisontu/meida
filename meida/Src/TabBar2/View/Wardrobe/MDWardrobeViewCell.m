//
//  MDWardrobeViewCell.m
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWardrobeViewCell.h"

#import "MDWardrobeAfterClothCtrl.h"
#import "MDFanshionCircleCtrl.h"
#import "MDMyWardrobeCtrl.h"
#import "MDMyFittingRoomCtrl.h"

#import "PayManager.h"

#pragma mark -  衣橱 -> 头部 -> cell view #############################################----------

@implementation MDWardrobeViewFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    UIButton *creativeBtn     = [[UIButton alloc] init];    // 创意按钮
    UIButton *afterClothesBtn = [[UIButton alloc] init];    // 明日装
    UIButton *fashionBtn      = [[UIButton alloc] init];    // 依尚圈
    UIButton *idleBtn         = [[UIButton alloc] init];    // 闲置
    UIView   *separaLine      = [[UIView alloc] init];
    
    [self.contentView addSubview:creativeBtn];
    [self.contentView addSubview:afterClothesBtn];
    [self.contentView addSubview:fashionBtn];
    [self.contentView addSubview:idleBtn];
    [self.contentView addSubview:separaLine];
    
    separaLine.backgroundColor = kDefaultSeparationLineColor;
    [separaLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH - 2 * kOffPadding, 1.f));
        make.bottom.equalTo(self.contentView);
    }];
    
    CGFloat btnWW = SCR_WIDTH / 4.f;
    CGFloat btnHH = 65.f;
    [creativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    [afterClothesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(creativeBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    [fashionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(afterClothesBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    [idleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(fashionBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
    }];
    
    // 标题的偏移量
    [creativeBtn setTitle:@"创意" forState:UIControlStateNormal];
    [creativeBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [creativeBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    creativeBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    [afterClothesBtn setTitle:@"明日装" forState:UIControlStateNormal];
    [afterClothesBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [afterClothesBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    afterClothesBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    [fashionBtn setTitle:@"依尚圈" forState:UIControlStateNormal];
    [fashionBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [fashionBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    fashionBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    [idleBtn setTitle:@"闲置" forState:UIControlStateNormal];
    [idleBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [idleBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    idleBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    CGFloat offset = 10.f;
    creativeBtn.titleEdgeInsets = UIEdgeInsetsMake(creativeBtn.imageView.frame.size.height + offset, -creativeBtn.imageView.bounds.size.width, 0,0);
    creativeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, creativeBtn.titleLabel.frame.size.width/2, creativeBtn.titleLabel.frame.size.height+5, -creativeBtn.titleLabel.frame.size.width/2);
    
    afterClothesBtn.titleEdgeInsets = UIEdgeInsetsMake(afterClothesBtn.imageView.frame.size.height + offset, -afterClothesBtn.imageView.bounds.size.width, 0,0);
    afterClothesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, afterClothesBtn.titleLabel.frame.size.width/2, creativeBtn.titleLabel.frame.size.height+5, -afterClothesBtn.titleLabel.frame.size.width/2);
    
    fashionBtn.titleEdgeInsets = UIEdgeInsetsMake(fashionBtn.imageView.frame.size.height + offset, -fashionBtn.imageView.bounds.size.width, 0,0);
    fashionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, fashionBtn.titleLabel.frame.size.width/2, creativeBtn.titleLabel.frame.size.height+5, -fashionBtn.titleLabel.frame.size.width/2);
    
    idleBtn.titleEdgeInsets = UIEdgeInsetsMake(idleBtn.imageView.frame.size.height + offset, -idleBtn.imageView.bounds.size.width, 0,0);
    idleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, idleBtn.titleLabel.frame.size.width/2, creativeBtn.titleLabel.frame.size.height+5, -idleBtn.titleLabel.frame.size.width/2);
    
    creativeBtn.tag = 10001;        // 创意按钮
    afterClothesBtn.tag = 10002;    // 明日装
    fashionBtn.tag = 10003;         // 依尚圈
    idleBtn.tag =  10004;           // 闲置
    
    [creativeBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [afterClothesBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [fashionBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [idleBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClickAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10001:
        {// 点击 "创意"
            
        }
            break;
        case 10002:
        {// 点击 "明日装"
            MDWardrobeAfterClothCtrl *vc = [[MDWardrobeAfterClothCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        case 10003:
        {// 点击 "依尚圈"
            MDFanshionCircleCtrl *vc = [[MDFanshionCircleCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        case 10004:
        {// 点击 "闲置"
            
        }
            break;
        default:
            break;
    }
}


@end

#pragma mark -  衣橱 -> 分类 -> cell view #############################################----------
@interface MDWardrobeViewVerbCell ()

@end

@implementation MDWardrobeViewVerbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    UIButton *myWardrobe   = [[UIButton alloc] init];    // 我的衣橱
    UIButton *fittRoomBtn  = [[UIButton alloc] init];    // 试衣间
    UIButton *matchHelpBtn = [[UIButton alloc] init];    // 搭配求助
    UIButton *yiReportBtn  = [[UIButton alloc] init];    // 依报告
    
    [self.contentView addSubview:myWardrobe];
    [self.contentView addSubview:fittRoomBtn];
    [self.contentView addSubview:matchHelpBtn];
    [self.contentView addSubview:yiReportBtn];

    CGFloat padding = 20.f;
    CGFloat btnWW = (SCR_WIDTH - 3 * padding) / 2.f;
    [myWardrobe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnWW));
        make.left.equalTo(self.contentView).offset(padding);
    }];
    [fittRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myWardrobe);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnWW));
        make.right.equalTo(self.contentView).offset(-padding);
    }];
    [matchHelpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fittRoomBtn.mas_bottom).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnWW));
        make.left.equalTo(myWardrobe);
    }];
    [yiReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(matchHelpBtn);
        make.size.mas_equalTo(CGSizeMake(btnWW, btnWW));
        make.right.equalTo(fittRoomBtn);
    }];

    myWardrobe.layer.borderColor = kDefaultBorderColor.CGColor;
    fittRoomBtn.layer.borderColor = kDefaultBorderColor.CGColor;
    matchHelpBtn.layer.borderColor = kDefaultBorderColor.CGColor;
    yiReportBtn.layer.borderColor = kDefaultBorderColor.CGColor;
    myWardrobe.layer.borderWidth = 1.f;
    fittRoomBtn.layer.borderWidth = 1.f;
    matchHelpBtn.layer.borderWidth = 1.f;
    yiReportBtn.layer.borderWidth = 1.f;
    
    /**
     myWardrobe
     fittRoomBtn
     matchHelpBtn
     yiReportBtn
     */
    
    // 标题的偏移量
    [myWardrobe setTitle:@"我的衣橱" forState:UIControlStateNormal];
    [myWardrobe setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [myWardrobe setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    myWardrobe.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    [fittRoomBtn setTitle:@"试衣间" forState:UIControlStateNormal];
    [fittRoomBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [fittRoomBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    fittRoomBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    [matchHelpBtn setTitle:@"搭配求助" forState:UIControlStateNormal];
    [matchHelpBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [matchHelpBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    matchHelpBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    [yiReportBtn setTitle:@"依报告" forState:UIControlStateNormal];
    [yiReportBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [yiReportBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    yiReportBtn.titleLabel.font = FONT_SYSTEM_NORMAL(13);
    
    CGFloat offset = 10.f;
    myWardrobe.titleEdgeInsets = UIEdgeInsetsMake(myWardrobe.imageView.frame.size.height + offset, -myWardrobe.imageView.bounds.size.width, 0,0);
    myWardrobe.imageEdgeInsets = UIEdgeInsetsMake(0, myWardrobe.titleLabel.frame.size.width/2, myWardrobe.titleLabel.frame.size.height+5, -myWardrobe.titleLabel.frame.size.width/2);
    
    fittRoomBtn.titleEdgeInsets = UIEdgeInsetsMake(fittRoomBtn.imageView.frame.size.height + offset, -fittRoomBtn.imageView.bounds.size.width, 0,0);
    fittRoomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, fittRoomBtn.titleLabel.frame.size.width/2, fittRoomBtn.titleLabel.frame.size.height+5, -fittRoomBtn.titleLabel.frame.size.width/2);
    
    matchHelpBtn.titleEdgeInsets = UIEdgeInsetsMake(matchHelpBtn.imageView.frame.size.height + offset, -matchHelpBtn.imageView.bounds.size.width, 0,0);
    matchHelpBtn.imageEdgeInsets = UIEdgeInsetsMake(0, matchHelpBtn.titleLabel.frame.size.width/2, matchHelpBtn.titleLabel.frame.size.height+5, -matchHelpBtn.titleLabel.frame.size.width/2);
    
    yiReportBtn.titleEdgeInsets = UIEdgeInsetsMake(yiReportBtn.imageView.frame.size.height + offset, -yiReportBtn.imageView.bounds.size.width, 0,0);
    yiReportBtn.imageEdgeInsets = UIEdgeInsetsMake(0, yiReportBtn.titleLabel.frame.size.width/2, yiReportBtn.titleLabel.frame.size.height+5, -yiReportBtn.titleLabel.frame.size.width/2);
    
    myWardrobe.tag = 10001;     // 我的衣橱
    fittRoomBtn.tag = 10002;    // 试衣间
    matchHelpBtn.tag = 10003;   // 搭配求助
    yiReportBtn.tag =  10004;   // 依报告
    
    [myWardrobe addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [fittRoomBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [matchHelpBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [yiReportBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClickAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10001:
        {// 点击 "我的衣橱"
            MDMyWardrobeCtrl *vc = [[MDMyWardrobeCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        case 10002:
        {// 点击 "试衣间"
            MDMyFittingRoomCtrl *vc = [[MDMyFittingRoomCtrl alloc] init];
            [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
        }
            break;
        case 10003:
        {// 点击 "搭配求助"
            
        }
            break;
        case 10004:
        {// 点击 "依报告"
            //[[PayManager sharedInstance] goToPayWithParams:params payMethod:payMethodStr];
        }
            break;
        default:
            break;
    }
}


@end


#pragma mark -  衣橱 -> 穿衣计划 -> cell view #############################################----------
static NSString *MDWardrobeViewPlanCellItemID = @"MDWardrobeViewPlanCellItem";
@interface MDWardrobeViewPlanCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel           *titleLbl;
@property (nonatomic, strong) UICollectionView  *listView;

@end

@implementation MDWardrobeViewPlanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    _titleLbl = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOffPadding);
    }];
    _titleLbl.font = FONT_SYSTEM_NORMAL(16);
    _titleLbl.textColor = kDefaultTitleColor;
    _titleLbl.text = @"穿衣计划";
    
    UICollectionViewFlowLayout *flowLayout     = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 15.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = padding;
    flowLayout.minimumLineSpacing = padding;
    CGFloat itemWW = SCR_WIDTH / 3.f;
    flowLayout.itemSize = CGSizeMake(itemWW, itemWW + 35);
    
    _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _listView.delegate   = self;
    _listView.dataSource = self;
    _listView.backgroundColor = COLOR_WITH_WHITE;
    _listView.showsVerticalScrollIndicator   = NO;
    _listView.showsHorizontalScrollIndicator = NO;
    _listView.scrollEnabled = YES;
    [_listView registerClass:[MDWardrobeViewPlanCellItem class] forCellWithReuseIdentifier:MDWardrobeViewPlanCellItemID];
    [self.contentView addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_titleLbl.mas_bottom).offset(5.f);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDWardrobeViewPlanCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDWardrobeViewPlanCellItemID forIndexPath:indexPath];
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


@interface MDWardrobeViewPlanCellItem ()

@property (nonatomic, strong) UIView    *containerView;

@end

@implementation MDWardrobeViewPlanCellItem

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
    _containerView = [[UIView alloc] init];
    [self.contentView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _containerView.layer.borderWidth = 1.f;
    _containerView.layer.borderColor = kDefaultBorderColor.CGColor;
    
}

@end


