//
//  PayManager.m
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "PayManager.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <PassKit/PassKit.h>   // 不用Apple Pay的话别引入，会被拒
//#import "UPAPayPlugin.h"
#import "WeiboSDK.h"
#import "NSString+URLEncoding.h"
#import <MBProgressHUD.h>
#import "MDWebViewVC.h"


//@interface PayManager ()<UPAPayPluginDelegate>
@interface PayManager ()

@property (nonatomic, strong) MBProgressHUD *payHud;
@property (nonatomic, strong) UIView *maskView;         /**< 调起支付宝和微信支付时，添加的遮罩层 */
@property (nonatomic, strong) UILabel *payStatusLabel;  /**< 遮罩层上说明文字 */

@end


@implementation PayManager

+ (PayManager *)sharedInstance
{
    static PayManager *payManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        payManager = [[PayManager alloc] init];
    });
    return payManager;
}

//+ (BOOL)canMakePaymentsUsingNetworks
//{
//    //系统限制
//    if (IOS_GREATER_THAN_OR_EQUAL_TO(@"9.2")) {
//        //是否支持Apple Pay
//        if ([PKPaymentAuthorizationViewController canMakePayments]) {
//            //是否已绑定有可用的卡片
//            if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]]) {
//                return YES;
//            }
//            return NO;
//        }
//        else {
//            return NO;
//        }
//    }
//    else {
//        return NO;
//    }
//}

- (void)addMaskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
        _maskView.backgroundColor = [COLOR_WITH_BLACK colorWithAlphaComponent:0.4f];
        _maskView.userInteractionEnabled = YES;
        [MDAPPDELEGATE.window addSubview:_maskView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOrderDetail)];
        [_maskView addGestureRecognizer:tap];
        
        CGFloat label_W = SCR_WIDTH*0.548f;
        CGFloat label_H = label_W*0.365f;
        _payStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, label_W, label_H)];
        _payStatusLabel.center = CGPointMake(SCR_WIDTH/2.f, SCR_HEIGHT/2.f);
        _payStatusLabel.backgroundColor = COLOR_WITH_WHITE;
        _payStatusLabel.text = @"正在支付";
        _payStatusLabel.font = FONT_SYSTEM_NORMAL(15.f);
        _payStatusLabel.numberOfLines = 0;
        _payStatusLabel.textAlignment = NSTextAlignmentCenter;
        _payStatusLabel.layer.cornerRadius = 8.f;
        _payStatusLabel.layer.masksToBounds = YES;
        [_maskView addSubview:_payStatusLabel];
    }
}

- (void)removeMaskView
{
    [_payStatusLabel removeFromSuperview];
    _payStatusLabel = nil;
    
    [_maskView removeFromSuperview];
    _maskView = nil;
}

