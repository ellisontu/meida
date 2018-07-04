//
//  MDFlipCarFlowLayout.h
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDFlipCarFlowLayoutDelegate <NSObject>

- (void)scrollToIndex:(NSInteger)index;

@end


@interface MDFlipCarFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat   previousOffsetX;
@property (nonatomic, weak) id<MDFlipCarFlowLayoutDelegate> delegate;

@end


@interface MDFlipCarCellView : UICollectionViewCell

@end
