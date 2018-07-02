//
//  UIView+MDHitTest.h
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView * (^MDHitTestViewBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
typedef BOOL (^MDPointInsideBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);

@interface UIView (MDHitTest)

@property(nonatomic, strong) MDHitTestViewBlock hitTestBlock;

@property(nonatomic, strong) MDPointInsideBlock pointInsideBlock;

@end
