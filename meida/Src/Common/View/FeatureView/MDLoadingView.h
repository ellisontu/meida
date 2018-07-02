//
//  MDLoadingView.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LoadingMode) {
    NormalLoadingMode,
    ProgressLoadingMode
};

@interface MDLoadingView : NSObject

@property (nonatomic, assign) CGFloat loadingProgress;

@property (nonatomic, assign) LoadingMode loadingMode;

+ (instancetype)shareInstance;

- (void) hide:(BOOL)animated;
- (void) showInView:(UIView *)view withText:(NSString *)text animated:(BOOL)animated;

// 进度条
- (void)multiMediaShowInView:(UIView *)view withText:(NSString *)text progress:(NSInteger)progress withloadingMode:(LoadingMode)mode;
@end

typedef NS_ENUM(NSInteger, LoadingViewMode) {
    NormalLoadingViewMode,
    ProgressLoadingViewMode
};

@interface MDLoadContainerView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) LoadingViewMode loadingViewMode;

- (void) addLoadingViewWithText:(NSString *)text;
- (void) startAnimation;
- (void) stopAnimation;

@end
