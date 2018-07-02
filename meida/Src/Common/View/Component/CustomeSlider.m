//
//  CustomeSlider.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//
#import "CustomeSlider.h"

@implementation CustomeSlider

- (CGRect) trackRectForBounds:(CGRect)bounds
{
    CGFloat width = bounds.size.width;
    
    return CGRectMake(0, 0, width, 5);
}




@end
