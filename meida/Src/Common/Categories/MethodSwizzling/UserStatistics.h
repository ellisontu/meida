//
//  UserStatistics.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatistics : NSObject

@property (nonatomic, strong) NSString *currentClassName;   /**< 标记当前所在VC */

/**
 *  初始化配置，一般在launchWithOption中调用
 */
+ (void)configure;

+ (UserStatistics *)sharedInstance;

+ (void)enterPageViewWithPageID:(NSString *)pageID;

+ (void)leavePageViewWithPageID:(NSString *)pageID;

+ (void)sendEventToServer:(NSString *)eventId;

@end
