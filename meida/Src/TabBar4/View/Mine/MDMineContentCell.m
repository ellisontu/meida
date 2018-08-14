//
//  MDMineContentCell.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDMineContentCell.h"
#import "UIImage+Blur.h"

#import "MDLoginControl.h"

#pragma mark -  我的 -> tableView headView -> user info view #############################################----------

@interface MDMineContentHeadView ()

@property (nonatomic, strong) UIImageView       *backgroundImgView;     /**< 背景 图片view 做高斯模糊 */
@property (nonatomic, strong) UIImageView       *userHeadImgView;       /**< 用户头像 */
@property (nonatomic, strong) UIImageView       *userSexImgView;        /**< 用户性别标识 */
@property (nonatomic, strong) UILabel           *userNickLblView;       /**< 用户昵称 */
@property (nonatomic, strong) UIView            *infoContainerView;     /**< 粉丝 关注 消息 空间view容器 */
@property (nonatomic, strong) UILabel           *followNumLblView;         /**< 关注*/
@property (nonatomic, strong) UILabel           *beFollowNumLblView;       /**< 粉丝 */
@property (nonatomic, strong) UILabel           *messgeNumLblView;         /**< 消息 */
@property (nonatomic, strong) UILabel           *spaceNumLblView;          /**< 空间view */

@end

