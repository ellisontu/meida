//
//  MDServicesControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  

#import "MDServicesControl.h"
#import "MDServicesCategroyCtrl.h"

#import "MDSegmentTitleView.h"
#import "MDSegmentScrollView.h"
#import "MDServicesBaseSortCell.h"

#define kBannerHH 249

@interface MDServicesControl () <MDSegmentTitleViewDelegate, MDSegmentScrollViewDelegate, CategroyScrollViewDelegate>

@property (nonatomic ,strong) MDServicesHeaderView      *headerView;
@property (nonatomic, strong) MDSegmentTitleView        *segmentTitleView;
@property (nonatomic, strong) MDSegmentScrollView       *segmentScrollView;
@property (nonatomic, strong) NSMutableArray            *childControlsArr;


@end

@implementation MDServicesControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavOnlyShowTitle];
    
    [self initSegmentView];
    
    [self intiTitleMenuView];
    
}


- (void)intiTitleMenuView
{
    
    // 设置头部信息
    [self setTitle:@"服务"];
}

- (void)initSegmentView
{
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    for (int i = 0; i < titleArr.count; i++) {
        MDServicesCategroyCtrl *control = [[MDServicesCategroyCtrl alloc] init];
        if (i % 2 == 0) {
            control.view.backgroundColor = kDefaultBackgroundColor;
        }
        else{
            control.view.backgroundColor = kDefaultThirdTitleColor;
        }
        control.delegate = self;
        [self.childControlsArr addObject:control];
    }
    CGFloat segmentHH = SCR_HEIGHT - kHeaderHeight - kTabBarHeight;
    
    self.segmentScrollView = [[MDSegmentScrollView alloc] initWithFrame:CGRectMake(0, kHeaderHeight,SCR_WIDTH, segmentHH) superControl:self subControls:self.childControlsArr];
    self.segmentScrollView.delegateSegmentView = self;
    self.segmentScrollView.isScrollEnabled = NO;
    [self.view addSubview:self.segmentScrollView];
    
    _headerView = [[MDServicesHeaderView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, SCR_WIDTH,kBannerHH)];
    [self.view addSubview:_headerView];
    
    MDSegmentTitleConfig *configure = [[MDSegmentTitleConfig alloc] init];
    configure.titleColor = kDefaultThirdTitleColor;
    configure.titleSelectedColor = kDefaultTitleColor;
    configure.showIndicator = NO;
    CGFloat titleHH = 49.f;
    self.segmentTitleView = [[MDSegmentTitleView alloc] initWithFrame:CGRectMake(0, kBannerHH - titleHH, SCR_WIDTH, titleHH) delegate:self titleNames:titleArr configure:configure];
    [_headerView addSubview:self.segmentTitleView];
    
    [self.view bringSubviewToFront:self.navigation];
    
}

- (void)pageTitleView:(MDSegmentTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.segmentScrollView setSegmentScrollViewCurrentIndex:selectedIndex];
}


/**
 * 上下滑动的时候，联动改变所有view y 坐标
 */
-(void)ServicesCategroyScrollTo:(CGFloat)locattionY
{
    XLog(@"ServicesCategroyScrollTo: %f", -locattionY);
    
    CGRect rect = _headerView.frame;
    rect.origin.y = - locattionY + kHeaderHeight;
    
    if (locattionY >= kBannerHH){
        rect.origin.y = - kBannerHH;
    }
    
    _headerView.frame = rect;
    
    if (locattionY <= kBannerHH && locattionY >=0) {
        for (MDServicesCategroyCtrl *tbCtl in self.childControlsArr) {
            tbCtl.collectionView.contentOffset = CGPointMake(0, locattionY);
        }
    }
}

- (NSMutableArray *)childControlsArr
{
    if (!_childControlsArr) {
        _childControlsArr = [NSMutableArray array];
    }
    return _childControlsArr;
}

@end
