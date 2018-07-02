//
//  NSNumber+ConvertToString.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (ConvertToString)

/**
 number 类型数据转为字符串（解决iOS解析 Number 类型数据，精度丢失问题）
 
 @param conversionValue 需要做转换的数据
 @return 字符串类型数据
 */
- (NSString *)decimalNumberConvertToString;

@end
