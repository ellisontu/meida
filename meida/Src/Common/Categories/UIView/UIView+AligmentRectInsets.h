//
//  UIView+AligmentRectInsets.h
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIEdgeInsets(^MDAlignmentRectInsets)(void);

@interface UIView (AligmentRectInsets)

/**
 实现这个Block，可以将视图间的间距算到视图的内容中
 */
@property (nonatomic, copy) MDAlignmentRectInsets alignmentRectInsetsBlock;

@end
