//
//  NSString+TrimmingAdditions.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "NSString+TrimmingAdditions.h"

//#define TAG_PATTERN @"\\#[a-zA-Z0-9\\¥\\.\\*\\u4e00-\\u9fa5 ]+\\#"
#define TAG_PATTERN @"\\#.{0,}?\\#"

@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    //This method is unsafe because it could potentially cause buffer overruns.
    //[self getCharacters:charBuffer];
    [self getCharacters:charBuffer range:NSMakeRange(location, length)];
    for (location = 0; location < length; location++) {
        // charBuffer[i] 是 字符对应的ASCII值
        //DLog(@"charBuffer = %hu", charBuffer[location]);
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    //[self getCharacters:charBuffer];
    [self getCharacters:charBuffer range:NSMakeRange(location, length)];
    for (length = [self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break ;
        }
    }
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSArray *)rangesOfChannel
{
    if (!self) {
        return nil;
    }
    NSError *error = nil;
    NSString *pattern = TAG_PATTERN;
    NSRegularExpression *reg = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *result = [reg matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return result;
}

- (NSMutableAttributedString *)attributedChannelStringWithColor:(UIColor *)color font:(UIFont *)font
{
    if (!self || self.length == 0)
        return nil;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self];
    NSArray *result = [self rangesOfChannel];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    
    if (result && result.count > 0) {
        for (NSTextCheckingResult *item in result) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:RED range:item.range];
        }
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
}

- (NSMutableAttributedString *)attributedChannelStringWithColor:(UIColor *)color font:(UIFont *)font tags:(NSArray *)tags
{
    if (!self || self.length == 0)
        return nil;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self];
    NSArray *result = [self rangesOfChannel];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    
    if (result && result.count > 0) {
        for (NSTextCheckingResult *item in result) {
            NSString *itemString = [self substringWithRange:item.range];
            // 去掉 #
            itemString = [itemString stringByReplacingOccurrencesOfString:@"#" withString:@""];
            // 如果在 tags 中存在则标红
            if ([tags containsObject:itemString]) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:RED range:item.range];
            }
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
}

- (NSMutableAttributedString *)attributedStringWithSymbol:(NSString *)symbol color:(UIColor *)color spaceLine:(CGFloat)spaceLine textAlignment:(NSTextAlignment)textAlignment
{
    NSString *title = self;
    
    NSArray *titleRedArr = [title subStringWithRex];
    title = [title stringByReplacingOccurrencesOfString:symbol withString:@""];
    
    if (!stringIsEmpty(title)) {
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        if (spaceLine) {
            [paragraphStyle setLineSpacing:spaceLine];
        }
        [paragraphStyle setAlignment:textAlignment];
        [attributeText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
        if (!arrayIsEmpty(titleRedArr)) {
            for (NSString * str  in titleRedArr) {
                NSRange range = [title rangeOfString:str];
                [attributeText addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
        }
        return attributeText;
    }
    return nil;
}

/**
 *  截取字符串with rex
 *  返回一个需要 提取的每个需要标红的字符串
 *  需要几颜色的字符串
 */
- (NSArray *)subStringWithRex
{
    NSMutableArray *subStrArr = [NSMutableArray array];
    NSArray *arr = [self rangesOfChannel];
    for (NSTextCheckingResult *textResult in arr) {
        NSString *subStr = [self substringWithRange:textResult.range];
        subStr = [subStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [subStrArr addObject:subStr];
    }
    return subStrArr;
}

+ (NSString *)transfromString:(NSString *)string
{
    NSMutableString *mStr = [NSMutableString stringWithString:string];
    // 中文转拼音
    CFStringTransform((__bridge CFMutableStringRef)mStr, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mStr, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *result = [mStr uppercaseString];
    
    if (stringIsEmpty(result)) {
        return @"";
    }
    else {
        return [result substringToIndex:1];
    }
}

@end
