//
//  MDNetWorking.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDNetWorking.h"
#import "MDTopLoadingView.h"
#import "NSString+URLEncoding.h"
#import "MDErrorModel.h"

@interface MDNetWorking ()

@end

@implementation MDNetWorking
{
    AFNetworkReachabilityManager *_reachManager;
    NSInteger _requestNum;
}


+ (instancetype)sharedClient
{
    static MDNetWorking *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MDNetWorking alloc] init];
        [_sharedClient watchNetworkingState];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                 callback:(DataHandelCallBack)callback
{
    return [self requestWithFormatPath:path params:params httpMethod:requestType files:nil callback:callback];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                    files:(NSDictionary *)fileDic
                                 callback:(DataHandelCallBack)callback
{
    if (!callback) {
        return nil;
    }
    
    if (![self isReachable]) {
        [Util showRemindView:NSLocalizedString(@"bad_signal", nil) DelayTime:1.0];
        
        callback(NO , nil);
        return nil;
    }
    else {
        [self networkActiovityIndicatorWithAddrequestCount];
        return [self requestWithFormatPath:path params:params httpMethod:requestType files:fileDic callback:callback];
    }
}
/**
 * 该请求 处理track_info 和 stack_info的处理
 */
- (NSURLSessionDataTask *)requestWithFormatPath:(NSString *)path
                                         params:(NSDictionary *)params
                                     httpMethod:(MDHttpMethodType)requestType
                                          files:(NSDictionary *)fileDic
                                       callback:(DataHandelCallBack)callback
{

    return [self requestWithPath:path security:YES params:params httpMethod:requestType files:fileDic callback:callback];
}

#pragma mark --- 网络数据处理
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                 security:(BOOL)security
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                    files:(NSDictionary *)fileDic
                                 callback:(DataHandelCallBack)callback
{
    return [MDHttpSessionManager requestWithPath:path
                                         security:security
                                           params:params
                                       httpMethod:requestType
                                            files:fileDic
                                         callback:^(BOOL rs, NSObject *__weak obj)
            {
                DLog(@"\n----------------url-----------------------\n%@\n----------------parameters-----------------\n%@\n-------------------resp--------------------\n%@\n-------------------end---------------------",path,params,obj);
                
                [self networkActiovityIndicatorWithSubrequestCount];
                
                if (rs)
                {
                    [self requestDataSuccess:obj callBack:callback];
                }
                else
                {
                    callback(NO , obj);
                }
            }];
}

- (void) requestDataSuccess:(NSObject *__weak)obj callBack:(DataHandelCallBack)callback
{
    if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = (NSDictionary *)obj;
        if (dictionaryIsEmpty(dic) || dictionaryIsNull(dic)){
            // 字典为空
            callback(NO, nil);
        }
        else{
            if ([[dic allKeys] containsObject:@"code"]) {
                [self requestDataNewApiResponse:obj callBack:callback];
            }
            else {
                callback(YES , obj);
            }
        }
    }
    else{
        // 数据结构错误
        callback(NO , obj);
    }
}

- (void) requestDataNewApiResponse:(NSObject *__weak)obj callBack:(DataHandelCallBack)callback
{
    NSDictionary *dic = (NSDictionary *)obj;
    NSNumber *stateCode = dic[@"code"];
    id data = dic[@"data"];
    switch (stateCode.integerValue) {
        case MDRequestStateSuccess:
        {
            callback(YES , data);
        }
            break;
        case MDRequestStateInvalidToken:
        {
            // 用户授权信息token无效
            callback(NO , nil);
            [self requestStateInvalidTokenWithLogin:dic];
        }
            break;
        case MDRequestStateNoneSession:
        {
            // 没有相关session
            [[UserManager sharedInstance] logOut];
            callback(NO , [self requestDataWithCodeUnkown:dic]);
        }
            break;
        case MDRequestStateNoMoreData:
        {
            callback(YES , nil);
        }
            break;
        default:
        {
            callback(NO , [self requestDataWithCodeUnkown:dic]);
        }
            break;
    }
    
}

