//
//  QuadCurveMenuItem.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol QuadCurveMenuItemDelegate;

@interface QuadCurveMenuItem : UIImageView

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;

@property (nonatomic, assign) id<QuadCurveMenuItemDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)img highlightedImage:(UIImage *)himg ContentImage:(UIImage *)cimg highlightedContentImage:(UIImage *)hcimg;

@end


@protocol QuadCurveMenuItemDelegate <NSObject>

- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item;

- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item;

@end
