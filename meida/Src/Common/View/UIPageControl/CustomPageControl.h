//
//  CustomPageControl.h
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIPageControl

@property (nonatomic)   UIImage * currentImage; /**< 高亮图片 */
@property (nonatomic)   UIImage * defaultImage; /**< 默认图片 */
@property (nonatomic,assign)   CGSize pageSize; /**< 图标大小 */

-(instancetype)initWithFrame:(CGRect)frame currentImage:(UIImage *)currentImage defaultImage:(UIImage *)defaultImage;

@end
