//
//  UIView+mdHitTest.m
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UIView+MDHitTest.h"

@implementation UIView (mdHitTest)

const static NSString *STHitTestViewBlockKey = @"MDHitTestViewBlockKey";
const static NSString *STPointInsideBlockKey = @"MDPointInsideBlockKey";

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(hitTest:withEvent:)),
                                   class_getInstanceMethod(self, @selector(md_hitTest:withEvent:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(pointInside:withEvent:)),
                                   class_getInstanceMethod(self, @selector(md_pointInside:withEvent:)));
}

- (UIView *)md_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSMutableString *spaces = [NSMutableString stringWithCapacity:20];
    UIView *superView = self.superview;
    while (superView) {
        [spaces appendString:@"----"];
        superView = superView.superview;
    }
    //    NSLog(@"%@%@:[hitTest:withEvent:]", spaces, NSStringFromClass(self.class));
    UIView *deliveredView = nil;
    
    if (self.hitTestBlock) {
        BOOL returnSuper = NO;
        deliveredView = self.hitTestBlock(point, event, &returnSuper);
        if (returnSuper) {
            deliveredView = [self md_hitTest:point withEvent:event];
        }
    } else {
        deliveredView = [self md_hitTest:point withEvent:event];
    }
    //    NSLog(@"%@%@:[hitTest:withEvent:] Result:%@", spaces, NSStringFromClass(self.class), NSStringFromClass(deliveredView.class));
    return deliveredView;
}

- (BOOL)md_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSMutableString *spaces = [NSMutableString stringWithCapacity:20];
    UIView *superView = self.superview;
    while (superView) {
        [spaces appendString:@"----"];
        superView = superView.superview;
    }
    //    NSLog(@"%@%@:[pointInside:withEvent:]", spaces, NSStringFromClass(self.class));
    BOOL pointInside = NO;
    if (self.pointInsideBlock) {
        BOOL returnSuper = NO;
        pointInside =  self.pointInsideBlock(point, event, &returnSuper);
        if (returnSuper) {
            pointInside = [self md_pointInside:point withEvent:event];
        }
    } else {
        pointInside = [self md_pointInside:point withEvent:event];
    }
    return pointInside;
}

- (void)setHitTestBlock:(MDHitTestViewBlock)hitTestBlock
{
    objc_setAssociatedObject(self, (__bridge const void *)(STHitTestViewBlockKey), hitTestBlock, OBJC_ASSOCIATION_COPY);
}

- (MDHitTestViewBlock)hitTestBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(STHitTestViewBlockKey));
}

- (void)setPointInsideBlock:(MDPointInsideBlock)pointInsideBlock
{
    objc_setAssociatedObject(self, (__bridge const void *)(STPointInsideBlockKey), pointInsideBlock, OBJC_ASSOCIATION_COPY);
}

- (MDPointInsideBlock)pointInsideBlock {
    return objc_getAssociatedObject(self, (__bridge const void *)(STPointInsideBlockKey));
}

@end
