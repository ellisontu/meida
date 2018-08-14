//
//  WardrobeAfterClothCell.m
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "WardrobeAfterClothCell.h"

@interface WardrobeAfterClothCell ()

@property (nonatomic, strong) UIImageView   *showImgView;

@end

@implementation WardrobeAfterClothCell

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
    _showImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_showImgView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.contentView.backgroundColor = RED;
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.layer.masksToBounds = YES;
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    
}

- (void)setUrlStr:(NSString *)urlStr
{
    if (stringIsEmpty(urlStr)) return;
    _urlStr = urlStr;

    [_showImgView imageWithUrlStr:_urlStr placeholderImage:IMAGE(@"place_holer_icon")];

}

@end
