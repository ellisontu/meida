//
//  MDTrendControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendControl.h"

#import "MDSegmentView.h"
#import "MDTrendChannelView.h"
#import "MDTrendUploadNewView.h"
#import "MDTrendRecommendView.h"


@interface MDTrendControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) MDSegmentView     *segmentView;
@property (nonatomic, assign) NSInteger         segmentIndex;       /**< segment index 位置 */

@end

@implementation MDTrendControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavShowTitleAndRiht];
    
    [self setupTitleMenuView];
    
}

- (void)setupTitleMenuView
{
    [self setTitle:@"看看"];
    [self setRightBtnWith:@"" image:IMAGE(@"navi_right_icon")];
    [self setupLineView:NO];

    // 标题
    NSArray *titleArray = @[@"专题", @"上新", @"推荐"];
    _segmentView = [[MDSegmentView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, 50) titleArr:titleArray];
    
    [self.view addSubview:_segmentView];
    
    [self setupScrollView:titleArray];
    
}

- (void)setupScrollView:(NSArray *)titleArray
{
    MDWeakPtr(weakPtr, self);
    _segmentView.segmentViewChangeBlock = ^(NSInteger index) {
        NSInteger page = (NSInteger)(weakPtr.scrollView.contentOffset.x / SCR_WIDTH);
        if (page != index) {
            [weakPtr.scrollView setContentOffset:CGPointMake(index * SCR_WIDTH, 0) animated:YES];
        }
    };
    // 各分类--背景容器
    CGFloat scrollViewY = CGRectGetMaxY(_segmentView.frame);
    CGFloat scrollViewH = SCR_HEIGHT - scrollViewY - kTabBarHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, SCR_WIDTH, scrollViewH)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCR_WIDTH * titleArray.count, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    // 关于我
    MDTrendChannelView *channelView = [[MDTrendChannelView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, scrollViewH)];
    [self.scrollView addSubview:channelView];
    // 动态
    MDTrendUploadNewView *uploadNew = [[MDTrendUploadNewView alloc] initWithFrame:CGRectMake(SCR_WIDTH, 0, SCR_WIDTH, scrollViewH)];
    [self.scrollView addSubview:uploadNew];
    // 通知
    MDTrendRecommendView *recommendView = [[MDTrendRecommendView alloc] initWithFrame:CGRectMake(2 * SCR_WIDTH, 0, SCR_WIDTH, scrollViewH)];
    [self.scrollView addSubview:recommendView];
    // 设置选中位置
    if (_segmentIndex < 0) {
        _segmentIndex = 1;
    }
    [self.scrollView setContentOffsetX:SCR_WIDTH * _segmentIndex];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / SCR_WIDTH + 0.5);
    [_segmentView selectedSegmentViewPage:page];
}

@end