- (void)goToOrderDetail
{
    [self removeMaskView];
    
    MDBaseViewController *currentVC = (MDBaseViewController *)[Util getCurrentVC];
    // 在h5页面的支付 如果回调没拿到，就用通知的形式刷新一下页面
    if ([currentVC isKindOfClass:[MDWebViewVC class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"H5GoodsPayCallBackMethod" object:nil];
    }
    
    if (![PayManager sharedInstance].orderID) {
        //测试和产品说不需要此 toast
        //[Util showMessage:@"订单编号为空,请稍后再试哦~" inView:XHCAPPDELEGATE.window];
        return;
    }
    if ([PayManager sharedInstance].isbulkBuy) {
        //团购订单
        //NSString *openUrl = [XHCRouter generateURLWithPattern:RouterStoreOrderGroupBuyDetailVCPush parameters:@[@"1", [PayManager sharedInstance].orderID]];
        //[XHCRouter openURL:openUrl];
    }
    else {
        //普通订单
        //NSString *openUrl = [XHCRouter generateURLWithPattern:RouterStoreOrderDetailVCPush parameters:@[@"1", @"0",  [PayManager sharedInstance].orderID]];
        //[XHCRouter openURL:openUrl];
    }
    
}

#pragma mark - 根据订单 ID 获取订单支付信息  去支付 -
- (void)goToPayWithParams:(NSDictionary *)params payMethod:(NSString *)payMethodStr
{
    [self configHud];
    [_payHud showAnimated:YES];
    [PayManager sharedInstance].orderID = [params objectForKey:@"oid"];
    NSString *urlStr = @"";
    MDWeakPtr(weakPtr, self);
    [[MDNetWorking sharedClient] requestWithPath:urlStr params:params httpMethod:MethodPost callback:^(BOOL rs, NSObject *obj) {
        [weakPtr.payHud hideAnimated:NO];
    }];
}

- (void)configHud
{
    if (_payHud) {
        return;
    }
    _payHud = [[MBProgressHUD alloc] initWithView:MDAPPDELEGATE.window];
    [MDAPPDELEGATE.window addSubview:_payHud];
}

#pragma mark - 调起微信支付 -
//调起微信支付
- (void)weChatPayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod
{
    [self addMaskView];
    
    [PayManager sharedInstance].payMethod = payMethod;
    //调起微信支付
    PayReq *req     = [[PayReq alloc] init];
    // 此处 appid 必须在 info.plist 中的 URL Types 中添加 scheme， 否则支付完成后无法跳转回来
    NSString *appid = [dic objectForKey:@"appid"];
    //向微信注册您的APPID，代码如下：
    [WXApi registerApp:appid];

    //以下7个数据服务端产生
    req.openID      = [dic objectForKey:@"appid"];
    req.partnerId   = [dic objectForKey:@"partnerid"];
    req.package     = [dic objectForKey:@"package"];
    req.prepayId    = [dic objectForKey:@"prepayid"];
    req.nonceStr    = [dic objectForKey:@"noncestr"];
    req.timeStamp   = [[dic objectForKey:@"timestamp"] unsignedIntValue];
    req.sign        = [dic objectForKey:@"sign"];
    [WXApi sendReq:req];
}


#pragma mark - WXApiDelegate -
- (void)onResp:(BaseResp *)resp
{
    __block NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]) {
        
        // H5调起原生支付操作完成后的回调
        [[NSNotificationCenter defaultCenter] postNotificationName:@"H5GoodsPayCallBackMethod" object:nil];
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付成功！";
                
                if (!self.orderID) {
                    [self removeMaskView];
                    return;
                }
                NSString *url = @""; //[NSString stringWithFormat:URL_GOODS_ORDERS_QUERY_PAY_2, self.orderID];
                
                //查询支付结果
                [self requestPayResultWithUrl:url params:nil];
            }
                break;
            case WXErrCodeUserCancel:
            {
                [self removeMaskView];
                strMsg = [NSString stringWithFormat:@"取消支付"];
                [self showAlertViewWithTitle:strTitle message:strMsg];
            }
                break;
            default:
            {
                [self removeMaskView];
                strMsg = [NSString stringWithFormat:@"支付失败！错误码：%d, 错误信息：%@", resp.errCode,resp.errStr];
                [self showAlertViewWithTitle:strTitle message:strMsg];
            }
                break;
        }
    }
}

#pragma mark - 调起支付宝支付 -
- (void)alipayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod
{
    [self addMaskView];
    
    [PayManager sharedInstance].payMethod = payMethod;
    
    NSString *sign = [dic objectForKey:@"sign"];
    NSString *sign_body = [dic objectForKey:@"sign_body"];
    //NSString *alipayStr = nil;
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"xiaohongchunAlipaysdk";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = sign_body;
    
    NSString *signedString = nil;
    signedString = [sign URLEncodedString];
    
    if (stringIsEmpty(signedString)) {
        [Util showMessage:@"支付签名为空" inView:self.superVC.view];
        return;
    }
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (!stringIsEmpty(signedString)) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        
        // 此方法内部的 callback 是在没有支付宝客户端进行网页支付时执行的
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [self handleAlipaySDKCallbackWithResultDic:resultDic];
        }];
    }
}

