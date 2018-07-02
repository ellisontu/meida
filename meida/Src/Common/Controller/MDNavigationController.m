//
//  MDNavigationController.m
//  meida
//
//  Created by ToTo on 2018/6/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDNavigationController.h"

@interface MDNavigationController ()<UINavigationControllerDelegate>

@end

@implementation MDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_WITH_WHITE;
    self.delegate = self;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    self.interactivePopGestureRecognizer.enabled = self.viewControllers.count > 1;
}

@end
