//
//  SharePosterView.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  分享会员邀请海报时的分享View

#import <UIKit/UIKit.h>
#import "MDShareInfoModel.h"

@interface SharePosterView : UIView

@property (nonatomic, copy) MDBlock dismissBlock;

/**
 *  选择分享平台后的回调
 *  platform    用户选择的分享平台
 */
@property (nonatomic, copy) void (^SharePlatformSeletedBlock) (NSString *platform, BOOL isSharePoster);

/**
 *  初始化方法
 *  platforms   分享的所有平台
 *  model       分享信息Model
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



#pragma mark - SharePosterViewCell -
@interface SharePosterViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *platformName;   /**< 分享平台name */

@end
