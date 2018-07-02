//
//  UIView+AligmentRectInsets.m
//  meida
//
//  Created by ToTo on 2018/3/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UIView+AligmentRectInsets.h"

#import <objc/runtime.h>

@implementation UIView (AligmentRectInsets)
@dynamic alignmentRectInsetsBlock;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        SEL originalSelector = @selector(alignmentRectInsets);
        SEL swizzledSelector = @selector(MD_AlignmentRectInsets);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (UIEdgeInsets)MD_AlignmentRectInsets
{
    if (self.alignmentRectInsetsBlock) {
        return self.alignmentRectInsetsBlock();
    }
    else
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)setmdAlignmentRectInsetsBlock:(MDAlignmentRectInsets)alignmentRectInsetsBlock
{
    objc_setAssociatedObject(self, @"alignmentRectInsets", alignmentRectInsetsBlock, OBJC_ASSOCIATION_COPY);
}

- (MDAlignmentRectInsets)alignmentRectInsetsBlock
{
    return objc_getAssociatedObject(self, @"alignmentRectInsets");
}

@end
