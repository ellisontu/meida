//
//  MDChoosePhotoCell.h
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MediaAssetModel;

@interface MDChoosePhotoCell : UICollectionViewCell

@property (nonatomic, strong) MediaAssetModel   *model;
@property (nonatomic, strong) NSMutableArray    *selectArr;
@property (nonatomic, strong) void (^choosePhotoCellCallBack)(void);
#pragma mark - 添加图片专用
@property (nonatomic, assign) NSInteger     maxSelectCount; /**< 最大选择数量 */

@end
