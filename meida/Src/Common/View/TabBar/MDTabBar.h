//
//  MDTabBar.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDTabBar;

@protocol MDTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MDTabBar *)tabBar didSelectFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface MDTabBar : UIView

@property (nonatomic, weak) id<MDTabBarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setBadge:(NSString *)badge atIndex:(NSInteger)index;

- (void)setPointBadgeHidden:(BOOL)hidden atIndex:(NSInteger)index;

@end
