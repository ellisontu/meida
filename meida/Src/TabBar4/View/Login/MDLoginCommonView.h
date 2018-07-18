//
//  MDLoginCommonView.h
//  meida
//
//  Created by ToTo on 2018/7/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  登录用 view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserClickType) {
    ClickTypeLogin,         // 点击了登录
    ClickTypeRegister       // 点击了注册
};

#pragma mark - 登录 view ############ -------------------
@interface MDLoginView : UIView

- (instancetype)initWithFrame:(CGRect)frame withMainView:(UIView *)mainView;
- (void)cancelAllEidit;

// NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end


#pragma mark - 注册 view ############ -------------------
@interface MDRegisterView : UIView

- (instancetype)initWithFrame:(CGRect)frame withMainView:(UIView *)mainView;
- (void)cancelAllEidit;

// NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


typedef NS_ENUM(NSInteger, LoginPlatform) {
    LoginPlatformWechat = 1,    /**< 微信登录 */
    LoginPlatformQQ,            /**< QQ登录 */
    LoginPlatformSina,          /**< 新浪登录 */
    LoginPlatformPhone          /**< 手机登录 */
};

#pragma mark - 第三方登录或注册 view ############ -------------------
@interface MDThirdPlatformView : UIView

@property (nonatomic, copy) void (^thirdPlatformBlock)(LoginPlatform paltformType);

@end
