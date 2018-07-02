//
//  LSAlertView.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import <UIKit/UIKit.h>

@class LSAlertView;

@protocol LSAlertViewDelegate <NSObject>
@optional

- (void)alertView:(LSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


/**
 自定义 AlertView
 */
@interface LSAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id <LSAlertViewDelegate>)delegate leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;

@property (nonatomic, weak)   id <LSAlertViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UIColor *bgColor;               /**< 默认白色 < alertView 的背景色 > */
@property (nonatomic, strong) UIFont *titleLabelFont;         /**< 默认16.0 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;   /**< 默认黑色 */
@property (nonatomic, strong) UIFont *contentLabelFont;       /**< 默认15.0 */
@property (nonatomic, strong) UIColor *contentLabelTextColor; /**< 默认kDefaultSubTitleColor */
@property (nonatomic, strong) UIFont *btnTitleFont;           /**< 默认14.0 */
@property (nonatomic, strong) UIColor *leftBtnColor;          /**< 默认黑色 */
@property (nonatomic, strong) UIColor *rightBtnColor;         /**< 默认黑色 */

- (void)show;

@end