- (void)handleAlipaySDKCallbackWithResultDic:(NSDictionary *)resultDic
{
    DLog(@"支付宝支付--- reslut = %@", resultDic);
    //9000:订单支付成功 8000:正在处理中 4000:订单支付失败 6001:用户中途取消 6002:网络连接出错
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    NSString *title = @"支付结果";
    
    // H5调起原生支付操作完成后的回调
    [[NSNotificationCenter defaultCenter] postNotificationName:@"H5GoodsPayCallBackMethod" object:nil];
    
    __block NSString *msg = nil;
    if ([resultStatus isEqualToString:@"9000"]) {
        //msg = PAY_SUCCESS;
        if (!self.orderID) {
            [self removeMaskView];
            return;
        }
        NSString *url = @""; //[NSString stringWithFormat:URL_GOODS_ORDERS_QUERY_PAY_2, self.orderID];
        //查询支付结果
        [self requestPayResultWithUrl:url params:nil];
    }
    else {
        [self removeMaskView];
        
        if ([resultStatus isEqualToString:@"8000"]) {
            msg = @"订单正在处理中";
        }
        else if ([resultStatus isEqualToString:@"4000"]) {
            msg = @"支付失败";
        }
        else if ([resultStatus isEqualToString:@"6001"]) {
            msg = @"取消支付";
        }
        else if ([resultStatus isEqualToString:@"6002"]) {
            msg = @"网络连接出错";
        }
        [self showAlertViewWithTitle:title message:msg];
    }
}

/* 关闭Apple Pay
#pragma mark - 调起Apple Pay支付 -
- (void)applePayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod
{
    [PayManager sharedInstance].payMethod = payMethod;
    //交易流水号(商户后台向银联 后台提交订单信息后，由银联 后台生成并下发给商户后台的 交易凭证)
    NSString *tn = [dic objectForKey:@"tn"];
    if (!stringIsEmpty(tn)) {
        //NSString *merchantID = @"merchant.com.xhc.redlips.test";
        NSString *merchantID = @"merchant.com.xhc.redlips.production";
        //NSString *mode = @"01";
        NSString *mode = @"00";
//        if (URL_CONFIG == 1 || URL_CONFIG == 2) {
//            mode = @"00";
//        }
        [UPAPayPlugin startPay:tn mode:mode viewController:_superVC delegate:self andAPMechantID:merchantID];
    }
    else {
        [Util showMessage:@"交易流水号异常" inView:[XHCDeviceManager sharedInstance].window];
    }
}

#pragma mark - UPAPayPluginDelegate -
- (void)UPAPayPluginResult:(UPPayResult *)payResult
{
    UPPaymentResultStatus resultStatus = payResult.paymentResultStatus;
    //eg: otherInfo 为“currency=元&order_amt=20.00&pay_amt=15.00 “,currency:币种，order_amt:订单金额,pay_amt:实付金额。
    NSString *otherInfo = payResult.otherInfo;
    [PayManager sharedInstance].otherInfo = otherInfo;
    //支付成功
    NSString *url = [NSString stringWithFormat:URL_GOODS_ORDERS_QUERY_PAY_2, self.orderID];
    NSDictionary *dic = nil;
    if (resultStatus == UPPaymentResultStatusSuccess) {
        DLog(@"Apple Pay支付 -------> 成功");
        [self requestPayResultWithUrl:url params:dic];
    }
    //支付失败
    else if (resultStatus == UPPaymentResultStatusFailure) {
        DLog(@"Apple Pay支付 -------> 失败");
        NSString *errorStr = payResult.errorDescription;
        //DLog(@"Apple Pay支付 -------> 失败原因：%@", errorStr);
        if (stringIsEmpty(errorStr)) {
            errorStr = @"支付失败，请联系客服~ ~";
        }
        [self showAlertViewWithTitle:@"支付结果" message:errorStr];
    }
    //支付取消
    else if (resultStatus == UPPaymentResultStatusCancel) {
        DLog(@"Apple Pay支付 -------> 取消");
        [self showAlertViewWithTitle:@"支付结果" message:@"取消支付"];
    }
    //支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
    else if (resultStatus == UPPaymentResultStatusUnknownCancel) {
        DLog(@"Apple Pay支付 -------> 未知");
        [self requestPayResultWithUrl:url params:dic];
    }
}
*/
 
