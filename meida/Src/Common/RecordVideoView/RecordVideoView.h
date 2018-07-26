//
//  RecordVideoView.h
//  meida
//
//  Created by ToTo on 2018/7/25.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordVideoModel.h"

@protocol RecordVideoViewDelegate <NSObject>

@optional
-(void)dismissVC;
-(void)recordFinishWithvideoUrl:(NSURL *)videoUrl;

@end

@interface RecordVideoView : UIView

@property (nonatomic, assign) VideoViewScaleType viewType;
@property (nonatomic, strong, readonly) RecordVideoModel *fmodel;
@property (nonatomic, weak) id <RecordVideoViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame type:(VideoViewScaleType)type;
- (void)reset;

@end
