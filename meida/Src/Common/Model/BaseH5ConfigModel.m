//
//  BaseH5ConfigModel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//


#import "BaseH5ConfigModel.h"
#import "NSString+URLEncoding.h"
#import "MDWebViewVC.h"
#import "WXApi.h"
//#import "PayManager.h"
#import "ShareManager.h"

NSString *const baseStrUrl  = @"md://ymfashion/h5?";

static NSString *const m_check_payment  = @"h5checkPayment";         /**< 查询本机一共支持方式 */
static NSString *const m_call_pay       = @"h5callPay";              /**< 调起原生支付 */
static NSString *const m_share_poster   = @"share_v1";               /**< 调起原生分享 */

@interface BaseH5ConfigModel ()

@property (nonatomic, strong) NSString              *urlString;     /**< 处理url */
@property (nonatomic, assign) BaseH5ConfigModelType configType;     /**< 处理逻辑类型 */
@property (nonatomic, strong) NSDictionary          *methodParams;  /**< query 参数 */
@property (nonatomic, strong) NSString              *cb_method;     /**< 逻辑处理完毕，给H5 执行回调方法 */
@property (nonatomic, strong) NSString              *cb_callBack_params;    /**< 回调给 H5 的参数，需要序列化成string */

@end

@implementation BaseH5ConfigModel

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init]) {
        [self configMethodByUrlString:urlString];
    }
    return self;
}
- (void)configMethodByUrlString:(NSString *)urlString
{
    _urlString = urlString;
    if (stringIsEmpty(urlString)) {
        self.configType = TypeConfigUnkown;
        return;
    }
    if (urlString.length < 6) {
        return;
    }
    
    if ([urlString hasPrefix:baseStrUrl]) {
        [self configMethodTypeByUrlString:urlString];
    }
}

- (void)configMethodTypeByUrlString:(NSString *)urlString
{
    // 1. 解析 url query 出来的信息： 封装成字典
    NSMutableDictionary *m_dict = [self getUrlParams:urlString];
    if (dictionaryIsEmpty(m_dict)) {
        return;
    }
    
    // 2. 转换出来的值
    _methodParams = m_dict;
    
    NSString *methodType = m_dict[@"method"];
    self.cb_method = m_dict[@"cb"];
    
    // 3. 分类处理 不同业务逻辑
    // 3.1 检查 原生支持支付方式
    if ([methodType isEqualToString:m_check_payment]) {
        self.configType = TypeConfigCheckPayment;
    }
    // 3.2 调起 原生支付
    else if ([methodType isEqualToString:m_call_pay]){
        self.configType = TypeConfigCallPayWay;
    }
    // 3.2 调起 原生分享
    else if ([methodType isEqualToString:m_share_poster]){
        self.configType = TypeConfigSharePoster;
    }
    // 未知类型
    else{
        self.configType = TypeConfigUnkown;
    }
    
}
- (NSMutableDictionary *)getUrlParams:(NSString *)url
{
    //NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *nsurl = [NSURL URLWithString:url];
    NSString *params = [nsurl query];
    
    NSArray *keyValueArray = [params componentsSeparatedByString:@"&"];
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSInteger index = 0;
    for (NSString *subStr in keyValueArray) {
        NSArray *parpamArray = [subStr componentsSeparatedByString:@"="];
        for (int i = 0; i < parpamArray.count; i += 2) {
            if (parpamArray.count == 1) {
                [mdict setObject:parpamArray[i] forKey:parpamArray[i]];
            }
            else {
                if (i + 1 < parpamArray.count) {
                    [mdict setObject:[parpamArray[i + 1] URLDecodedString:kCFStringEncodingUTF8] forKey:parpamArray[i]];
                }
                else {
                    return nil;
                }
            }
            index++;
        }
    }
    return mdict;
}

