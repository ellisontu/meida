//
//  BaseTextField.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseTextField.h"

@interface BaseTextField ()

@end

@implementation BaseTextField


-(void)setVOffset:(CGFloat)vOffset{
    _vOffset = vOffset;
}
-(void)setHOffset:(CGFloat)hOffset{
    _hOffset = hOffset;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (_hOffset == 0){ // 如没有传入水平偏移值，默认增加 5
        return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    }
    return CGRectMake(bounds.origin.x + _hOffset, bounds.origin.y + _vOffset, bounds.size.width - (2 * _hOffset), bounds.size.height);
    
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    if (_hOffset == 0){ // 如没有传入水平偏移值，默认增加 5
        return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    }
    return CGRectMake(bounds.origin.x + _hOffset, bounds.origin.y + _vOffset, bounds.size.width - (2 * _hOffset), bounds.size.height);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if (_hOffset == 0){ // 如没有传入水平偏移值，默认增加 5
        return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    }
    return CGRectMake(bounds.origin.x + _hOffset, bounds.origin.y + _vOffset, bounds.size.width - (2 * _hOffset), bounds.size.height);
}

@end
