//
//  SocketManager.m
//  meida
//
//  Created by ToTo on 2018/7/9.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "SocketManager.h"
#import <GCDAsyncSocket.h>

static NSString         *Khost  = @"127.0.0.1";     /**< 服务器地址 */
static const uint16_t   Kport   = 6969;             /**< 端口号 */

@interface SocketManager ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket    *socket;

@end

@implementation SocketManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static SocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
}

- (void)initSocket
{
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (BOOL)connectSocket
{
    return [_socket connectToHost:Khost onPort:Kport error:nil];
}

- (void)disConnectSocket
{
    [_socket disconnect];
}

- (void)sendMsg:(NSString *)msg
{
    NSData *data  = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    //第二个参数，请求超时时间
    [_socket writeData:data withTimeout:-1 tag:110];
}
- (void)pullTheMsg
{
    [_socket readDataWithTimeout:-1 tag:110];
}


#pragma mark - GCDAsyncSocketDelegate
//连接成功调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    XLog(@"连接成功,host:%@,port:%d",host,port);
    
    [self pullTheMsg];
    
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    XLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    
    //断线重连写在这...
    
}

//写成功的回调
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    XLog(@"写的回调,tag:%ld",tag);
}

//收到消息的回调
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    XLog(@"收到消息：%@",msg);
    
    [self pullTheMsg];
}

//分段去获取消息的回调
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{

    XLog(@"读的回调,length:%ld,tag:%ld",partialLength,tag);

}

//为上一次设置的读取数据代理续时 (如果设置超时为-1，则永远不会调用到)
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    NSLog(@"来延时，tag:%ld,elapsed:%f,length:%ld",tag,elapsed,length);
    return 10;
}


@end
