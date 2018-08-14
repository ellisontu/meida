//
//  MDTrendControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendControl.h"

#import "MDSegmentView.h"
#import "MDTrendBaseScrollView.h"

#define ksegmentHH 49

@interface MDTrendControl ()<UIScrollViewDelegate, TrendBaseScrollViewDelegate>

@property (nonatomic, strong) MDSegmentView     *segmentView;
@property (nonatomic, assign) NSInteger         segmentIndex;       /**< segment index 位置 */
@property (nonatomic, strong) NSMutableArray    *childScrollArr;

@end

@implementation MDTrendControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self initView];
    
}

- (void)initView
{
    [self setNavigationType:NavShowTitleAndRiht];
    
    [self setTitle:@"看看"];
    [self setRightBtnWith:@"" image:IMAGE(@"navi_right_icon")];
    [self setupLineView:NO];
    
    // 标题
    NSArray *titleArray = @[@"专题", @"上新", @"推荐"];
    [self setupScrollView:titleArray];
    
    _segmentView = [[MDSegmentView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, 50) titleArr:titleArray];
    MDWeakPtr(weakPtr, self);
    _segmentView.segmentViewChangeBlock = ^(NSInteger index) {
        NSInteger page = (NSInteger)(weakPtr.scrollView.contentOffset.x / SCR_WIDTH);
        if (page != index) {
            [weakPtr.scrollView setContentOffset:CGPointMake(index * SCR_WIDTH, 0) animated:YES];
        }
    };
    [self.view addSubview:_segmentView];
}

- (void)setupScrollView:(NSArray *)titleArray
{
    // 各分类--背景容器
    CGFloat scrollViewH = SCR_HEIGHT - kTabBarHeight - kTabBarHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, scrollViewH)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCR_WIDTH * titleArray.count, self.scrollView.height);
    [self.view addSubview:self.scrollView];

    MDTrendBaseScrollView *channelView = [[MDTrendBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, scrollViewH) withCellType:CellTypeChannel];
    MDTrendBaseScrollView *uploadNew = [[MDTrendBaseScrollView alloc] initWithFrame:CGRectMake(SCR_WIDTH, 0, SCR_WIDTH, scrollViewH) withCellType:CellTypeUploadNew];
    MDTrendBaseScrollView *recommendView = [[MDTrendBaseScrollView alloc] initWithFrame:CGRectMake(2 * SCR_WIDTH, 0, SCR_WIDTH, scrollViewH) withCellType:CellTypeRecommend];
    
    channelView.delegate = self;
    uploadNew.delegate = self;
    recommendView.delegate = self;
    
    [self.scrollView addSubview:channelView];
    [self.scrollView addSubview:uploadNew];
    [self.scrollView addSubview:recommendView];
    
    [self.childScrollArr addObject:channelView];
    [self.childScrollArr addObject:uploadNew];
    [self.childScrollArr addObject:recommendView];
    
    // 设置选中位置
    if (_segmentIndex < 0) {
        _segmentIndex = 1;
    }
    [self.scrollView setContentOffsetX:SCR_WIDTH * _segmentIndex];
}

#pragma mark - scrollViewDelegate
// 左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / SCR_WIDTH + 0.5);
    [_segmentView selectedSegmentViewPage:page];
}

// 上下滑动
-(void)trendBaseScrollViewScrollTo:(CGFloat)locattionY
{
    CGRect rect = _segmentView.frame;
    rect.origin.y = - locattionY + kHeaderHeight;

    if (locattionY >= ksegmentHH){
        rect.origin.y = - ksegmentHH;
    }

    _segmentView.frame = rect;

    if (locattionY <= ksegmentHH && locattionY >=0) {
        for (MDTrendBaseScrollView *view in self.childScrollArr) {
            view.collectionView.contentOffset = CGPointMake(0, locattionY);
        }
    }
}

- (NSMutableArray *)childScrollArr
{
    if (!_childScrollArr) {
        _childScrollArr = [NSMutableArray array];
    }
    return _childScrollArr;
}

@end
