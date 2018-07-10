//
//  ShareViewCell.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "ShareViewCell.h"
#import "ShareManager.h"

@interface ShareViewCell ()

@property (nonatomic, strong) UIImageView   *iconView;
@property (nonatomic, strong) UILabel       *nameLabel;

@end

@implementation ShareViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _iconView  = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_nameLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5.f);
        make.left.equalTo(self.contentView).offset(2 * kOffset);
        make.right.equalTo(self.contentView).offset(-2 * kOffset);
        make.height.equalTo(self.iconView.mas_height);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(8.f);
        make.centerX.equalTo(self.contentView);
    }];
    
    _nameLabel.font = FONT_SYSTEM_NORMAL(11);
    _nameLabel.textColor = kDefaultTitleColor;
    _iconView.contentMode = UIViewContentModeScaleToFill;
    
}

- (void)setSnsName:(NSString *)snsName
{
    _snsName = snsName;
    
    NSString *iconName = nil;
    if ([_snsName isEqualToString:ShareManagerToQQ]) { 
        _nameLabel.text = @"QQ";
        iconName = @"share_qq";
    }
    else if ([_snsName isEqualToString:ShareManagerToQzone]) {
        _nameLabel.text = @"QQ空间";
        iconName = @"share_qzone";
    }
    else if ([_snsName isEqualToString:ShareManagerToWechatSession]) {
        _nameLabel.text = @"微信好友";
        iconName = @"share_wechat";
    }
    else if ([_snsName isEqualToString:ShareManagerToWechatTimeline]) {
        _nameLabel.text = @"朋友圈";
        iconName = @"share_firend";
    }
    else if ([_snsName isEqualToString:ShareManagerToSina]) {
        _nameLabel.text = @"微博";
        iconName = @"share_sina";
    }
    else if ([_snsName isEqualToString:ShareManagerReport]) {   // （视频|晒单）举报
        _nameLabel.text = @"举报";
        iconName = @"report";
    }
    else if ([_snsName isEqualToString:ShareManagerDelete]) {   // （视频|晒单）删除
        _nameLabel.text = @"删除";
        iconName = @"delete";
    }
    else if ([_snsName isEqualToString:ShareManagerBackToHome]) {// （视频|晒单）返回首页
        _nameLabel.text = @"回到推荐";
        iconName = @"v_back_root_image";
    }
    else if ([_snsName isEqualToString:ShareManagerCopyLink]) { // （视频|晒单）复制链接
        _nameLabel.text = @"复制链接";
        iconName = @"v_shareLink_image";
    }
    else if ([_snsName isEqualToString:ShareManagerShareLink]) { // （商品）分享链接
        _nameLabel.text = @"分享链接";
        iconName = @"v_shareLink_image";
    }
    else if ([_snsName isEqualToString:@"photoReport"]) {// 晒单举报
        _nameLabel.text = @"举报";
        iconName = @"report";
    }
    else if ([_snsName isEqualToString:@"photoDelete"]) {// 晒单删除
        _nameLabel.text = @"删除";
        iconName = @"delete";
    }
    
    _iconView.image = IMAGE(iconName);
}

@end
