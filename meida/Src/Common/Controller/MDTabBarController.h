//
//  MDTabBarController.h
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTabBar.h"

#define kHomeTabIndex     0
#define kStoreTabIndex    1
#define kDiscoverTabIndex 2
#define kUserHomeTabIndex 3

@interface MDTabBarController : UITabBarController

@property (nonatomic, strong, readonly) MDTabBar *tabbar;

@end
