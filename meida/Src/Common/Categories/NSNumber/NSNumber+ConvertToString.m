//
//  NSNumber+ConvertToString.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "NSNumber+ConvertToString.h"

@implementation NSNumber (ConvertToString)

- (NSString *)decimalNumberConvertToString
{
    if (!self) {
        return @"0.00";
    }
    double doubleValue = [self doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
