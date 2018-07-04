//
//  UIButton+ConentInsets.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ContentPositionStyle) {
    PositionStyleDefault,   /**< 图左，文右 */
    PositionStyleRight,     /**< 图右，文左 */
    PositionStyleTop,       /**< 图上，文字下 */
    PositionStyleBottom     /**< 图下，文字上 */
};


@interface UIButton (ConentInsets)

/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)imagePositionStyle:(ContentPositionStyle )imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;

@end