- (void)completeHandler
{
    // 1. 执行 逻辑处理
    switch (self.configType) {
        case TypeConfigCheckPayment:
        {// 检测支付方式
            [self goToCheckPayment];
        }
            break;
        case TypeConfigCallPayWay:
        {// 调起支付
            [self goToCallPay];
        }
            break;
        case TypeConfigSharePoster:
        {// 调起分享
            [self gotoSharePoster];
        }
            break;
        case TypeConfigUnkown:
        {
            [Util showMessage:@"伦家不知道您想要去哪里~~" forDuration:1.0 inView:self.webViewVC.view];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark --- 检测原生支持支付方式 (ali , wechat) ---
- (void)goToCheckPayment
{
    NSMutableDictionary *dict_M = [NSMutableDictionary dictionary];
    NSMutableArray  *arr_M = [NSMutableArray array];
    
    // 检测微信是否安装
    if ([WXApi isWXAppInstalled]) {
        [arr_M addObject:@{@"paytype":@"wechat"}];
    }
    // ali 支付肯定有
    [arr_M addObject:@{@"paytype" : @"ali"}];
    [dict_M setObject:arr_M forKey:@"paytypes"];
    
    // 转换cb_method 所需参数
    [self dictToString:dict_M];
    
    // 执行回调
    if (!stringIsEmpty(self.cb_method)) {
        [self.webViewVC evaluateJavaScript:self.cb_method paramsStr:self.cb_callBack_params];
    }
}

#pragma mark --- 调起原生支付 (ali , wechat) --- #############################################
- (void)goToCallPay
{
    NSString *payinfoStr = self.methodParams[@"payinfo"];
    
    // 支付信息 为空的时候，return
    if (stringIsEmpty(payinfoStr))  return;

    // 1. 转换 json -> dict
    NSDictionary *payinfoDict = [self stringToDict:payinfoStr];
    
    // 2. 支付方式
    NSString *payType = payinfoDict[@"type"];
    
    // 3. 签名信息 为空的时候，return
    NSDictionary *payinfo = payinfoDict[@"info"];
    if (dictionaryIsEmpty(payinfo)) return;
    
    // 4. 根据支付方式拉去支付
//    if ([payType isEqualToString:PaymentMethodKeyAlipayPay]) {
//        [[PayManager sharedInstance] alipayByDictionary:payinfo payMethod:PaymentMethodAlipayPay];
//    }
//    else if ([payType isEqualToString:PaymentMethodKeyWeChatPay]){
//        [[PayManager sharedInstance] weChatPayByDictionary:payinfo payMethod:PaymentMethodWeChatPay];
//    }
    self.webViewVC.cbMethod  = self.cb_method;
    
}

#pragma mark --- 调起原生分享  --- #############################################
- (void)gotoSharePoster
{
    if ([ShareManager sharedInstance].isShow)  return;
    
    // 执行回调 所用cb
    self.webViewVC.cbMethod = self.cb_method;
    
    //调起分享
    //普通分享文案信息
    NSString *share_info = [self.methodParams objectForKey:@"share_info"];
    NSDictionary *shareInfoDic = nil;//[share_info objectFromJSONString];
    MDShareInfoModel *shareInfoModel = [[MDShareInfoModel alloc] initWithDict:shareInfoDic];
    
    //获取海报图的url
    NSString *poster = [self.methodParams objectForKey:@"poster"];
    if (!stringIsEmpty(poster)) {
        [ShareManager sharedInstance].isShow = YES;
        [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
    }
    else {
        [ShareManager sharedInstance].isShow = NO;
        [[ShareManager sharedInstance] shareInfoModel:shareInfoModel sourceType:ShareSourceTypeH5];
    }
}

#pragma mark --- 公用方法 转换 给H5传递的参数   --- #############################################
- (void)dictToString:(NSDictionary *)dict
{
    if (!dict) {
        self.cb_callBack_params  = @"";
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    self.cb_callBack_params = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)stringToDict:(NSString *)string
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
