//
//  MDAnimationRecordView.h
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDAnimationRecordView : UIView

@property (nonatomic, copy) void(^startRecord)(void);
@property (nonatomic, copy) void(^completeRecord)(CFTimeInterval recordTime); //录制时长
@property (nonatomic, assign) CGFloat longPressMin;

@end
