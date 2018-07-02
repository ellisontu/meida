//
//  CustomeTextField.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "CustomeTextField.h"

@implementation CustomeTextField

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    
    if (action == @selector(select:))// 禁止选择
        return NO;
    
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    
    return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
