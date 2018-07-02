//
//  MDHttpSessionManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDHTTPSessionManager.h"
#import "CommonCrypto/CommonDigest.h"
#import "CommonCrypto/CommonHMAC.h"
#import "MDErrorModel.h"
#import "MDDeviceManager.h"
#import "ttc_encrypt_v2.h"

#define ISLOGIN     [[UserManager sharedInstance] loginUser]
#define PASSWORD    [[[UserManager sharedInstance] loginUser] password]

@implementation MDHttpSessionManager

+ (instancetype)sharedClient
{
    static MDHttpSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        configure.timeoutIntervalForRequest = 60.f;
        _sharedClient = [[MDHttpSessionManager alloc] initWithSessionConfiguration:configure];
        _sharedClient.operationQueue.maxConcurrentOperationCount = 10;
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/zip",@"text/json", @"text/plain", @"text/html", nil];
        [_sharedClient.requestSerializer setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
        
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.securityPolicy = securityPolicy;
        //        securityPolicy.validatesDomainName = NO;
    });
    
    return _sharedClient;
}

//下载资源文件（zip文件）
+ (NSURLSessionDataTask *)downloadResourceZipByUrlString:(NSString *)urlString withParameter:(NSDictionary *)params httpMethod:(MDHttpMethodType)requestType callback:(DataHandelCallBack)callback
{
    MDHttpSessionManager *sessionManager = [MDHttpSessionManager sharedClient];
    NSURLSessionDataTask *dataTask = nil;
    switch (requestType)
    {
        case MethodPost:
        {
            dataTask = [sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                //DLog(@"network uploadPrlgress %@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                callback(YES , responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callback(NO , nil);
            }];
        }
            break;
        case MethodGet:
        {
            
            dataTask = [sessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                //DLog(@"network downloadProgress %@",downloadProgress);
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

+ (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                                 security:(BOOL)security
                                   params:(NSDictionary *)params
                               httpMethod:(MDHttpMethodType)requestType
                                    files:(NSDictionary *)fileDic
                                 callback:(DataHandelCallBack)callback
{
    MDHttpSessionManager *sessionManager = [MDHttpSessionManager sharedClient];
    NSURLSessionDataTask *dataTask = nil;
    
    NSString *urlString = nil;
    if (security) {
        urlString = path;
    }
    else {
        urlString = path;
    }
    
    switch (requestType)
    {
        case MethodPost:
        {
            dataTask = [sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                //DLog(@"network uploadPrlgress %@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSError *error = nil;
                id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:kNilOptions
                                                              error:&error];
                [[MDHttpSessionManager sharedClient] requestDataCallBackWithSuccessOrFailure:error callBack:callback dataResult:result];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                callback(NO , [[MDHttpSessionManager sharedClient] netWorkFailureWithNSErrorChangeErrorModel:error]);
            }];
            
        }
            break;
        case MethodPut:
        {
            dataTask = [sessionManager PUT:urlString
                                parameters:params
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                        {
                            NSError *error = nil;
                            id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                        options:kNilOptions
                                                                          error:&error];
                            [[MDHttpSessionManager sharedClient] requestDataCallBackWithSuccessOrFailure:error callBack:callback dataResult:result];
                        }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                        {
                            callback(NO , [[MDHttpSessionManager sharedClient] netWorkFailureWithNSErrorChangeErrorModel:error]);
                        }];
        }
            break;
        case MethodGet:
        {
            dataTask = [sessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                //DLog(@"network downloadProgress %@",downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSError *error = nil;
                id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:kNilOptions
                                                              error:&error];
                [[MDHttpSessionManager sharedClient] requestDataCallBackWithSuccessOrFailure:error callBack:callback dataResult:result];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                callback(NO , [[MDHttpSessionManager sharedClient] netWorkFailureWithNSErrorChangeErrorModel:error]);
            }];
        }
            break;
        case MethodHead:
        {
            
        }
            break;
        case MethodPatch:
        {
            
        }
            break;
        case MethodDelete:
        {
            dataTask = [sessionManager DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NSError *error = nil;
                id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:kNilOptions
                                                              error:&error];
                [[MDHttpSessionManager sharedClient] requestDataCallBackWithSuccessOrFailure:error callBack:callback dataResult:result];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                callback(NO , [[MDHttpSessionManager sharedClient] netWorkFailureWithNSErrorChangeErrorModel:error]);
            }];
        }
            break;
        default:
            
            break;
    }
    
    return dataTask;
}

#pragma mark --- 设置header,hash

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    NSURLSessionDataTask *dataTask = nil;
    [self createAuthRequest:&request];
    dataTask = [super dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
    return dataTask;
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    [self createAuthRequest:&request];
    return [super uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:completionHandler];
}

