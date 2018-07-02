//
//  TextLabel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "KYLabel.h"

@interface KYLabel ()
{
    NSMutableAttributedString *_attrStr;
    NSMutableParagraphStyle *_style;
    NSString *_copyTitle;
}
@end

@implementation KYLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    _autoAdjustHeight = NO;
    _canCopy = NO;
    _copyTitle = @"复制订单号";
    _style = [[NSMutableParagraphStyle alloc] init];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"font"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
            _attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    if ([keyPath isEqualToString:@"font"]) {
        [self configFinished];
    }
}

#pragma mark - Copy Function
// 添加Touch事件
-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action == @selector(kyCopy:);
}

- (void)kyCopy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

- (void)handleTap:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:_copyTitle action:@selector(kyCopy:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

#pragma mark - Setting Method
- (void)setCanCopy:(BOOL)canCopy
{
    _canCopy = canCopy;
    if (_canCopy == YES) {
        [self attachTapHandler];
    }
}

- (void)setAutoAdjustHeight:(BOOL)autoAdjustHeight
{
    _autoAdjustHeight = autoAdjustHeight;
    [self configFinished];
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
    _style.lineSpacing = lineSpace;
    [self setConfigFinished];
}

- (void)setLetterSpace:(CGFloat)letterSpace
{
    _letterSpace = letterSpace;
    [_attrStr addAttribute:NSKernAttributeName value:@(_letterSpace) range:NSMakeRange(0, self.text.length)];
    [self configFinished];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing
{
    _paragraphSpacing = paragraphSpacing;
    _style.paragraphSpacing = _paragraphSpacing;
    [self setConfigFinished];
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent
{
    _firstLineHeadIndent = firstLineHeadIndent;
    _style.firstLineHeadIndent = _firstLineHeadIndent;
    [self setConfigFinished];
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore
{
    _paragraphSpacingBefore = paragraphSpacingBefore;
    _style.paragraphSpacingBefore = _paragraphSpacingBefore;
    [self setConfigFinished];
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple
{
    _lineHeightMultiple = lineHeightMultiple;
    _style.lineHeightMultiple = _lineHeightMultiple;
    [self setConfigFinished];
}

#pragma mark - Outlet Method
- (void)setCopyTitle:(NSString *)copyTitle
{
    _copyTitle = copyTitle;
}

- (void)setUnderlineStyle:(UnderlineStyle)underlineStyle withRange:(NSRange)range
{
    if (range.length == 0) {
        return;
    }
    [_attrStr addAttribute:NSUnderlineStyleAttributeName value:@(underlineStyle) range:range];
    [self configFinished];
}

- (void)setUnderlineStyle:(UnderlineStyle)underlineStyle withString:(NSString *)string
{
    if (string.length == 0)
        return;
    NSRange range;
    NSRange newRange = NSMakeRange(0, self.text.length);
    while (1) {
        range = [self.text rangeOfString:string options:NSCaseInsensitiveSearch range:newRange];
        newRange = NSMakeRange(range.location + range.length, self.text.length - range.length - range.location);
        if (range.location == NSNotFound) {
            break;
        }
        [self setUnderlineStyle:underlineStyle withRange:range];
    }

}

- (void)setDeletelineWithRange:(NSRange)range
{
    if (range.length == 0) {
        return;
    }
    [_attrStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    [self configFinished];
}

- (void)setDeletelineWithString:(NSString *)string
{
    if (string.length == 0)
        return;
    NSRange range;
    NSRange newRange = NSMakeRange(0, self.text.length);
    while (1) {
        range = [self.text rangeOfString:string options:NSCaseInsensitiveSearch range:newRange];
        newRange = NSMakeRange(range.location + range.length, self.text.length - range.length - range.location);
        if (range.location == NSNotFound) {
            break;
        }
        [self setDeletelineWithRange:[self.text rangeOfString:string]];
    }
}

- (void)setStringFont:(UIFont *)font withRange:(NSRange)range
{
    if (range.length == 0) {
        return;
    }
    [_attrStr addAttribute:NSFontAttributeName value:font range:range];
    [self configFinished];
}

- (void)setStringFont:(UIFont *)font withString:(NSString *)string
{
    if (string.length == 0) {
        return;
    }
    [self setStringAttribute:font withString:string];
}

- (void)setStringColor:(UIColor *)color withRange:(NSRange)range
{
    if (range.length == 0) {
        return;
    }
    [_attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self configFinished];
}

- (void)setStringColor:(UIColor *)color withString:(NSString *)string
{
    if (string.length == 0) {
        return;
    }
    [self setStringAttribute:color withString:string];
}


#pragma mark - Commen Method
- (void)setStringAttribute:(id)attribute withString:(NSString *)string
{
    NSRange range;
    NSRange newRange = NSMakeRange(0, self.text.length);
    while (1) {
        range = [self.text rangeOfString:string options:NSCaseInsensitiveSearch range:newRange];
        newRange = NSMakeRange(range.location + range.length, self.text.length - range.length - range.location);
        if (range.location == NSNotFound) {
            break;
        }
        
        if ([attribute isKindOfClass:[UIFont class]]) {
            [self setStringFont:(UIFont *)attribute withRange:range];
        }
        if ([attribute isKindOfClass:[UIColor class]]) {
            [self setStringColor:(UIColor *)attribute withRange:range];
        }
        
    }
}

- (void)setConfigFinished
{
    [_attrStr addAttribute:NSParagraphStyleAttributeName value:_style range:NSMakeRange(0, self.text.length)];
    [self configFinished];
}

- (void)configFinished
{
    self.attributedText = _attrStr;
    // 重新计算高度
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
    CGFloat height = _autoAdjustHeight ? size.height : self.frame.size.height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, height);
}

@end
