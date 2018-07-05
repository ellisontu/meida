//
//  MDAddClothMatchCell.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDAddClothMatchCell.h"

#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 Camera cell #############################################----------
@interface MDAddClothMatchCameraCell ()

@end

@implementation MDAddClothMatchCameraCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
}

@end




#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 object 物件 cell #############################################----------
@interface MDAddClothMatchObjectCell ()

@end

@implementation MDAddClothMatchObjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
}

@end

#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 situation 场所 cell #############################################----------
@interface MDAddClothMatchSituationCell ()

@end

@implementation MDAddClothMatchSituationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
}
@end

