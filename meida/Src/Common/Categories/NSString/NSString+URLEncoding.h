//
//  NSString+URLEncoding.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString:(int)codingNum;
- (NSDictionary *)PareseDic;
@end
