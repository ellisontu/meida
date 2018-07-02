//
//  MDTabBarSubviews.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - tabbar item ###################
@interface MDTabBarButton : UIButton

@end


#pragma mark - tabbar item title lbl ###################

typedef NS_ENUM(NSInteger, MDTabBarStyle) {
    MDTabBarStyleNumber = 0,
    MDTabBarStyleCircle
};

@interface MDTabBarLabel : UILabel

- (void)setText:(NSString *)text index:(NSInteger)index style:(MDTabBarStyle)style;

@end
