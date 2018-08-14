//
//  MDSegmentHeadView.h
//  meida
//
//  Created by ToTo on 2018/7/19.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  这个做上下滑动时候，联动用

#import <UIKit/UIKit.h>

@protocol SegmentHeadViewDelegate <NSObject>

@optional
-(void)SegmentHeadViewSelectedBtutton:(NSInteger)index;

@end

@interface MDSegmentHeadView : UIView


@property (nonatomic,weak)id<SegmentHeadViewDelegate>delegate;

-(void)headViewUpdateBottomLineState:(int)indexs;

@end
