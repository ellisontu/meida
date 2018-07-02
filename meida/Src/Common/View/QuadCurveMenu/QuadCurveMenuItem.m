//
//  QuadCurveMenuItem.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import "QuadCurveMenuItem.h"

@interface QuadCurveMenuItem ()
{
    UIImageView *contentImageView;
}
@end

static inline CGRect ScaleRect(CGRect rect, float n) {
    return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);
    
}

@implementation QuadCurveMenuItem

#pragma mark - initialization & cleaning up
- (instancetype)initWithImage:(UIImage *)img highlightedImage:(UIImage *)himg ContentImage:(UIImage *)cimg highlightedContentImage:(UIImage *)hcimg
{
    if (self = [super init]) {
        self.image = img;
        self.highlightedImage = himg;
        self.userInteractionEnabled = YES;
        contentImageView = [[UIImageView alloc] initWithImage:cimg];
        contentImageView.highlightedImage = hcimg;
        [self addSubview:contentImageView];
    }
    return self;
}


#pragma mark - UIView's methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    float width = contentImageView.image.size.width;
    float height = contentImageView.image.size.height;
    contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesBegan:)]) {
        [_delegate quadCurveMenuItemTouchesBegan:self];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if move out of 2x rect, cancel highlighted.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location)) {
        self.highlighted = NO;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    // if stop in the area of 2x rect, response to the touches event.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location)) {
        if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesEnd:)]) {
            [_delegate quadCurveMenuItemTouchesEnd:self];
        }
    }
}

#pragma mark - instant methods
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [contentImageView setHighlighted:highlighted];
}

@end
