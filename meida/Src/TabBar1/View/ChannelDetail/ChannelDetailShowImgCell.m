//
//  ChannelDetailShowImgCell.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "ChannelDetailShowImgCell.h"

@interface ChannelDetailShowImgCell ()

@property (nonatomic, strong) UIImageView   *showImgView;

@end

@implementation ChannelDetailShowImgCell

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
    _showImgView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_showImgView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _showImgView.layer.cornerRadius  = 5.f;
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    _showImgView.layer.shadowColor = COLOR_HEX_STR(@"#000000").CGColor;
    _showImgView.layer.shadowOffset = CGSizeMake(1, 1);
    _showImgView.layer.shadowOpacity = 0.1;
    _showImgView.layer.shadowRadius = 2.5;
    
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650324/raw_1516588548.png"];
    
}

@end
