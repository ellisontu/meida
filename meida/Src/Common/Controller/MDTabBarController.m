//
//  MDTabBarController.m
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTabBarController.h"
#import "BaseJumpModel.h"
#import "MDTabBar.h"
#import "MDTrendControl.h"
#import "MDWardrobeControl.h"
#import "MDServicesControl.h"
#import "MDMineControl.h"

@interface MDTabBarController () <UITabBarControllerDelegate, MDTabBarDelegate>

@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) MDTabBar *tabbar;

@end

@implementation MDTabBarController

- (instancetype)init
{
    if (self = [super init]) {
        [self addChildViewControllers];
    }
    return self;
}

- (void)addChildViewControllers
{
    MDTrendControl *trendCtr        = [[MDTrendControl alloc] init];
    MDWardrobeControl *wardCtrl     = [[MDWardrobeControl alloc] init];
    MDServicesControl *serviceCtrl  = [[MDServicesControl alloc] init];
    MDMineControl *mineCtrl         = [[MDMineControl alloc] init];
    
    self.viewControllers = @[trendCtr, wardCtrl, serviceCtrl, mineCtrl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    
    if (!_tabbar) {
        _tabbar = [[MDTabBar alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - kTabBarHeight, SCR_WIDTH, kTabBarHeight)];
        _tabbar.delegate = self;
        self.tabBar.hidden = YES;
        [self.view addSubview:_tabbar];
        // 初始化添加监听者的角标，主要用于更新个人页角标
        //[[MessageManager defaultManager] sendUpdateNotification];
    }
}

#pragma mark - TabBarDelegate
- (void)tabBar:(MDTabBar *)tabBar didSelectFrom:(NSInteger)from to:(NSInteger)to
{
    NSInteger index = to;
    UIViewController *viewController = self.viewControllers[to];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    // 用户点击的时间差，如果时间差在0.5s之内，识别为双击
    NSTimeInterval shi = now-self.lastTime;
    
    if (index == kHomeTabIndex) {   // 首页
        if (self.selectedIndex == kHomeTabIndex) {
            if (shi > 1.f) {
                MDTrendControl *vc = (MDTrendControl *)viewController;
                [vc tabbarDoubleClick];
                self.lastTime = now;
            }
        }
    }
    else if (index == kStoreTabIndex) { //
        self.lastTime = now;
        if (shi <= 0.5) {
            MDWardrobeControl *vc = (MDWardrobeControl *)viewController;
            [vc tabbarDoubleClick];
            [self statisticalDataWithSelectedIndex:index];
        }
    }
    else if (index == kDiscoverTabIndex) { // 商城
        self.lastTime = now;
        if (shi <= 0.5) {
            MDServicesControl *vc = (MDServicesControl *)viewController;
            [vc tabbarDoubleClick];
        }
    }
    else if (index == kUserHomeTabIndex) {  // 发现页
        self.lastTime = now;
        if (shi <= 0.5) {
            MDMineControl *vc = (MDMineControl *)viewController;
            [vc tabbarDoubleClick];
        }
    }
    // 选中最新的控制器
    self.selectedIndex = to;
}

static NSInteger _selectedIndex = -1;

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        [self statisticalDataWithSelectedIndex:selectedIndex];
    }
    [super setSelectedIndex:selectedIndex];
    _selectedIndex = selectedIndex;
}

/**
 *  统计点击tabbar数据
 */
- (void)statisticalDataWithSelectedIndex:(NSInteger)selectedIndex
{
    NSString *source = nil;
    switch (selectedIndex) {
        case 0:
            source = BannerClickSource_tab_home;
            break;
        case 1:
            source = BannerClickSource_tab_vip;
            break;
        case 2:
            source = BannerClickSource_tab_store;
            break;
        case 3:
            source = BannerClickSource_tab_community;
            break;
        case 4:
            source = BannerClickSource_tab_mine;
            break;
        default:
            break;
    }
    // 后台统计点击事件
    [UserAnalyticsManager analyzeBannerClickByModelId:@100 locationTag:@0 source:source];
}

@end
