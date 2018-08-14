//
//  MDChooseVideoCtrl.h
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDBaseViewController.h"

#pragma mark -  拍摄 选择视频或者选择录制 controller #############################################----------

typedef NS_ENUM(NSInteger, VideoGallaryType)
{
    VideoGallaryToShare = 0,  //用于拍摄分享的第一步
    VideoGallaryToAdd,        //用于选择几段视频
};

@protocol VideoGallaryCtrlDelegate;

@interface MDChooseVideoCtrl : MDBaseViewController

- (instancetype) initWithVideoChosenType:(VideoGallaryType)type maxLimitCount:(NSInteger)count;

@property (nonatomic, weak) id<VideoGallaryCtrlDelegate> delegate;


@end

@protocol VideoGallaryCtrlDelegate <NSObject>

@optional
- (void) videoGallaryCtrl:(MDChooseVideoCtrl *)ctrl videoList:(NSArray *)videoList;

@end


#pragma mark -  拍摄 选择视频或者选择录制 controller cell #############################################----------
@class MediaAssetModel, MDVideoGallaryCell;

@protocol VideoGallaryCellDelegate <NSObject>

- (BOOL) videoCell:(MDVideoGallaryCell *)cell videoIdx:(NSInteger)videoIdx selected:(BOOL)selected;

@end

@interface MDVideoGallaryCell : UICollectionViewCell

@property (assign,nonatomic) id<VideoGallaryCellDelegate> delegate;

- (void) updateCellImage:(MediaAssetModel *)assetModel videoIdx:(NSInteger)videoIdx;

- (void) setSelectedStatus:(BOOL)isSelected;

@end
