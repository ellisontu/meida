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
@property (nonatomic, strong) UILabel           *followCountView;       /**< 用户关注人数 */
@property (nonatomic, strong) UILabel           *beFollowCountView;     /**< 用户粉丝数量 */
@property (nonatomic, strong) UIView            *footContainerView;     /**< 消息 和 空间 容器 %比提示 */
@property (nonatomic, strong) UIButton          *footMsgBtnView;        /**< 消息 */
@property (nonatomic, strong) UIButton          *footSpaceBtnView;      /**< 空间按钮 */

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
    _followCountView   = [[UILabel alloc] init];
    _beFollowCountView = [[UILabel alloc] init];
    UIView *seplineView = [[UIView alloc] init];
    
    [self addSubview:_backgroundImgView];
    [_backgroundImgView addSubview:_userHeadImgView];
    [_backgroundImgView addSubview:_userSexImgView];
    [_backgroundImgView addSubview:_userNickLblView];
    [_backgroundImgView addSubview:_followCountView];
    [_backgroundImgView addSubview:_beFollowCountView];
    [_backgroundImgView addSubview:seplineView];
    
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
    [seplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2.f, 19.f));
        make.top.equalTo(self.userNickLblView.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.userHeadImgView);
    }];
    [_followCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(seplineView);
        make.right.equalTo(seplineView).offset(-kOffPadding);
        make.width.mas_equalTo(SCR_WIDTH * 0.5 - 2 * kOffPadding);
    }];
    [_beFollowCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(seplineView);
        make.left.equalTo(seplineView).offset(kOffPadding);
        make.width.equalTo(self.followCountView);
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
    seplineView.backgroundColor = COLOR_HEX_STR(@"#66A298");
    _userNickLblView.font = FONT_SYSTEM_NORMAL(16);
    _userNickLblView.textColor = kDefaultTitleColor;
    _userNickLblView.textAlignment = NSTextAlignmentCenter;
    _followCountView.font = FONT_SYSTEM_NORMAL(15);
    _followCountView.textColor = COLOR_HEX_STR(@"#66A298");
    _followCountView.textAlignment = NSTextAlignmentRight;
    _beFollowCountView.font = FONT_SYSTEM_NORMAL(15);
    _beFollowCountView.textColor = COLOR_HEX_STR(@"#66A298");
    _beFollowCountView.textAlignment = NSTextAlignmentLeft;
    
    _userNickLblView.text = @"令狐冲";
    _followCountView.text = @"关注 16000";
    _beFollowCountView.text = @"粉丝 10000";
    
    // 2. 消息 空间 按钮
    _footContainerView = [[UIView alloc] init];
    _footMsgBtnView    = [[UIButton alloc] init];
    _footSpaceBtnView  = [[UIButton alloc] init];
    UIView *sepLineView = [[UIView alloc] init];
    
    [self addSubview:_footContainerView];
    [_footContainerView addSubview:_footMsgBtnView];
    [_footContainerView addSubview:_footSpaceBtnView];
    [_footContainerView addSubview:sepLineView];
    [_footContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(kfootHH);
    }];
    [_footMsgBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footContainerView);
        make.right.equalTo(self.footSpaceBtnView.mas_left);
        make.centerY.equalTo(self.footContainerView);
        make.height.equalTo(self.footContainerView);
    }];
    [_footSpaceBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.footMsgBtnView);
        make.height.equalTo(self.footContainerView);
        make.centerY.equalTo(self.footContainerView);
        make.right.equalTo(self.footContainerView);
    }];
    [sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2.f, kfootHH - 30));
        make.centerY.equalTo(self.footContainerView);
        make.centerX.equalTo(self.footContainerView);
    }];
    
    sepLineView.backgroundColor = kDefaultSeparationLineColor;
    
    CGFloat offset = 15.f;
    _footMsgBtnView.titleEdgeInsets = UIEdgeInsetsMake(0, _footMsgBtnView.titleLabel.bounds.size.width + offset, 0, -_footMsgBtnView.titleLabel.bounds.size.width);
    _footSpaceBtnView.titleEdgeInsets = UIEdgeInsetsMake(0, _footSpaceBtnView.titleLabel.bounds.size.width + offset, 0, -_footSpaceBtnView.titleLabel.bounds.size.width);
    
    [_footMsgBtnView setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    [_footSpaceBtnView setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
    [_footMsgBtnView setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [_footSpaceBtnView setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    _footMsgBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(14);
    _footSpaceBtnView.titleLabel.font = FONT_SYSTEM_NORMAL(14);
    
    NSString *strMsg = @"消息 18";
    NSInteger loc = 2;
    NSMutableAttributedString *strMsgAttr = [[NSMutableAttributedString alloc] initWithString:strMsg];
    [strMsgAttr addAttribute:NSForegroundColorAttributeName value:RED range:NSMakeRange(loc,strMsg.length - loc)];
    
    NSString *strSpace = @"空间 50%";
    NSMutableAttributedString *strSpaceAttr = [[NSMutableAttributedString alloc] initWithString:strSpace];
    [strSpaceAttr addAttribute:NSForegroundColorAttributeName value:RED range:NSMakeRange(loc,strSpace.length - loc)];
    
    [_footMsgBtnView setAttributedTitle:strMsgAttr forState:UIControlStateNormal];
    [_footSpaceBtnView setAttributedTitle:strSpaceAttr forState:UIControlStateNormal];
    
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
