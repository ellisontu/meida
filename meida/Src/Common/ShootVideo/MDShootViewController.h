//
//  MDShootViewController.h
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  自定义 - 拍照和录视频

#import "MDBaseViewController.h"
#import "MDShootManager.h"

@class MDShootViewController;

@protocol MDShootViewControllerrDelegate <NSObject>

@required
- (void)videoViewController:(MDShootViewController *)videoController didRecordVideo:(VideoModel *)videoModel;

@optional
- (void)videoViewControllerDidCancel:(MDShootViewController *)videoController;

@end


@interface MDShootViewController : MDBaseViewController

@property (nonatomic, weak) id<MDShootViewControllerrDelegate> delegate;

@end