//下载资源文件（zip文件）
- (NSURLSessionDataTask *)downloadResourceZipByUrlString:(NSString *)urlString withParameter:(NSDictionary *)params httpMethod:(MDHttpMethodType)requestType callback:(DataHandelCallBack)callback
{
    return [MDHttpSessionManager downloadResourceZipByUrlString:urlString withParameter:params httpMethod:requestType callback:callback];
}

- (NSURLSessionDataTask *)downloadResourceWithPath:(NSString *)urlString httpMethod:(MDHttpMethodType)requestType progress:(ProgressCallBack)progress callback:(DataHandelCallBack)callback
{
    MDHttpSessionManager *sessionManager = [MDHttpSessionManager sharedClient];
    NSURLSessionDataTask *dataTask = nil;
    
    switch (requestType)
    {
        case MethodPost:
        {
            dataTask = [sessionManager POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                //DLog(@"network uploadPrlgress %@",uploadProgress);
                progress(uploadProgress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                callback(YES , responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callback(NO , nil);
            }];
        }
            break;
        case MethodGet:
        {
            
            dataTask = [sessionManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                //DLog(@"network downloadProgress %@",downloadProgress);
                progress(downloadProgress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                callback(YES , responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                callback(NO , nil);
            }];
        }
            break;
        default:
            
            break;
    }
    return dataTask;
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)urlString parameters:(id)parameters bodyWithBlock:(void (^)(id<AFMultipartFormData>))bodyBlock success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    return [[MDHttpSessionManager sharedClient] POST:urlString parameters:parameters constructingBodyWithBlock:bodyBlock progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"network uploadProgress formData %@",uploadProgress);
    } success:success failure:failure];
}


#pragma mark --- 请求状态

- (MDErrorModel *) requestDataWithCodeUnkown:(NSDictionary *)dic
{
    MDErrorModel *errorModel = [[MDErrorModel alloc] initWithDict:dic];
    errorModel.errCode = [[dic objectForKey:@"code"] integerValue];
    NSString *msg = [dic objectForKey:@"msg"];
    if (!msg)
    {
        msg = NSLocalizedString(@"request_nil", nil);
    }
    
    // 后台错误,友好提示
    if (errorModel.errCode == MDRequestSucOfBackGroudWrong)
    {
        msg = NSLocalizedString(@"back_failure", nil);
    }
    errorModel.errMsg = msg;
    errorModel.state = 0;
    errorModel.domain = NSLocalizedString(@"request_serializa", nil);
    return errorModel;
}
- (MDErrorModel *) requestStateFailureWithErrorModel:(NSInteger)code msg:(NSString *)msg
{
    MDErrorModel *errorModel = [[MDErrorModel alloc] init];
    errorModel.errCode = code;
    if (!msg) {
        msg = NSLocalizedString(@"request_nil", nil);
    }
    errorModel.errMsg = msg;
    errorModel.state = 0;
    errorModel.domain = NSLocalizedString(@"request_serializa", nil);
    return errorModel;
}


- (void)requestStateInvalidTokenWithLogin:(NSDictionary *)dic
{
    [Util showErrorMessage:dic[@"msg"] forDuration:1.5];
    [[UserManager sharedInstance] logOut];
}

#pragma mark --- 网络标识符

- (void) networkActiovityIndicatorWithAddrequestCount
{
    _requestNum ++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) networkActiovityIndicatorWithSubrequestCount
{
    _requestNum --;
    if(_requestNum <= 0)
    {
        _requestNum = 0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


#pragma mark --- 网络状态
- (void) watchNetworkingState
{
    _requestNum = 0;
    _reachManager = [AFNetworkReachabilityManager sharedManager];
    [_reachManager startMonitoring];
}

- (AFNetworkReachabilityStatus)reachability
{
    return _reachManager.networkReachabilityStatus;
}

- (BOOL) isConnectedViaWiFi
{
    return _reachManager.isReachableViaWiFi;
}

- (BOOL) isReachable
{
    return _reachManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

- (void)cancelRequestWithTask:(NSURLSessionDataTask *)task
{
    if (task) {
        [task cancel];
    }
}

- (void)cancelAllOperations
{
    MDHttpSessionManager *sessionManager = [MDHttpSessionManager sharedClient];
    [sessionManager.operationQueue cancelAllOperations];
}

@end
