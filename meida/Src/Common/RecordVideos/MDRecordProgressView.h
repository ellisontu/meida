//
//  MDRecordProgressView.h
//  meida
//
//  Created by ToTo on 2018/8/14.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRecordProgressView : UIView

- (void)updateProgressWithValue:(CGFloat)progress;
- (void)resetProgress;

@end
