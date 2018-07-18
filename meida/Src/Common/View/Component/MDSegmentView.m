//
//  MDSegmentView.m
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDSegmentView.h"

@interface MDSegmentView ()

@property (nonatomic, strong) UIView                *containerView;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIButton              *selectBtn;
@property (nonatomic, strong) NSLayoutConstraint    *lineConst;
@property (nonatomic, strong) NSArray               *titleArr;

@end

@implementation MDSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_HEX_STR(@"#F4F4F4");
        
        if (!arrayIsEmpty(titleArr)) {
            self.titleArr = titleArr;
            [self setupSubviews];
        }
    }
    
    return self;
}


#pragma mark - UI
- (void)setupSubviews
{
    
    _containerView = [[UIView alloc] init];
    [self addSubview:_containerView];
    _containerView.backgroundColor = [UIColor clearColor];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(35.f);
        make.right.equalTo(self).offset(-35.f);
    }];

    CGFloat titleBtnW = (SCR_WIDTH - 2 * 35.f  - _titleArr.count * kOffPadding) / _titleArr.count ;
    
    for (int i = 0; i < _titleArr.count; i ++) {
        // 标题
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        btn.titleLabel.font = FONT_SYSTEM_NORMAL(14);
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_HEX_STR(@"#8C959F") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        // 这块赋值用于下面默认初始布局
        btn.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
        btn.layer.cornerRadius = 30 * 0.5f;
        btn.layer.masksToBounds = YES;
        if (i == 0) {
            _selectBtn = btn;
            _selectBtn.titleLabel.font = FONT_SYSTEM_BOLD(14);
            [_selectBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
            _selectBtn.backgroundColor = COLOR_WITH_WHITE;
        }
        [_containerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(titleBtnW, 30.f));
            make.left.mas_equalTo(i * (titleBtnW + kOffPadding));
            make.centerY.equalTo(self.containerView);
        }];
    }
}

- (void)setHideBottomLine:(BOOL)hideBottomLine
{
    _hideBottomLine = hideBottomLine;
    
    if (_hideBottomLine) {
        _lineView.hidden = YES;
    }
    else {
        _lineView.hidden = NO;
    }
}

- (void)setupSegmentViewUnreadBtnWithIndex:(NSInteger)index hide:(BOOL)isHide
{
    UILabel *label = [self viewWithTag:200 + index];
    label.hidden = isHide;
}

#pragma mark - 事件
- (void)buttonAction:(UIButton *)sender
{
    if (sender != _selectBtn) {
        if (self.segmentViewChangeBlock) {
            self.segmentViewChangeBlock(sender.tag - 100);
            // 由 scrollView 滚动的此处不需要调 当前只有设置密码界面需要主动调用(隐藏了分割线)
            if (_hideBottomLine) {
                [self selectedSegmentViewPage:sender.tag - 100];
            }
        }
    }
    
    _selectBtn = sender;
}

- (void)selectedSegmentViewPage:(NSInteger)page
{
    UIButton *sender = [self viewWithTag:100 + page];
    if (sender != _selectBtn) {
        [sender setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
        sender.backgroundColor = COLOR_WITH_WHITE;
        sender.titleLabel.font = FONT_SYSTEM_BOLD(14);
        [_selectBtn setTitleColor:COLOR_HEX_STR(@"#8C959F") forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = FONT_SYSTEM_NORMAL(14);
        _selectBtn.backgroundColor = COLOR_HEX_STR(@"#E7E7E7");
        
        [UIView animateWithDuration:0.2 animations:^{
            self.lineConst.constant = (sender.tag - 100) * self.width / self.titleArr.count;
            [self layoutIfNeeded];
        }];
    }
    
    _selectBtn = sender;
}


#pragma mark - getter
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    
    return _titleArr;
}



@end
