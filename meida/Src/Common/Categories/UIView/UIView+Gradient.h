//
//  UIView+Gradient.h
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gradient)

/**
 *  黑到白的渐变
 */
- (void)gradientWhiteToBlack;

/**
 *  根据颜色起始点和终点设置渐变
 */
- (void)gradientWithColorArray:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
