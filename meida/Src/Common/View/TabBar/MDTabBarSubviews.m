//
//  MDTabBarSubviews.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTabBarSubviews.h"

@implementation MDTabBarButton

// 去除高亮效果
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end


#pragma mark - tabbar item title lbl ###################
CGFloat const circelH = 8.f;
CGFloat const numberH = 18.f;
CGFloat const labelY  = 3.f;

@implementation MDTabBarLabel

- (void)setText:(NSString *)text index:(NSInteger)index style:(MDTabBarStyle)style
{
    if (style == MDTabBarStyleNumber) {
        self.text = text;
        
        CGFloat textW = 0;
        switch (text.length) {
            case 1:
                textW = numberH;
                self.layer.cornerRadius = numberH/2;
                self.font = FONT_SYSTEM_NORMAL(13);
                break;
                
            case 2:
                textW = 24.f;
                self.layer.cornerRadius = numberH/2;
                self.font = FONT_SYSTEM_NORMAL(13);
                break;
                
            case 3:
                textW = 24.f;
                self.layer.cornerRadius = numberH/2;
                self.font = FONT_SYSTEM_NORMAL(10);
                break;
            default:
                break;
        }
        
        CGFloat buttonW = SCR_WIDTH/5;
        CGRect frame = self.frame;
        frame.origin.x = buttonW * index + buttonW/2 + 10.f;
        frame.origin.y = labelY;
        frame.size.width = textW;
        frame.size.height = numberH;
        self.frame = frame;
    }
    else {
        self.layer.cornerRadius = circelH/2;
        CGFloat buttonW = SCR_WIDTH/5;
        CGRect frame = self.frame;
        frame.origin.x = buttonW * index + buttonW/2 + 10.f;
        frame.origin.y = labelY;
        frame.size.height = circelH;
        frame.size.width = circelH;
        self.frame = frame;
    }
}

@end
