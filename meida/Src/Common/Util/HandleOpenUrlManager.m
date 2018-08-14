//
//  HandleOpenUrlManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "HandleOpenUrlManager.h"
#import "ShareManager.h"
#import "ShareManager.h"
#import "WXApi.h"

@interface HandleOpenUrlManager ()



@end


@implementation HandleOpenUrlManager

+ (HandleOpenUrlManager *)sharedInstance
{
    static HandleOpenUrlManager *handleOpenUrlManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handleOpenUrlManager = [[HandleOpenUrlManager alloc] init];
        
    });
    return handleOpenUrlManager;
}

- (BOOL)hanleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApp
{
    NSString *stringUrl = [url description];
    DLog(@"openURL = %@", stringUrl);
    NSString *upStringurl = [stringUrl uppercaseString];
    
    // qq登录  stringUrl = tencent1103443915://qzapp/mqzone/0?generalpastboard=1
    if ([upStringurl hasPrefix:@"TENCENT1103443915://"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    // qq分享
    if ([upStringurl hasPrefix:@"QQ41C537CB://RESPONSE_FROM_QQ"]) {
        return [QQApiInterface handleOpenURL:url delegate:[ShareManager sharedInstance]];
    }
    // 微博
    if ([upStringurl hasPrefix:@"WB3146088882"]) {
        //return [WeiboSDK handleOpenURL:url delegate:[ThirdPartyLoginManager sharedInstance]];
    }
    
    // 微信登陆  stringUrl = wxa5583bad5377255f://oauth?code=02197be67f111c014ac6c3e7b283a65u&state=ymfashionWechat
    if ([stringUrl hasPrefix:@"wxa5583bad5377255f://oauth"]) {
        //return [WXApi handleOpenURL:url delegate:[ThirdPartyLoginManager sharedInstance]];
    }
    // 微信分享 stringUrl = wxa5583bad5377255f://platformId=wechat
    else if ([stringUrl hasPrefix:@"wxa5583bad5377255f://platformId=wechat"]) {
        return [WXApi handleOpenURL:url delegate:[ShareManager sharedInstance]];
    }
    // 微信支付  stringUrl =
    else if ([stringUrl hasPrefix:@"wxa5583bad5377255f://pay/"]) {
        //return [WXApi handleOpenURL:url delegate:[PayManager sharedInstance]];
    }
    // 微信支付(新的appId = wx63f9c8c4a46255d2)  stringUrl = wx63f9c8c4a46255d2://pay/?returnKey=(null)&ret=-2
    else if ([stringUrl hasPrefix:@"wx63f9c8c4a46255d2://pay/"]) {
        //return [WXApi handleOpenURL:url delegate:[PayManager sharedInstance]];
    }
    
    // 测试微信
    if ([stringUrl hasPrefix:@"wxa3904afa020298f0://oauth"]) {
        //return [WXApi handleOpenURL:url delegate:[ThirdPartyLoginManager sharedInstance]];
    }
    // 微信分享 stringUrl = wxa5583bad5377255f://platformId=wechat
    else if ([stringUrl hasPrefix:@"wxa3904afa020298f0://platformId=wechat"]) {
        return [WXApi handleOpenURL:url delegate:[ShareManager sharedInstance]];
    }
    // 微信支付  stringUrl =
    else if ([stringUrl hasPrefix:@"wxa3904afa020298f0://pay/"]) {
        //return [WXApi handleOpenURL:url delegate:[PayManager sharedInstance]];
    }
    
    // 支付宝支付  stringUrl =
    if ([stringUrl hasPrefix:@"md://safepay/"]) {
        //[[PayManager sharedInstance] handleOpenURLWithAlipaySDKByUrl:url];
        return YES;
    }
    
    //从外部H5跳转到我们的 app 内 stringUrl = md://ymfashion?video=107058
    if ([stringUrl hasPrefix:@"md://ymfashion/params?"]) {
        
        [Util checkUrlParamsWithUrlString:stringUrl];
        
        //NSString *openUrl = [NSString stringWithFormat:@"md://base_jump_model/jump_url"];
        //BaseJumpModel *jumpModel = [[BaseJumpModel alloc] initWithUrlString:stringUrl];
        //jumpModel.referer = GoodsClickSource_other;
        //[jumpModel handelJump];
        
        //添加外部H5进入APP内的埋点
        UserAnalyticsModel *model = [[UserAnalyticsModel alloc] init];
        model.tableName = UserAnalyticsTableName_link;
        model.source = stringUrl;
        [model configLogMessageDictionary];
        return YES;
    }
    //在APP内部与H5的交互
    if ([stringUrl hasPrefix:@"md://ymfashion/h5?"]) {
        
        [[HandleOpenUrlManager sharedInstance] handleSchemeOpenUrl:url];
        return YES;
    }
    
    return YES;
}
- (BOOL)handleSchemeOpenUrl:(NSURL *)url
{
    NSString *urlQuery = [url query];
    NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [parameterDic setObject:value forKey:key];
    }
    if ([[parameterDic objectForKey:@"method"] isEqualToString:@"share_v1"]) {
        NSString *urlHost = [url host];
        if ([ShareManager sharedInstance].isShow) {
            return NO;
        }
        if ([urlHost isEqualToString:@"ymfashion"]) {
            //调起分享
            //普通分享文案信息
            NSString *share_info = [parameterDic objectForKey:@"share_info"];
            NSDictionary *shareInfoDic = nil;//[share_info objectFromJSONString];
            MDShareInfoModel *shareInfoModel = [[MDShareInfoModel alloc] initWithDict:shareInfoDic];
            //获取海报图的url
            NSString *poster = [parameterDic objectForKey:@"poster"];
            
            //回调的函数名
            NSString *cb_method = [parameterDic objectForKey:@"cb"];
            
            _cbMethod = cb_method;
            
            if (!stringIsEmpty(poster)) {
                [ShareManager sharedInstance].isShow = YES;
                [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"正在获取分享数据"];
            }
            else {
                [ShareManager sharedInstance].isShow = NO;
                [[ShareManager sharedInstance] shareInfoModel:shareInfoModel sourceType:ShareSourceTypeH5];
            }
        }
    }
    
    return YES;
}

@end
