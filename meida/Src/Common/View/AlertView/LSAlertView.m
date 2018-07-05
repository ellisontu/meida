//
//  LSAlertView.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "LSAlertView.h"

@interface LSAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *conetntView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation LSAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<LSAlertViewDelegate>)delegate leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _title = title;
        _message = message;
        [self initData];
        [self initViewWithTitle:title message:message leftButtonTitle:leftTitle rightButtonTitle:rigthTitle];
    }
    return self;
}

- (void)initData
{
    _bgColor = COLOR_WITH_WHITE;
    _titleLabelFont = FONT_SYSTEM_NORMAL(16.f);
    _titleLabelTextColor = COLOR_WITH_BLACK;
    _contentLabelFont = FONT_SYSTEM_NORMAL(15.f);
    _contentLabelTextColor = kDefaultSubTitleColor;
    _btnTitleFont = FONT_SYSTEM_NORMAL(14.f);
    _leftBtnColor = COLOR_WITH_BLACK;
    _rightBtnColor = COLOR_WITH_BLACK;
}

- (void)initViewWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle
{
    CGRect frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
    
    _bgView = [[UIView alloc] initWithFrame:frame];
    _bgView.backgroundColor = [COLOR_WITH_BLACK colorWithAlphaComponent:0.48f];
    [self addSubview:_bgView];
    
    CGFloat contentView_W = SCR_WIDTH * 0.733f;
    CGFloat contentView_H = contentView_W * 0.6f;
    CGFloat contentView_Y = SCR_WIDTH * 0.573f;
    _conetntView = [UIView newAutoLayoutView];
    _conetntView.backgroundColor = _bgColor;
    _conetntView.layer.cornerRadius = 5.f;
    _conetntView.layer.masksToBounds = YES;
    [self addSubview:_conetntView];
    [_conetntView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:contentView_Y];
    //此处宽高单独赋值，方便以后扩展自定义宽高
    [_conetntView autoSetDimension:ALDimensionWidth toSize:contentView_W];
    [_conetntView autoSetDimension:ALDimensionHeight toSize:contentView_H];
    [_conetntView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    CGFloat titleLabel_topInset = contentView_W * 0.11f;
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.text = title;
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelTextColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_conetntView addSubview:_titleLabel];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:titleLabel_topInset];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.f];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10.f];
    
    CGFloat messageLabel_bottomInset = contentView_W * 0.24f;
    _messageLabel = [UILabel newAutoLayoutView];
    //_messageLabel.text = message;
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = _contentLabelFont;
    _messageLabel.textColor = _contentLabelTextColor;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_conetntView addSubview:_messageLabel];
    
    if (!stringIsEmpty(message)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3.f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *baseAttrs = @{NSFontAttributeName:_contentLabelFont,
                                    NSForegroundColorAttributeName:_contentLabelTextColor,
                                    NSParagraphStyleAttributeName:paragraphStyle};
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message];
        [attrString addAttributes:baseAttrs range:NSMakeRange(0, message.length)];
        _messageLabel.attributedText = attrString;
    }
    
    if (stringIsEmpty(title)) {
        [_messageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:contentView_W * 0.037f];
    }
    else {
        [_messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel];
    }
    [_messageLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_titleLabel];
    [_messageLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_titleLabel];
    [_messageLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:messageLabel_bottomInset];
    
    CGFloat lineHorizontal_bottomInset = contentView_W * 0.2f;
    UIView *lineHorizontal = [UIView newAutoLayoutView];
    lineHorizontal.backgroundColor = kDefaultSeparationLineColor;
    [_conetntView addSubview:lineHorizontal];
    [lineHorizontal autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [lineHorizontal autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [lineHorizontal autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:lineHorizontal_bottomInset];
    [lineHorizontal autoSetDimension:ALDimensionHeight toSize:0.5f];
    
    UIView *lineVertical = [UIView newAutoLayoutView];
    lineVertical.backgroundColor = kDefaultSeparationLineColor;
    [_conetntView addSubview:lineVertical];
    [lineVertical autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [lineVertical autoSetDimension:ALDimensionWidth toSize:0.5f];
    [lineVertical autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineHorizontal];
    [lineVertical autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    _leftBtn = [UIButton newAutoLayoutView];
    _leftBtn.titleLabel.font = _btnTitleFont;
    [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [_leftBtn setTitleColor:_leftBtnColor forState:UIControlStateNormal];
    [_conetntView addSubview:_leftBtn];
    [_leftBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_leftBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [_leftBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineHorizontal];
    [_leftBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:lineVertical];
    [_leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton newAutoLayoutView];
    _rightBtn.titleLabel.font = _btnTitleFont;
    [_rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
    [_rightBtn setTitleColor:_rightBtnColor forState:UIControlStateNormal];
    [_conetntView addSubview:_rightBtn];
    [_rightBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_rightBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [_rightBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineHorizontal];
    [_rightBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:lineVertical];    
    [_rightBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableAttributedString *)getMutableAttributedString:(NSString *)originStr font:(UIFont *)font color:(UIColor *)color
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *baseAttrs = @{NSFontAttributeName:font,
                                NSForegroundColorAttributeName:color,
                                NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attrString addAttributes:baseAttrs range:NSMakeRange(0, originStr.length)];
    return attrString;
}

- (void)buttonClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        NSInteger buttonIndex = 0;
        if (sender == _rightBtn) {
            buttonIndex = 1;
        }
        [_delegate alertView:self clickedButtonAtIndex:buttonIndex];
        [self dismiss];
    }
}

- (void)show
{
    self.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
    [MDAPPDELEGATE.window addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _messageLabel.text = message;
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    _conetntView.backgroundColor = bgColor;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = titleLabelFont;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setContentLabelFont:(UIFont *)contentLabelFont
{
    _contentLabelFont = contentLabelFont;
    _messageLabel.font = contentLabelFont;
    NSMutableAttributedString *attrStr = [self getMutableAttributedString:_message font:_contentLabelFont color:_contentLabelTextColor];
    _messageLabel.attributedText = attrStr;
}

- (void)setContentLabelTextColor:(UIColor *)contentLabelTextColor
{
    _contentLabelTextColor = contentLabelTextColor;
    _messageLabel.textColor = contentLabelTextColor;
    NSMutableAttributedString *attrStr = [self getMutableAttributedString:_message font:_contentLabelFont color:_contentLabelTextColor];
    _messageLabel.attributedText = attrStr;
}

- (void)setBtnTitleFont:(UIFont *)btnTitleFont
{
    _btnTitleFont = btnTitleFont;
    _leftBtn.titleLabel.font = btnTitleFont;
    _rightBtn.titleLabel.font = btnTitleFont;
}

- (void)setLeftBtnColor:(UIColor *)leftBtnColor
{
    _leftBtnColor = leftBtnColor;
    [_leftBtn setTitleColor:leftBtnColor forState:UIControlStateNormal];
}

- (void)setRightBtnColor:(UIColor *)rightBtnColor
{
    _rightBtnColor = rightBtnColor;
    [_rightBtn setTitleColor:rightBtnColor forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
