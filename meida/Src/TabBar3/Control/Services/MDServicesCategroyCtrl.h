//
//  MDServicesCategroyCtrl.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  SegmentView child control

#import "MDBaseViewController.h"

typedef NS_ENUM(NSInteger, SegmentChildViewType) {
    TypeCollectionView = 1, /**< 竖排: 类似瀑布流 */
    TypeTabeleView          /**< 横排: 类似 tableview  */
};

@interface MDServicesCategroyCtrl : MDBaseViewController

- (instancetype)initStyle:(SegmentChildViewType )controlType;     /**<  唯一初始化入口 : 1.瀑布流，2.*/

- (instancetype)init NS_UNAVAILABLE;

@end
