//
//  InputView.h
//  meida
//
//  Created by toto on 18/9/1.
//  Copyright (c) 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputView;

@protocol InputViewDelegate <NSObject>

@required
//点击发送按钮时执行
- (void)InputView:(InputView *)inputView sendMessage:(NSString *)message;

@end


@interface InputView : UIView

@property (nonatomic, weak) id<InputViewDelegate> delegate;

@property (nonatomic, strong) UIButton   *sendButton;

@property (nonatomic, strong) UITextView *inputTV;

@property (nonatomic, strong) NSString   *placeholderStr;

- (instancetype)initWithSuperVC:(UIViewController *)superVC;

- (void)resetView;

@end
