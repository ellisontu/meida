//
//  MDFanshionCircleCtrl.m
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDFanshionCircleCtrl.h"
#import "MDFashCircleCategoryCtrl.h"

#import "MDSegmentTitleView.h"
#import "MDSegmentScrollView.h"

@interface MDFanshionCircleCtrl ()<MDSegmentTitleViewDelegate, MDSegmentScrollViewDelegate>

@property (nonatomic, strong) MDSegmentTitleView        *segmentTitleView;
@property (nonatomic, strong) MDSegmentScrollView       *segmentScrollView;
@property (nonatomic, strong) NSMutableArray            *childControlsArr;

@end

@implementation MDFanshionCircleCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView
{
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavShowBackAndTitleAndRight];
    [self setTitle:@"依尚圈"];
    [self setRightBtnWith:@"" image:IMAGE(@"navi_right_icon")];
    
    [self initSegmentView];
}


- (void)initSegmentView
{
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    MDSegmentTitleConfig *configure = [[MDSegmentTitleConfig alloc] init];
    configure.indicatorAdditionalWidth = 10;
    configure.showBottomSeparator = NO;
    self.segmentTitleView = [[MDSegmentTitleView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:self.segmentTitleView];
    
    for (int i = 0; i < titleArr.count; i++) {
        MDFashCircleCategoryCtrl *control = [[MDFashCircleCategoryCtrl alloc] init];
        if (i % 2 == 0) {
            control.view.backgroundColor = kDefaultBackgroundColor;
        }
        else{
            control.view.backgroundColor = kDefaultThirdTitleColor;
        }
        [self.childControlsArr addObject:control];
    }
    
    CGFloat titleViewMaxY = CGRectGetMaxY(self.segmentTitleView.frame);
    self.segmentScrollView = [[MDSegmentScrollView alloc] initWithFrame:CGRectMake(0, titleViewMaxY, SCR_WIDTH, SCR_HEIGHT - titleViewMaxY) superControl:self subControls:self.childControlsArr];
    self.segmentScrollView.delegateSegmentView = self;
    [self.view addSubview:self.segmentScrollView];
    
}

- (void)pageTitleView:(MDSegmentTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.segmentScrollView setSegmentScrollViewCurrentIndex:selectedIndex];
}

- (void)segmentScrollView:(MDSegmentScrollView *)segmentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.segmentTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (NSMutableArray *)childControlsArr
{
    if (!_childControlsArr) {
        _childControlsArr = [NSMutableArray array];
    }
    return _childControlsArr;
}


@end
