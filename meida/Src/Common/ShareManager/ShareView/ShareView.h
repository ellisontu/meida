//
//  ShareView.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  自定义分享View

#import <UIKit/UIKit.h>
#import "MDShareInfoModel.h"

@interface ShareView : UIView


/**
 *  选择分享平台后的回调
 *  platform    用户选择的分享平台
 */
@property (nonatomic, copy) void (^SharePlatformSeletedBlock) (NSString *platform);

@property (nonatomic, copy) MDBlock dismissBlock;

/**
 *  初始化方法
 *  flag 是为了 控制是否显示分享页面上的加的自定义view
 */
- (instancetype)initWithPlatformsArray:(NSArray *)platforms shareInfoModel:(MDShareInfoModel *)model;

/**
 *  显示
 */
- (void)show;

/**
 *  隐藏
 */
- (void)dismiss;

@end
