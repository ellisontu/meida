//
//  UIImage+InternalMethod.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (InternalMethod)

//渐减旋转图片
//- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

//定向旋转图片
- (UIImage *)imageRotatedByrotation:(UIImageOrientation)orientation;

/**
 *  获取tableView  rowAction左滑删除，编辑时的图片
 *
 *  @param title           编辑/删除
 *  @param titleColor      标题颜色
 *  @param backgroundColor 背景颜色
 *  @param image           图片
 *  @param cellHeight      cell的高度
 *
 *  @return 获得的图片
 */
+ (UIImage *)rowActionImageWithtitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image forCellHeight:(CGFloat)cellHeight;

@end
