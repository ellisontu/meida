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

- (void)setTabBarSeletedIndex:(NSInteger)seletedIndex;

@end

