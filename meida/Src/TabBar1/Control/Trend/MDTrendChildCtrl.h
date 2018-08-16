//
//  MDTrendChildCtrl.h
//  meida
//
//  Created by ToTo on 2018/8/16.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDBaseViewController.h"

@protocol TrendChildScrollDelegate <NSObject>

@optional
-(void)trendChildScrollTo:(CGFloat)locattionY;

@end

typedef NS_ENUM(NSInteger, TrendScrollCellType) {
    CellTypeChannel = 0,    /**< 频道 用的 cell type */
    CellTypeUploadNew,      /**< 上新 用的 cell type */
    CellTypeRecommend,      /**< 推荐 用的 cell type */
};

@interface MDTrendChildCtrl : MDBaseViewController

@property (nonatomic, assign) TrendScrollCellType   cellType;
@property (nonatomic, weak) id<TrendChildScrollDelegate> delegate;

@end

