//
//  MDServicesCategroyCtrl.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  SegmentView child control

#import "MDBaseViewController.h"

//typedef NS_ENUM(NSInteger, SegmentChildViewType) {
//    TypeCollectionView = 1, /**< 竖排: 类似瀑布流 */
//    TypeTabeleView          /**< 横排: 类似 tableview  */
//};

@protocol CategroyScrollViewDelegate <NSObject>

@optional
-(void)ServicesCategroyScrollTo:(CGFloat)locattionY;

@end

@interface MDServicesCategroyCtrl : MDBaseViewController

@property (nonatomic, weak) id<CategroyScrollViewDelegate> delegate;

@end
