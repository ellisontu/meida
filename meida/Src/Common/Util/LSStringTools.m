//
//  LSStringTools.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "LSStringTools.h"

@implementation LSStringTools

- (instancetype)initString:(NSString *)originString baseFont:(UIFont *)font baseColor:(UIColor *)color lineSpacing:(CGFloat)lineSpacing
{
    self = [super init];
    if (self) {
        _originString = originString;
        _baseFont = font;
        _baseColor = color;
        _lineSpacing = lineSpacing;
    }
    return self;
}

- (void)initData
{
    if (!_baseFont) {
        _baseFont = FONT_SYSTEM_NORMAL(14.f);
    }
    if (!_baseColor) {
        _baseColor = COLOR_WITH_BLACK;
    }
    if (!_lineSpacing || _lineSpacing < 0) {
        _lineSpacing = 0.f;
    }
}

- (NSAttributedString *)configAttributedString
{
    if (stringIsEmpty(_originString)) {
        return nil;
    }
    
    [self initData];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = _lineSpacing;
    NSDictionary *baseAttrs = @{NSFontAttributeName:_baseFont,
                                NSForegroundColorAttributeName:_baseColor,
                                NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_originString];
    [attrString addAttributes:baseAttrs range:NSMakeRange(0, _originString.length)];
    
    for (int i = 0; i < _attributeArray.count; i++) {
        LSStringRangeDictionary *rangeDic = _attributeArray[i];
        if (rangeDic.range.location < _originString.length) {
            NSUInteger rangeLocation_max = rangeDic.range.location + rangeDic.range.length;
            if (rangeLocation_max < _originString.length) {
                [attrString setAttributes:rangeDic.attributeDic range:rangeDic.range];
            }
            else {
                NSRange newRange = NSMakeRange(rangeDic.range.location, _originString.length);
                [attrString setAttributes:rangeDic.attributeDic range:newRange];
            }
        }
    }
    return attrString;
}

@end










#pragma mark - LSStringRangeDictionary -
@implementation LSStringRangeDictionary

- (instancetype)initWithRange:(NSRange)range attributeDictionary:(NSDictionary *)attributeDic
{
    self = [super init];
    if (self) {
        _range = range;
        _attributeDic = attributeDic;
    }
    return self;
}

+ (NSDictionary *)getAttributedDictionaryByFont:(UIFont *)font color:(UIColor *)color attributesType:(LSStringAttributeType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:font forKey:NSFontAttributeName];
    [dic setObject:color forKey:NSForegroundColorAttributeName];
    
    if (type == LSStringAttributeTypeShadow) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = COLOR_WITH_BLACK;
        //模糊度
        shadow.shadowBlurRadius = 5.0;
        shadow.shadowOffset = CGSizeMake(1.0 , 1.0);
        [dic setObject:@0 forKey:NSVerticalGlyphFormAttributeName];
        [dic setObject:shadow forKey:NSShadowAttributeName];
    }
    else if (type == LSStringAttributeTypeStrikethrough) {
        [dic setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
    }
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:dic];
    return result;
}

@end


