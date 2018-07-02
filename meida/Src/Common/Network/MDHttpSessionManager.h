//
//  MDHttpSessionManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <AFNetworking.h>
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSUInteger, MDHttpMethodType) {
    MethodPost = 101,
    MethodGet,
    MethodPut,
    MethodHead,
    MethodPatch,
    MethodDelete,
};

//回调定义
typedef void (^NetRequestCallBack)(BOOL rs, NSDictionary * dic);
typedef void (^DataHandelCallBack)(BOOL rs, NSObject * obj);
typedef void (^ProgressCallBack)(CGFloat progress);

@interface MDHttpSessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                 security:(BOOL)security
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                    files:(NSDictionary *)fileDic
                                 callback:(DataHandelCallBack)callback;

//下载资源文件（zip文件）
+ (NSURLSessionDataTask *)downloadResourceZipByUrlString:(NSString *)urlString withParameter:(NSDictionary *)params httpMethod:(MDHttpMethodType)requestType callback:(DataHandelCallBack)callback;

@end
