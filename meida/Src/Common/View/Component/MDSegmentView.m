//
//  MDSegmentView.m
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDSegmentView.h"

@interface MDSegmentView ()

@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIButton              *selectBtn;
@property (nonatomic, strong) NSLayoutConstraint    *lineConst;
@property (nonatomic, strong) NSArray               *titleArr;

@end

@implementation MDSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WITH_WHITE;
        
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
    UIView *conView = [UIView newAutoLayoutView];
    [self addSubview:conView];
    [conView autoPinEdgesToSuperviewEdges];
    
    CGFloat titleBtnW = self.width / _titleArr.count;
    
    for (int i = 0; i < _titleArr.count; i ++) {
        // 标题
        UIButton *btn = [UIButton newAutoLayoutView];
        btn.tag = i + 100;
        [conView addSubview:btn];
        btn.titleLabel.font = FONT_SYSTEM_NORMAL(16);
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:kDefaultThirdTitleColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [btn autoSetDimensionsToSize:CGSizeMake(titleBtnW, self.height)];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:titleBtnW * i];
        // 这块赋值用于下面默认初始布局
        if (i == 0) {
            _selectBtn = btn;
            _selectBtn.titleLabel.font = FONT_SYSTEM_BOLD(16);
            [_selectBtn setTitleColor:RED forState:UIControlStateNormal];
        }
        
        // 角标
        UILabel *unreadLbl = [UILabel newAutoLayoutView];
        [conView addSubview:unreadLbl];
        unreadLbl.hidden = YES;
        unreadLbl.tag = i + 200;
        unreadLbl.backgroundColor = RED;
        unreadLbl.layer.cornerRadius = 4;
        unreadLbl.layer.masksToBounds = YES;
        [unreadLbl autoSetDimensionsToSize:CGSizeMake(8, 8)];
        [unreadLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:btn.titleLabel];
        [unreadLbl autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:btn.titleLabel];
    }
    
    // 红线
    UIView *bottomView = [UIView newAutoLayoutView];
    [conView addSubview:bottomView];
    bottomView.backgroundColor = RED;
    CGSize strSize = getStringSize(_titleArr[0], CGSizeMake(100, 25), FONT_SYSTEM_NORMAL(16));
    _lineConst = [bottomView autoAlignAxis:ALAxisVertical toSameAxisOfView:_selectBtn];
    [bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [bottomView autoSetDimensionsToSize:CGSizeMake(strSize.width + 20, 2)];
    
    // 分割线
    _lineView = [UIView newAutoLayoutView];
    _lineView.backgroundColor = kDefaultBackgroundColor;
    [conView addSubview:_lineView];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_lineView autoSetDimensionsToSize:CGSizeMake(self.width, OnePixScale)];
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
        [sender setTitleColor:RED forState:UIControlStateNormal];
        sender.titleLabel.font = FONT_SYSTEM_BOLD(16);
        [_selectBtn setTitleColor:kDefaultThirdTitleColor forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = FONT_SYSTEM_NORMAL(16);
        
        [UIView animateWithDuration:0.2 animations:^{
            _lineConst.constant = (sender.tag - 100) * self.width / _titleArr.count;
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
