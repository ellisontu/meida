//
//  AppDelegate.h
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDNavigationController.h"
#import "MDTabBarController.h"

#define MDAPPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) MDNavigationController *navigation;
@property (nonatomic, strong, readonly) MDTabBarController     *rvc;
@property (nonatomic, assign) BOOL isApproved;          /**< 标记App是否审核通过（存储在本地） */

- (void)setTabBarSeletedIndex:(NSInteger)seletedIndex;

// apns related
- (void)apnsRegisterAlias:(NSString *)alias;
- (void)requestSeverConfig;
// 获取数美 deviceId
- (NSString *)getSMDeviceId;

/***************************************************************
 以下函数需要评估代码位置
 ***************************************************************/

- (BOOL)isClipFutureTipShowed;

- (BOOL)canShowRecordStepTip;
- (void)addRecordStepTipShowCount;
@end

