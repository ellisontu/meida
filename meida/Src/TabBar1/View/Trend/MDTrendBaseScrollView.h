//
//  MDTrendBaseScrollView.h
//  meida
//
//  Created by ToTo on 2018/7/20.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  潮流 -- 通用scroll view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TrendScrollCellType) {
    CellTypeChannel = 0,    /**< 频道 用的 cell type */
    CellTypeUploadNew,      /**< 上新 用的 cell type */
    CellTypeRecommend,      /**< 推荐 用的 cell type */
};

@protocol TrendBaseScrollViewDelegate <NSObject>

@optional
-(void)trendBaseScrollViewScrollTo:(CGFloat)locattionY;

@end

@interface MDTrendBaseScrollView : UIView

@property (nonatomic, strong) UICollectionView      *collectionView;

- (instancetype)initWithFrame:(CGRect)frame withCellType:(TrendScrollCellType )cellType;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@property (nonatomic, weak) id<TrendBaseScrollViewDelegate> delegate;

@end
