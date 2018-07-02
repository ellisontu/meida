//
//  HookUtility.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "HookUtility.h"
#import <objc/runtime.h>

@implementation HookUtility

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class class = cls;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzleImp = method_getImplementation(swizzledMethod);
    const char *swizzleType = method_getTypeEncoding(swizzledMethod);
    BOOL didAddMethod = class_addMethod(class, originalSelector, swizzleImp, swizzleType);
    
    if (didAddMethod) {
        IMP originalImp = method_getImplementation(originalMethod);
        const char *originalType = method_getTypeEncoding(originalMethod);
        class_replaceMethod(class, swizzledSelector, originalImp, originalType);
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