- (void)createAuthRequest:(NSMutableURLRequest **)request
{
    NSMutableURLRequest *req = *request;
    NSString *url = [req.URL description];
    NSString *replaceStr = [NSString stringWithFormat:@"%@://%@",req.URL.scheme,req.URL.host];
    if (req.URL.port) {
        replaceStr = [NSString stringWithFormat:@"%@:%@",replaceStr,req.URL.port];
    }
    NSString *resultUrlStr = [url stringByReplacingOccurrencesOfString:replaceStr withString:@""];
    NSDictionary *authDic = [self authHeaderData:resultUrlStr];
    if (authDic)
    {
        for (NSString *key in [authDic allKeys])
        {
            NSString *authValue = authDic[key];
            [req addValue:authValue forHTTPHeaderField:key];
        }
    }
    //    [req setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
}

- (NSDictionary *)authHeaderData:(NSString *)url
{
    unsigned long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeStamp = [NSString stringWithFormat:@"%lld", time];
    
    NSString *device_id = filterValue([MDDeviceManager sharedInstance].deviceIden);
    //NSString *requestIdStr = [Util md5:[NSString stringWithFormat:@"%@%@",device_id,timeStamp]];
    NSString *custom_device_id = [[NSUserDefaults standardUserDefaults] objectForKey:kCustomDeviceId];
    NSString *requestIdStr = [NSString stringWithFormat:@"%@%@", custom_device_id, timeStamp];
    NSArray *separatedArray = [requestIdStr componentsSeparatedByString:@"-"];
    NSArray *randomCharAry = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p"];
    NSString *resultStr = @"";
    //把 requestIdStr 中每个 '-' 替换为不同的随机字符
    for (int i = 0; i < separatedArray.count; i++) {
        if (i < separatedArray.count - 1) {
            int value = arc4random() % randomCharAry.count;
            NSString *appendStr = [NSString stringWithFormat:@"%@%@", separatedArray[i], randomCharAry[value]];
            resultStr = [NSString stringWithFormat:@"%@%@", resultStr, appendStr];
        }
        else {
            resultStr = [NSString stringWithFormat:@"%@%@", resultStr, separatedArray[i]];
        }
    }
    unsigned char *i = (unsigned char *)[resultStr cStringUsingEncoding:NSASCIIStringEncoding];
    char o[1024] = {};
    ttc_encrypt(i, resultStr.length, o);
    NSString *request_id = [NSString stringWithCString:o encoding:NSASCIIStringEncoding];
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *sm_deviceId = [MDAPPDELEGATE getSMDeviceId];
    
    if (ISLOGIN) {
        NSString *checkStr = [Util calculateCheckValue:url timeStamp:timeStamp];
        
        return @{
                 @"requestid":request_id,
                 @"uuid": device_id,
                 @"app_version" : kAppVersion,
                 @"app_target" : kAppTarget,
                 @"timestamp": timeStamp,
                 @"token" : LOGIN_USER.token ? LOGIN_USER.token : @" ",
                 @"uid" : LOGIN_USER.uid ? LOGIN_USER.uid : @" ",
                 @"check" : checkStr,
                 @"device_token" : [MDDeviceManager sharedInstance].deviceToken ? [MDDeviceManager sharedInstance].deviceToken : @"",
                 @"buildVersion" : buildVersion,
                 @"platform" : @"iOS",
                 @"sm_deviceid":sm_deviceId
                 };
    }
    else {
        return @{
                 @"requestid":request_id,
                 @"uuid": device_id,
                 @"app_version" : kAppVersion,
                 @"app_target" : kAppTarget,
                 @"timestamp": timeStamp,
                 @"device_token" : [MDDeviceManager sharedInstance].deviceToken ? [MDDeviceManager sharedInstance].deviceToken : @"",
                 @"buildVersion" : buildVersion,
                 @"platform" : @"iOS",
                 @"sm_deviceid":sm_deviceId
                 };
    }
    
    return nil;
}


#pragma  mark --- 将NSError打包成ErrorModel

- (void) requestDataCallBackWithSuccessOrFailure:(NSError *)error callBack:(DataHandelCallBack)callback dataResult:(id)data
{
    if (error.code == 0)
    {
        callback(YES , data);
    }
    else if(error != nil)
    {
        callback(NO , [self dataJSONSerializedFailureChangeErrorModel:error]);
    }
}

- (MDErrorModel *) dataJSONSerializedFailureChangeErrorModel:(NSError *)error
{
    MDErrorModel *errorModel = [[MDErrorModel alloc] init];
    errorModel.errCode = MDSerializedFailure;
    errorModel.errMsg = NSLocalizedString(@"serialized_data", nil);
    errorModel.state = error.code;
    errorModel.domain = error.domain;
    return errorModel;
}

- (MDErrorModel *) netWorkFailureWithNSErrorChangeErrorModel:(NSError *)error
{
    MDErrorModel *errorModel = [[MDErrorModel alloc] init];
    errorModel.errCode = MDRequestFailure;
    errorModel.errMsg = NSLocalizedString(@"request_failure", nil);
    if (error != nil)
    {
        errorModel.state = error.code;
        errorModel.domain = error.domain;
    }
    return errorModel;
}

@end

