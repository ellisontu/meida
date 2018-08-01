//
//  MDWardrobeViewCell.h
//  meida
//
//  Created by ToTo on 2018/7/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -  衣橱 -> cell view #############################################----------
@interface MDWardrobeViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end


#pragma mark -  衣橱 -> 头部 view #############################################----------
@interface WardrobeAfterClothHeadView : UICollectionReusableView

@end


#pragma mark -  衣橱 -> 底部 ->  view #############################################----------
@interface WardrobeAfterClothFooterView : UICollectionReusableView

@end

