//
//  MDNetWorking.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDHTTPSessionManager.h"
@interface MDNetWorking : NSObject

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                 callback:(DataHandelCallBack)callback;

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                    files:(NSDictionary *)fileDic
                                 callback:(DataHandelCallBack)callback;

//下载资源文件（zip文件）
- (NSURLSessionDataTask *)downloadResourceZipByUrlString:(NSString *)urlString withParameter:(NSDictionary *)params httpMethod:(MDHttpMethodType)requestType callback:(DataHandelCallBack)callback;

// 下载资源文件 (视频处)
- (NSURLSessionDataTask *)downloadResourceWithPath:(NSString *)urlString httpMethod:(MDHttpMethodType)requestType progress:(ProgressCallBack)progress callback:(DataHandelCallBack)callback;


/**
 *  埋点处 post 表单发送数据
 *
 *  @param urlString  url
 *  @param parameters 参数
 *  @param bodyBlock  表单发送
 *  @param success    success block
 *  @param failure    failure block
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)urlString parameters:(id)parameters bodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (BOOL) isReachable;

- (BOOL) isConnectedViaWiFi;

/**
 *  取消指定网络请求
 */
- (void)cancelRequestWithTask:(NSURLSessionDataTask *)task;

/**
 *  取消所有网络请求
 */
- (void)cancelAllOperations;

@end
