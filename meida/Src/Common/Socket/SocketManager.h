//
//  SocketManager.h
//  meida
//
//  Created by ToTo on 2018/7/9.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketManager : NSObject

+ (instancetype)shareInstance;
- (instancetype)init NS_UNAVAILABLE;

- (BOOL)connectSocket;              /**< 链接 host */
- (void)disConnectSocket;           /**< 断开链接 */

- (void)sendMsg:(NSString *)msg;    /**< 发送消息 */
- (void)pullTheMsg;                 /**<  */

@end
