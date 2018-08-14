//
//  MDScrollContainerCell.m
//  meida
//
//  Created by ToTo on 2018/7/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  

#import "MDScrollContainerCell.h"

@interface MDScrollContainerCell ()

@end

@implementation MDScrollContainerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
