//
//  NSString+URLEncoding.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                            kCFStringEncodingUTF8));
    return result;
}

- (NSString *)URLDecodedString:(int)codingNum
{
    NSString *result = [NSString stringWithString:self];
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            codingNum));
    
    return result;
}

- (NSDictionary *)PareseDic
{
    NSArray *contentArr = [self componentsSeparatedByString:@","];
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    for (NSString * content in contentArr) {
        NSArray *childArr = [content componentsSeparatedByString:@"="];
        NSString *key =[childArr objectAtIndex:0];
        NSString *value = [childArr objectAtIndex:1];
        [returnDic setObject:value forKey:key];
    }
    return returnDic;
}
@end
