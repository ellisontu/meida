//
//  MDTrendRecommendView.h
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -  潮流 -> 推荐 -> view ################################################----------
@interface MDTrendRecommendView : UIView

@end

#pragma mark -  潮流 -> 推荐 -> user cell view ################################################----------
@interface MDTrendRecommendViewUserCell : UITableViewCell

@end

@interface MDTrendRecommendViewUserCellItem : UICollectionViewCell
@end

#pragma mark -  潮流 -> 推荐 -> content cell view ################################################----------

@interface MDTrendRecommendViewContentCell : UITableViewCell

@end

@interface MDTrendRecommendViewContentCellItem : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView       *imageView;

@end
