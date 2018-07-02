//
//  AppNotifications.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#ifndef meida_AppNotifications_h
#define meida_AppNotifications_h

// 你关注的人上传了视频，用于更新关注小红点
#define kNotificationHasNewAttentionVideo   @"newAttentionVideo"
// 退出登录时发送的通知
#define kLogoutNotification                 @"kLogoutNotification"

//支付成功发送的通知
#define kNotificationPaySuccess             @"kNotificationPaySuccess"

//tabbar双击通知react页面
#define kNotificationTabbarDoubleClick      @"kNotificationTabbarDoubleClick"

/**
 *  会在操作完直接修改对象然后发送通知，接收到通知的进行数据同步与UI刷新
 *  Cell更新UI 不同的数组更新数据
 */

#define COMMENTKEY   @"commentkey"
#define VIDEOKEY     @"videokey"

static NSString *const CommentNotification       = @"CommentDoneNotification";
static NSString *const PublishDoneNotification   = @"PublishNotification";
static NSString *const LoginSuccessNotification  = @"LoginSuccessNotification";
static NSString *const LoginFailNotification     = @"LoginFailNotification";
static NSString *const PosterStateChangeNotiofication = @"PosterStateChangeNotiofication";

#endif
