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

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ShareViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
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
