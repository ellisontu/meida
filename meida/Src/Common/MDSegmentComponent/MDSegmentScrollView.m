//
//  MDSegmentScrollView.m
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDSegmentScrollView.h"

#import "UIView+cframe.h"

@interface MDSegmentScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIViewController    *superControl;      /**< 外界父控制器 */
@property (nonatomic, strong) NSArray           *subControls;       /**< 存储子控制器 */
@property (nonatomic, strong) UIScrollView      *scrollView;        /**< scrollView */
@property (nonatomic, assign) NSInteger         startOffsetX;       /**< 记录刚开始时的偏移量 */
@property (nonatomic, weak) UIViewController    *previouControl;    /**< 记录加载的上个子控制器 */
@property (nonatomic, assign) NSInteger         previousIndex;      /**< 记录加载的上个子控制器的下标 */
@end

@implementation MDSegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame superControl:(UIViewController *)superControl subControls:(NSArray *)subControls
{
    if (self = [super initWithFrame:frame]) {
        
        if (superControl == nil || arrayIsEmpty(subControls)) {
            @throw [NSException exceptionWithName:@"MDSegmentScrollView" reason:@"MDSegmentScrollView 父类和子类控制器都要设置" userInfo:nil];
        }
        
        self.superControl = superControl;
        self.subControls = subControls;
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

- (void)initialization {
    _startOffsetX = 0;
    _previousIndex = -1;
}

- (void)setupSubviews {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    [self addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGFloat contentWidth = self.subControls.count * _scrollView.width;
        _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    }
    return _scrollView;
}

#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (_startOffsetX != offsetX) {
        [self.previouControl beginAppearanceTransition:NO animated:NO];
    }
    
    // 角标
    NSInteger index = offsetX / scrollView.frame.size.width;
    
    // 取出当前control
    UIViewController *currControl = self.subControls[index];
    [self.superControl addChildViewController:currControl];
    [currControl beginAppearanceTransition:YES animated:NO];
    [self.scrollView addSubview:currControl.view];
    if (_startOffsetX != offsetX) {
        [self.previouControl endAppearanceTransition];
    }
    [currControl endAppearanceTransition];
    currControl.view.frame = CGRectMake(offsetX, 0, self.width, self.height);
    [currControl didMoveToParentViewController:self.superControl];
    
    self.previouControl = currControl;
    _previousIndex = index;
    if (self.delegateSegmentView && [self.delegateSegmentView respondsToSelector:@selector(segmentScrollView:offsetX:)]) {
        [self.delegateSegmentView segmentScrollView:self offsetX:offsetX];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (self.delegateSegmentView && [self.delegateSegmentView respondsToSelector:@selector(segmentScrollView:offsetX:)]) {
        [self.delegateSegmentView segmentScrollView:self offsetX:offsetX];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > _startOffsetX) {
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        originalIndex = currentOffsetX / scrollViewW;
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.subControls.count) {
            progress = 1;
            targetIndex = self.subControls.count - 1;
        }
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    }
    else {
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        targetIndex = currentOffsetX / scrollViewW;
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.subControls.count) {
            originalIndex = self.subControls.count - 1;
        }
    }
    if (self.delegateSegmentView && [self.delegateSegmentView respondsToSelector:@selector(segmentScrollView:progress:originalIndex:targetIndex:)]) {
        [self.delegateSegmentView segmentScrollView:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}

#pragma mark - - - 给外界提供的方法，获取 MDSegmentTitleView 选中按钮的下标
- (void)setSegmentScrollViewCurrentIndex:(NSInteger)currentIndex
{
    if (self.previouControl != nil && _previousIndex != currentIndex) {
        [self.previouControl beginAppearanceTransition:NO animated:NO];
    }
    CGFloat offsetX = currentIndex * self.width;
    if (_previousIndex != currentIndex) {
        UIViewController *childVC = self.subControls[currentIndex];
        [self.superControl addChildViewController:childVC];
        [childVC beginAppearanceTransition:YES animated:NO];
        [self.scrollView addSubview:childVC.view];
        if (self.previouControl != nil && _previousIndex != currentIndex) {
            [self.previouControl endAppearanceTransition];
        }
        [childVC endAppearanceTransition];
        childVC.view.frame = CGRectMake(offsetX, 0, self.width, self.height);
        [childVC didMoveToParentViewController:self.superControl];
        self.previouControl = childVC;
    }
    
    _previousIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    if (self.delegateSegmentView && [self.delegateSegmentView respondsToSelector:@selector(segmentScrollView:offsetX:)]) {
        [self.delegateSegmentView segmentScrollView:self offsetX:offsetX];
    }
}

#pragma mark - - - set
- (void)setIsScrollEnabled:(BOOL)isScrollEnabled
{
    _isScrollEnabled = isScrollEnabled;
    if (isScrollEnabled) {
        _scrollView.scrollEnabled = YES;
    } else {
        _scrollView.scrollEnabled = NO;
    }
}


@end
