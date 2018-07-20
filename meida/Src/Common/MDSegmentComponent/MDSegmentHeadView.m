//
//  MDSegmentHeadView.m
//  meida
//
//  Created by ToTo on 2018/7/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDSegmentHeadView.h"

@interface MDSegmentHeadView ()


@property (nonatomic,strong) UIButton   *temBtn;
@property (nonatomic,strong) UIView     *Line;

@end

@implementation MDSegmentHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self addSubview:[self creatButton:CGRectMake(0, 0, self.frame.size.width/3, 39) :@"想你的夜" :120]];
    
    [self addSubview:[self creatButton:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, 39) :@"多希望你" :121]];
    
    [self addSubview:[self creatButton:CGRectMake(self.frame.size.width*2/3, 0, self.frame.size.width/3, 39) :@"能在我身边" :122]];
    
    [self addSubview:self.Line];
}

-(UIButton *)creatButton:(CGRect)frame :(NSString *)title :(NSInteger)tag{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if (tag == 120){
        _temBtn = btn;
        btn.selected = YES;
    }
    
    btn.tag = tag;
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)btnClick:(UIButton *)btn{
    
    _temBtn.selected = NO;
    btn.selected = YES;
    _temBtn = btn;
    
    if (_delegate && [_delegate respondsToSelector:@selector(SegmentHeadViewSelectedBtutton:)]) {
        [_delegate SegmentHeadViewSelectedBtutton:btn.tag - 120];
    }
    
    switch (btn.tag) {
        case 120:
            [self setBottomLine:0];
            break;
        case 121:
            [self setBottomLine:self.frame.size.width / 3];
            break;
        case 122:
            [self setBottomLine:self.frame.size.width*2 / 3];
            break;
            
        default:
            break;
    }
}


-(void)setBottomLine:(CGFloat)x{
    
    CGRect rect = self.Line.frame;
    
    rect.origin.x = x;
    
    [UIView animateWithDuration:0.23 animations:^
    {
        
        self.Line.frame = rect;
        
    }];
}

-(void)headViewUpdateBottomLineState:(int)indexs
{
    _temBtn.selected = NO;
    UIButton *btn = (UIButton *)[self viewWithTag:120 + indexs];
    btn.selected = YES;
    _temBtn = btn;
    [self setBottomLine:self.frame.size.width *indexs / 3];
}


@end


