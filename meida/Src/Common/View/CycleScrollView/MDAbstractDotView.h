//
//  MDAbstractDotView.h
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDAbstractDotView : UIView

/**
 *  A method call let view know which state appearance it should take. Active meaning it's current page. Inactive not the current page.
 *
 *  @param active BOOL to tell if view is active or not
 */
- (void)changeActivityState:(BOOL)active;


@end

@interface MDAnimatedDotView : MDAbstractDotView

@property (nonatomic, strong) UIColor   *dotColor;

@end