@implementation MDMineContentHeadView

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
    
    CGFloat kfootHH = 49.f;
    // 1. 头像 背景 ....
    _backgroundImgView = [[UIImageView alloc] init];
    _userHeadImgView   = [[UIImageView alloc] init];
    _userSexImgView    = [[UIImageView alloc] init];
    _userNickLblView   = [[UILabel alloc] init];
    
    [self addSubview:_backgroundImgView];
    [_backgroundImgView addSubview:_userHeadImgView];
    [_backgroundImgView addSubview:_userSexImgView];
    [_backgroundImgView addSubview:_userNickLblView];
    
    [_backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-kfootHH);
    }];
    CGFloat headIconWW = 120.f;
    [_userHeadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headIconWW, headIconWW));
        make.centerX.equalTo(self.backgroundImgView);
        make.top.equalTo(self.backgroundImgView).offset(kStatusBarHeight + 44.f);
    }];
    [_userSexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
        make.centerX.equalTo(self.userHeadImgView).offset(45.f);
        make.centerY.equalTo(self.userHeadImgView).offset(45.f);
    }];
    [_userNickLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userSexImgView.mas_bottom).offset(10.f);
        make.left.equalTo(self.userHeadImgView).offset(kOffPadding);
        make.right.equalTo(self.userHeadImgView).offset(-kOffPadding);
    }];
    _backgroundImgView.backgroundColor = COLOR_HEX_STR(@"#EEE8EF");
    _backgroundImgView.userInteractionEnabled = YES;
    _userHeadImgView.layer.cornerRadius  = headIconWW * 0.5f;
    _userHeadImgView.layer.masksToBounds = YES;
    [_userHeadImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650324/raw_1516588548.png" placeholderImage:IMAGE(@"place_holer_icon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    _userHeadImgView.userInteractionEnabled = YES;
    [_userHeadImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAciton:)]];
    _userSexImgView.image = IMAGE(@"navi_right_icon");
    _userNickLblView.font = FONT_SYSTEM_NORMAL(16);
    _userNickLblView.textColor = kDefaultTitleColor;
    _userNickLblView.textAlignment = NSTextAlignmentCenter;
    
    _userNickLblView.text = @"令狐冲";
    
    //2.  粉丝 关注 消息 空间view容器
    _infoContainerView = [[UIView alloc] init];
    UIView *followView   = [[UIView alloc] init];
    UIView *beFollowView = [[UIView alloc] init];
    UIView *messgeView   = [[UIView alloc] init];
    UIView *spaceView    = [[UIView alloc] init];
    
    // 标题
    UILabel *followTipsLbl = [[UILabel alloc] init];
    UILabel *befollowTipslbl = [[UILabel alloc] init];
    UILabel *messgeTipsLbl = [[UILabel alloc] init];
    UILabel *spaceTipsLbl  = [[UILabel alloc] init];
    
    // 数量
    _followNumLblView   = [[UILabel alloc] init];
    _beFollowNumLblView = [[UILabel alloc] init];
    _messgeNumLblView   = [[UILabel alloc] init];
    _spaceNumLblView    = [[UILabel alloc] init];
    
    [self addSubview:_infoContainerView];
    [_infoContainerView addSubview:followView];
    [_infoContainerView addSubview:beFollowView];
    [_infoContainerView addSubview:messgeView];
    [_infoContainerView addSubview:spaceView];
    
    [followView addSubview:followTipsLbl];
    [beFollowView addSubview:befollowTipslbl];
    [messgeView addSubview:messgeTipsLbl];
    [spaceView addSubview:spaceTipsLbl];
    
    [followView addSubview:_followNumLblView];
    [beFollowView addSubview:_beFollowNumLblView];
    [messgeView addSubview:_messgeNumLblView];
    [spaceView addSubview:_spaceNumLblView];
    
    
    _infoContainerView.backgroundColor = COLOR_WITH_WHITE;
    
    CGFloat totalWW = SCR_WIDTH - 3 * kOffPadding;
    [_infoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backgroundImgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(totalWW, 90.f));
        make.centerX.equalTo(self.backgroundImgView);
    }];
    CGFloat btnWW = totalWW / 4;
    CGFloat btnHH = 90.f;
    [followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
        make.left.equalTo(self.infoContainerView);
        make.centerY.equalTo(self.infoContainerView);
    }];
    [beFollowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
        make.left.equalTo(followView.mas_right);
        make.centerY.equalTo(self.infoContainerView);
    }];
    [messgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
        make.left.equalTo(beFollowView.mas_right);
        make.centerY.equalTo(self.infoContainerView);
    }];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWW, btnHH));
        make.left.equalTo(messgeView.mas_right);
        make.centerY.equalTo(self.infoContainerView);
    }];
    
    
    [_followNumLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followView);
        make.right.equalTo(followView);
        make.top.equalTo(followView).offset(kOffPadding);
    }];
    [_beFollowNumLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beFollowView);
        make.right.equalTo(beFollowView);
        make.top.equalTo(beFollowView).offset(kOffPadding);
    }];
    [_messgeNumLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messgeView);
        make.right.equalTo(messgeView);
        make.top.equalTo(messgeView).offset(kOffPadding);
    }];
    [_spaceNumLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spaceView);
        make.right.equalTo(spaceView);
        make.top.equalTo(spaceView).offset(kOffPadding);
    }];
    
    [followTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followView);
        make.right.equalTo(followView);
        make.top.equalTo(self.followNumLblView.mas_bottom).offset(kOffset);
    }];
    [befollowTipslbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beFollowView);
        make.right.equalTo(beFollowView);
        make.top.equalTo(self.beFollowNumLblView.mas_bottom).offset(kOffset);
    }];
    [messgeTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messgeView);
        make.right.equalTo(messgeView);
        make.top.equalTo(self.messgeNumLblView.mas_bottom).offset(kOffset);
    }];
    [spaceTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spaceView);
        make.right.equalTo(spaceView);
        make.top.equalTo(self.spaceNumLblView.mas_bottom).offset(kOffset);
    }];
    
    _infoContainerView.layer.cornerRadius  = 5.f;
    _infoContainerView.layer.shadowColor = COLOR_HEX_STR(@"#000000").CGColor;
    _infoContainerView.layer.shadowOffset = CGSizeMake(1, 1);
    _infoContainerView.layer.shadowOpacity = 0.1;
    _infoContainerView.layer.shadowRadius = 2.5;
    
    
    _followNumLblView.font = FONT_SYSTEM_BOLD(20);
    _followNumLblView.textColor = kDefaultTitleColor;
    _beFollowNumLblView.font = FONT_SYSTEM_BOLD(20);
    _beFollowNumLblView.textColor = kDefaultTitleColor;
    _messgeNumLblView.font = FONT_SYSTEM_BOLD(20);
    _messgeNumLblView.textColor = kDefaultTitleColor;
    _spaceNumLblView.font = FONT_SYSTEM_BOLD(20);
    _spaceNumLblView.textColor = kDefaultTitleColor;
    _followNumLblView.textAlignment = NSTextAlignmentCenter;
    _beFollowNumLblView.textAlignment = NSTextAlignmentCenter;
    _messgeNumLblView.textAlignment = NSTextAlignmentCenter;
    _spaceNumLblView.textAlignment = NSTextAlignmentCenter;
    
    followTipsLbl.font = FONT_SYSTEM_NORMAL(15);
    followTipsLbl.textColor = COLOR_HEX_STR(@"#666666");
    befollowTipslbl.font = FONT_SYSTEM_NORMAL(15);
    befollowTipslbl.textColor = COLOR_HEX_STR(@"#666666");
    messgeTipsLbl.font = FONT_SYSTEM_NORMAL(15);
    messgeTipsLbl.textColor = COLOR_HEX_STR(@"#666666");
    spaceTipsLbl.font = FONT_SYSTEM_NORMAL(15);
    spaceTipsLbl.textColor = COLOR_HEX_STR(@"#666666");
    
    followTipsLbl.textAlignment = NSTextAlignmentCenter;
    befollowTipslbl.textAlignment = NSTextAlignmentCenter;
    messgeTipsLbl.textAlignment = NSTextAlignmentCenter;
    spaceTipsLbl.textAlignment = NSTextAlignmentCenter;
    
    _followNumLblView.text = @"60";
    _beFollowNumLblView.text = @"60";
    _messgeNumLblView.text = @"60";
    _spaceNumLblView.text  = @"60";
    
    followTipsLbl.text = @"关注";
    befollowTipslbl.text = @"粉丝";
    messgeTipsLbl.text = @"消息";
    spaceTipsLbl.text  = @"空间";
    
}

