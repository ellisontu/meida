//
//  MDShootPlayerView.h
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDShootPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;

@property (nonatomic, strong, readonly) NSURL *videoUrl;

@property (nonatomic,assign) BOOL autoReplay;

- (void)play;

- (void)stop;

@end
