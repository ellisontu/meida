//
//  InputView.m
//  meida
//
//  Created by toto on 18/9/1.
//  Copyright (c) 2018年 ymfashion. All rights reserved.
//

#import "InputView.h"

@interface InputView ()<UITextViewDelegate>
{
    CGFloat origin_X;
    CGFloat inputView_H;
    CGFloat inputView_W;
    UILabel *placeHold;
    UIFont *inputFont;
    CGFloat flag_H;
}
@end

@implementation InputView

- (instancetype)initWithSuperVC:(UIViewController *)superVC
{
    origin_X = 10;
    inputView_H = 45;
    flag_H = inputView_H;
    inputFont = FONT_SYSTEM_NORMAL(16.f);
    CGFloat VCWidth = SCR_WIDTH;
    CGFloat VCHeight = SCR_HEIGHT;
    CGRect frame = CGRectMake(0, VCHeight-inputView_H, VCWidth, inputView_H);
    self = [super initWithFrame:frame];
    if (self) {
        inputView_W = VCWidth-80;
        _inputTV = [[UITextView alloc] initWithFrame:CGRectMake(origin_X, 5, inputView_W, 35)];
        _inputTV.font = inputFont;
        _inputTV.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
        _inputTV.layer.borderWidth = 1.0f;
        _inputTV.layer.cornerRadius = 5.0f;
        _inputTV.layer.masksToBounds = YES;
        _inputTV.returnKeyType = UIReturnKeySend;
        _inputTV.delegate = self;
        [self addSubview:_inputTV];
        
        //输入框的提示语
        placeHold = [[UILabel alloc] initWithFrame:CGRectMake(10-3, 0, inputView_W-10, 35)];
        placeHold.text = @"回复评论:";
        placeHold.font = FONT_SYSTEM_NORMAL(14);
        placeHold.textColor = [UIColor grayColor];
        [_inputTV addSubview:placeHold];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(VCWidth-65+2.5, 7, 55, 31);
        //UIImage *image = IMAGE(@"dianzai");
        //[_sendButton setImage:image forState:UIControlStateNormal];
        //image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[_sendButton setBackgroundImage:[UIImage imageNamed:@"comment_send_dis"] forState:UIControlStateDisabled];
        //[_sendButton setBackgroundImage:[UIImage imageNamed:@"comment_send_enable"] forState:UIControlStateNormal];
        
        [_sendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(InputView:sendMessage:)]) {
        [self.delegate InputView:self sendMessage:_inputTV.text];
    }
}

- (void)setPlaceholderStr:(NSString *)placeholderStr
{
    _placeholderStr = placeholderStr;
    placeHold.text = placeholderStr;
}

- (void)resetView
{
    placeHold.hidden = NO;
    _inputTV.text = nil;
    _inputTV.height = 35;
    flag_H = inputView_H;
    self.height = inputView_H;
    [_inputTV resignFirstResponder];
    self.hidden = YES;
}

#pragma mark - UITextViewDelegate - methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHold.hidden = textView.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    placeHold.hidden = textView.text.length > 0;
    //计算文本的高度
    CGSize constraintSize = CGSizeMake(inputView_W, MAXFLOAT);
    CGSize newSize = getStringSize(textView.text, constraintSize, inputFont);
    CGFloat str_H = newSize.height;
    CGFloat view_H = inputView_H;
    if (str_H > 90) {
        str_H = 100;
        view_H = str_H+origin_X;
    }
    else if (str_H > 35) {
        str_H = newSize.height+origin_X;
        view_H = str_H+origin_X;
    }
    else {
        str_H = 35;
    }
    if (view_H != flag_H) {
        textView.frame = CGRectMake(origin_X, 5, inputView_W, str_H);
        self.frame = CGRectMake(0, CGRectGetMinY(self.frame)-(view_H-flag_H), SCR_WIDTH, view_H);
        flag_H = view_H;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    placeHold.hidden = textView.text.length > 0;
    [self resetView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = nil;
    if ([text isEqualToString:@"\n"]) {
        str = [NSString stringWithFormat:@"%@", textView.text];
    }
    else {
        str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    }
    //限制字数 256字以内
//    if (textView.text.length > 256) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能超过256，否则超出部分无法显示！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        str = [str substringToIndex:256];
//    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([_delegate respondsToSelector:@selector(InputView:sendMessage:)]) {
            [self.delegate InputView:self sendMessage:str];
        }
        textView.text = nil;
        placeHold.hidden = NO;
        return NO;
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