- (void)loginAciton:(UITapGestureRecognizer *)gesture
{
    MDLoginControl *vc = [[MDLoginControl alloc] init];
    [MDAPPDELEGATE.navigation pushViewController:vc animated:YES];
}

@end

#pragma mark -  我的 -> tableView cell -> user info view #############################################----------
@interface MDMineContentCommonCell ()

@property (nonatomic, strong) UIImageView       *iconImgView;
@property (nonatomic, strong) UILabel           *titleLblView;
@property (nonatomic, strong) UIImageView       *arrowImgView;
@property (nonatomic, strong) UIView            *sepLineView;

@end

@implementation MDMineContentCommonCell

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
    
    // init subviews
    _iconImgView  = [[UIImageView alloc] init];
    _titleLblView = [[UILabel alloc] init];
    _arrowImgView = [[UIImageView alloc] init];
    _sepLineView  = [[UIView alloc] init];
    
    [self.contentView addSubview:_iconImgView];
    [self.contentView addSubview:_titleLblView];
    [self.contentView addSubview:_arrowImgView];
    [self.contentView addSubview:_sepLineView];
    
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kOffPadding);
    }];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
        make.right.equalTo(self.contentView).offset(-kOffPadding);
        make.centerY.equalTo(self.contentView);
    }];
    [_titleLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self->_iconImgView.mas_right).offset(10.f);
        make.right.equalTo(self->_arrowImgView.mas_left).offset(-10.f);
    }];
    [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_iconImgView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.f);
    }];
    
    _iconImgView.image  = IMAGE(@"navi_right_icon");
    _arrowImgView.image = IMAGE(@"navi_right_icon");
    
    _titleLblView.font = FONT_SYSTEM_NORMAL(15);
    _titleLblView.textColor = kDefaultTitleColor;
    _sepLineView.backgroundColor = kDefaultBackgroundColor;
    
}

- (void)setInfoDict:(NSDictionary *)infoDict
{
    if (dictionaryIsEmpty(infoDict)) return;
    _infoDict = infoDict;
    
    NSInteger type = [_infoDict[@"type"] integerValue];
    NSString *titleStr = _infoDict[@"title"];
    
    _titleLblView.text = titleStr;
    switch (type) {
        case 0:
        {
            _iconImgView.image = IMAGE(@"navi_right_icon");
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
}

@end
