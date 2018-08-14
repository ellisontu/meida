//
//  MDVideoPreviewView.h
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  视频预览view

#import <UIKit/UIKit.h>

@class MDVideoPreviewView,MediaAssetModel;

@protocol VideoPreviewViewDelegate <NSObject>

- (void) previewView:(MDVideoPreviewView *)view confirmSelectedIdx:(NSInteger)idx;

@end

@interface MDVideoPreviewView : UIView

+ (void) videoPreviewForAsset:(MediaAssetModel *)assetModel videoIdx:(NSInteger)videoIdx selected:(BOOL)selected delegate:(id<VideoPreviewViewDelegate>)delegate;

@end
