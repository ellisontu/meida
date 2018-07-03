//
//  MDServicesControl.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  

#import "MDServicesControl.h"
#import "MDSegmentChildControls.h"

#import "MDSegmentTitleView.h"
#import "MDSegmentScrollView.h"
#import "UIView+cframe.h"

@interface MDServicesControl () <MDSegmentTitleViewDelegate, MDSegmentScrollViewDelegate>

@property (nonatomic, strong) MDSegmentTitleView        *segmentTitleView;
@property (nonatomic, strong) MDSegmentScrollView       *segmentScrollView;
@property (nonatomic, strong) NSMutableArray            *childControlsArr;


@end

@implementation MDServicesControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    [self setNavigationType:NavHide];
    
    [self initScrollView];
    
    [self initSegmentView];
    
    [self intiTitleMenuView];
    
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeaderHeight + 44.f + 44.f, SCR_HEIGHT, SCR_HEIGHT - kHeaderHeight - 44.f -44.f - kTabBarHeight)];
    [self.view addSubview:self.scrollView];

}

- (void)intiTitleMenuView
{
    
    // 设置头部信息
    UILabel *tipsLblView = [[UILabel alloc] init];
    [self.view addSubview:tipsLblView];
    tipsLblView.font = FONT_SYSTEM_NORMAL(20);
    tipsLblView.textColor = kDefaultTitleColor;
    tipsLblView.text = @"预约";
    [tipsLblView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeaderHeight + 10);
        make.left.equalTo(self.view).offset(koffset);
    }];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_WIDTH - 44.f, kStatusBarHeight, 44.f, 44.f)];
    [self.view addSubview:rightBtn];
    [rightBtn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    [rightBtn setImage:IMAGE(@"navi_right_icon") forState:UIControlStateNormal];
}

- (void)initSegmentView
{
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    MDSegmentTitleConfig *configure = [[MDSegmentTitleConfig alloc] init];
    configure.indicatorAdditionalWidth = 10;
    configure.showBottomSeparator = NO;
    self.segmentTitleView = [[MDSegmentTitleView alloc] initWithFrame:CGRectMake(0, kHeaderHeight + 44.f, SCR_WIDTH, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:self.segmentTitleView];
    
    for (int i = 0; i < titleArr.count; i++) {
        MDSegmentChildControls *control = [[MDSegmentChildControls alloc] initStyle:1];
        if (i % 2 == 0) {
            control.view.backgroundColor = kDefaultBackgroundColor;
        }
        else{
            control.view.backgroundColor = kDefaultThirdTitleColor;
        }
        [self.childControlsArr addObject:control];
    }
   
    self.segmentScrollView = [[MDSegmentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentTitleView.frame),SCR_WIDTH, self.scrollView.height) superControl:self subControls:self.childControlsArr];
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
