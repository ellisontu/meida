//
//  MDDeviceManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDDeviceManager.h"

@implementation MDDeviceManager

+ (MDDeviceManager *)sharedInstance
{
    static MDDeviceManager *userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[MDDeviceManager alloc] init];
    });
    return userManager;
}

@end
