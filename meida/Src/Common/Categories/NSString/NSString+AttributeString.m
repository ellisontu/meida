//
//  NSString+AttributeString.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "NSString+AttributeString.h"

@implementation NSString (AttributeString)

- (NSRange)stringRangeOfSubstring:(NSString *)substring
{
    NSRange range = [self rangeOfString:substring];
    return range;
}

- (NSAttributedString *)stringFont:(UIFont *)font baseColor:(UIColor *)baseColor rangeColor:(UIColor *)rangeColor range:(NSRange)range lineSpacing:(CGFloat)lineSpacing
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSDictionary *baseAttrs = @{NSFontAttributeName:font, NSForegroundColorAttributeName:baseColor, NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    [attrString addAttributes:baseAttrs range:NSMakeRange(0, self.length)];
    NSDictionary *attrsDic = @{NSFontAttributeName:font, NSForegroundColorAttributeName:rangeColor, NSParagraphStyleAttributeName:paragraphStyle};
    [attrString setAttributes:attrsDic range:range];
    
    return attrString;
}



@end
