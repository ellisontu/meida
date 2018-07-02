//
//  NSString+TrimmingAdditions.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TrimmingAdditions)

/**
 *  去掉字符串左边的特定字符
 *
 *  @param characterSet 需要去除的特定字符集
 *
 *  @return 去除后的字符串
 */
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;

/**
 *  去掉字符串右边的特定字符
 *
 *  @param characterSet 需要去除的特定字符集
 *
 *  @return 去除后的字符串
 */
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

/**
 *  字符串中包含的所有频道字段
 *
 *  @return 频道数组
 */
- (NSArray *)rangesOfChannel;

/**
 *  将字符串转成频道样式的字符串
 *
 *  @return 频道样式的字符串
 */
- (NSMutableAttributedString *)attributedChannelStringWithColor:(UIColor *)color font:(UIFont *)font;

/**
 *  将字符串转成频道样式的字符串（并且在标签数组中存在）
 *
 *  @return 频道样式的字符串
 */
- (NSMutableAttributedString *)attributedChannelStringWithColor:(UIColor *)color font:(UIFont *)font tags:(NSArray *)tags;

/**
 *  截取字符串with 符号 "#" 一般为
 *  需要标记的红色的部分 用两个symbol括起来 比如 #你好#
 *  返回一个需要 需要标红的attribute
 */
- (NSMutableAttributedString *)attributedStringWithSymbol:(NSString *)symbol color:(UIColor *)color spaceLine:(CGFloat)spaceLine textAlignment:(NSTextAlignment)textAlignment;

/**
 *  中文转拼音 返回大写首字母
 */
+ (NSString *)transfromString:(NSString *)string;

@end
