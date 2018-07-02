//
//  MDTabBarManager.h
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTabBarManager : NSObject

@property (nonatomic, assign, readonly, getter=isDuringActive) BOOL duringActive;
@property (nonatomic, strong, readonly) NSString *zipUrl;
@property (nonatomic, strong, readonly) NSDictionary *zipParams;
@property (nonatomic, copy) MDBlock     tabBarFetchSuccessBlock;

+ (MDTabBarManager *)sharedInstance;

/**
 获取tabbar未选中图片
 */
- (NSArray *)tabbarImageNameArray;

/**
 tabbar高亮状态图片
 */
- (NSArray *)tabbarHighLightImageArray;

/**
 tabbar标题
 */
- (NSArray *)tabbarNameArray;

/**
 检查是否需要更新活动图标
 */
- (void)checkIfNeedFecthImageWithZipParams:(NSDictionary *)zipParams;

@end
