//
//  MDExceptionManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 收集崩溃信息的管理类
 */
@interface MDExceptionManager : NSObject

+ (void)saveException:(NSException *)exception;

+ (void)checkLocalException;

@end
