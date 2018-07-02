//
//  UIButton+EnlargeArea.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIButton(EnlargeArea)

- (void) setEnlargeEdge:(CGFloat) edge;

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