#pragma mark - 支付成功后查询支付结果 -
- (void)requestPayResultWithUrl:(NSString *)url params:(NSDictionary *)dic
{
    _payStatusLabel.text = @"正在返回支付结果\n请等待...";
    [PayManager sharedInstance].queryModel = nil;
    
    // 新增参数  团购订单查询状态
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (self.isbulkBuy){
        [param setObject:@"bulkbuy" forKey:@"bulkbuy"];
    }
    [[MDNetWorking sharedClient] requestWithPath:url params:param httpMethod:MethodGet callback:^(BOOL rs, NSObject *obj) {
        //NSString *title = @"支付结果";
        NSString *msg = PAY_ERROR;
        [self removeMaskView];
        if (rs) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *respObj = (NSDictionary *)obj;
                //status:0//状态 0 未发货 1 完成 2 取消 3 发货 -1 待支付 -2 信息确认
                NSInteger o_status = [[respObj objectForKey:@"o_status"] integerValue];
                //NSString *titleStr = @"支付成功";
                if (o_status > 1) {    //o_status = 2
                    msg = PAY_SUCCESS;
                    PayManagerQueryPayModel *model = [[PayManagerQueryPayModel alloc] initWithDict:respObj];
                    [PayManager sharedInstance].queryModel = model;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaySuccess object:msg];
                }
                else if (o_status == 1){
                    PayManagerQueryPayModel *model = [[PayManagerQueryPayModel alloc] initWithDict:respObj];
                    [PayManager sharedInstance].queryModel = model;
                     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaySuccess object:@"failure"];
                }
            }
        }
        else {
            MDErrorModel *errorModel = (MDErrorModel *)obj;
            if ([obj isKindOfClass:[MDErrorModel class]]) {
                msg = [NSString stringWithFormat:@"%@ 请联系客服~ ~", errorModel.errMsg];
                [self showAlertViewWithTitle:@"查询支付结果" message:msg];
            }
        }
    }];
}

- (void)requestPayResultWithOrderId:(NSNumber *)orderId
{
    [self addMaskView];
    self.orderID = orderId;
    NSString *url = @"";//[NSString stringWithFormat:URL_GOODS_ORDERS_QUERY_PAY_2, orderId];
    [self requestPayResultWithUrl:url params:nil];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([alertCtrl.message isEqualToString:PAY_SUCCESS]) {
            //在 PayViewController 里接收通知调到商品详情页面
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaySuccess object:@"success"];
        }
        /*
         else if ([alertView.message isEqualToString:PAY_SUCCESS_SUPPL_INFO]) {
         //在 PayViewController 里接收通知调到商品详情页面
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaySuccess object:PAY_SUCCESS_SUPPL_INFO];
         }
         */
        else {
            //在 PayViewController 里接收通知调到商品详情页面
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPaySuccess object:@"failure"];
        }
    }];
    [alertCtrl addAction:confirmAction];
}


/**
 *  调起新浪支付
 *
 *  @param dic       传入信息
 *  @param payMethod 支付方式  商城
 */
- (void)sinaPayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod
{
    WBOrderObject *order = [WBOrderObject order];
    NSString *o_id = [NSString stringWithFormat:@"%@", _orderID];
    [order setOrderString:o_id];
    
    WBPaymentRequest *request = [WBPaymentRequest requestWithOrder:order];
    [WeiboSDK sendRequest:request];
}

/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl 支付结果url，传入后由SDK解析，统一在上面的pay方法的callback中回调
 *  @param completionBlock 跳钱包支付结果回调，保证跳转钱包支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)handleOpenURLWithAlipaySDKByUrl:(NSURL *)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [self handleAlipaySDKCallbackWithResultDic:resultDic];
    }];
}


@end


@implementation PayManagerQueryPayModel

@end


