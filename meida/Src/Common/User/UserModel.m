//
//  UserModel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


+ (NSMutableArray *)decodeJsonArray:(id)json
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (!json || [json isKindOfClass:[NSNull class]])
        return array;
    for (NSDictionary *dict in json) {
        //[array addObject:[UserModel decodeJson:dict]];
        [array addObject:[[UserModel alloc] initWithDict:dict]];
    }
    return array;
}

- (BOOL)isPhoneBinded
{
    if (self.phone && self.phone.length > 1 && [[self.phone substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


@end
