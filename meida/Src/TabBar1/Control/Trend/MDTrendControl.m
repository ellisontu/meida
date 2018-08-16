//
//  MDTrendControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTrendControl.h"
#import "MDTrendChildCtrl.h"

#import "MDSegmentTitleView.h"
#import "MDSegmentScrollView.h"

#define ksegmentHH 49

@interface MDTrendControl ()<MDSegmentTitleViewDelegate, MDSegmentScrollViewDelegate, TrendChildScrollDelegate >

@property (nonatomic, strong) UIView                *headerView;
@property (nonatomic, strong) NSMutableArray        *childScrollArr;
@property (nonatomic, strong) MDSegmentTitleView    *segmentTitleView;
@property (nonatomic, strong) MDSegmentScrollView   *segmentScrollView;

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
    
    for (int i = 0; i < titleArray.count; i++) {
        MDTrendChildCtrl *control = [[MDTrendChildCtrl alloc] init];
        
        if (0 == i) {
            control.cellType = CellTypeChannel;
        }
        else if (1 == i){
            control.cellType = CellTypeUploadNew;
        }
        else if (2 == i){
            control.cellType = CellTypeRecommend;
        }
        control.delegate = self;
        [self.childScrollArr addObject:control];
    }
    CGFloat segmentHH = SCR_HEIGHT - kHeaderHeight - kTabBarHeight;
    
    self.segmentScrollView = [[MDSegmentScrollView alloc] initWithFrame:CGRectMake(0, kHeaderHeight,SCR_WIDTH, segmentHH) superControl:self subControls:self.childScrollArr];
    self.segmentScrollView.delegateSegmentView = self;
    self.segmentScrollView.isScrollEnabled = NO;
    [self.view addSubview:self.segmentScrollView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH,ksegmentHH)];
    [self.view addSubview:_headerView];
    
    MDSegmentTitleConfig *configure = [[MDSegmentTitleConfig alloc] init];
    CGFloat padding = (SCR_WIDTH - 95 * 3) * 0.25;
    configure.spacingBetweenButtons = padding;
    configure.btnScrollStyle = BtnScrollStyleStyleCommon;
    configure.titleColor = kDefaultThirdTitleColor;
    configure.titleSelectedColor = kDefaultTitleColor;
    configure.showIndicator = NO;
    configure.showBottomSeparator = NO;
    
    self.segmentTitleView = [[MDSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, ksegmentHH) delegate:self titleNames:titleArray configure:configure];
    [_headerView addSubview:self.segmentTitleView];
    self.segmentTitleView.backgroundColor = COLOR_HEX_STR(@"#F4F4F4");

    [self.view bringSubviewToFront:self.navigation];
    
}

- (void)pageTitleView:(MDSegmentTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.segmentScrollView setSegmentScrollViewCurrentIndex:selectedIndex];
}

- (void)segmentScrollView:(MDSegmentScrollView *)segmentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.segmentTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}



/**
 * 上下滑动的时候，联动改变所有view y 坐标
 */
-(void)trendChildScrollTo:(CGFloat)locattionY
{
    CGRect rect = _headerView.frame;
    rect.origin.y = - locattionY + kHeaderHeight;
    
    if (locattionY >= ksegmentHH){
        rect.origin.y = - ksegmentHH;
    }
    
    _headerView.frame = rect;
    
    if (locattionY <= ksegmentHH && locattionY >=0) {
        for (MDTrendChildCtrl *tbCtl in self.childScrollArr) {
            tbCtl.collectionView.contentOffset = CGPointMake(0, locattionY);
        }
    }
}

#pragma mark - scrollViewDelegate

- (NSMutableArray *)childScrollArr
{
    if (!_childScrollArr) {
        _childScrollArr = [NSMutableArray array];
    }
    return _childScrollArr;
}

@end
