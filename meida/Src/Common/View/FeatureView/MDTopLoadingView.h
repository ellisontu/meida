//
//  MDTopLoadingView.h
//  meida
//
//  Created by ToTo on 2018/6/30.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTopLoadingView : UIWindow

+ (instancetype)shareInstance;

- (void) showTopViewInViewWithtitle:(NSString *)title delayTime:(CGFloat)time;

@end
