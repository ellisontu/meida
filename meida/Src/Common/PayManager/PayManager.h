//
//  PayManager.h
//  meida
//
//  Created by ToTo on 2018/7/2.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

static NSString *const PaymentMethodKeyAlipayPay   = @"ali";       /**< 支付宝支付 */
static NSString *const PaymentMethodKeyWeChatPay   = @"wechat";    /**< 微信支付 */
static NSString *const PaymentMethodKeyApplePay    = @"apple";     /**< Apple Pay支付 */
static NSString *const PaymentMethodKeyPointPay    = @"point";     /**< 积分支付（即0元支付） */

typedef NS_ENUM(NSInteger, PaymentMethod) {
    PaymentMethodWeChatPay,     /**< 微信支付 */
    PaymentMethodAlipayPay,     /**< 支付宝支付 */
    PaymentMethodApplePay,      /**< Apple Pay支付（暂时取消此支付方式） */
    PaymentMethodZeroPay        /**< 0元付钱 */
};


@class PayManagerQueryPayModel;
@interface PayManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) PaymentMethod  payMethod;
@property (nonatomic, strong) NSNumber       *orderID;      /**< 支付订单ID（微信回调时用）*/
@property (nonatomic, weak) UIViewController *superVC;
@property (nonatomic, assign) BOOL           isbulkBuy;    /**< 是否为团购订单 */
@property (nonatomic, strong) NSString       *orderPrice;   /**< 订单支付价格（需要在新的支付成功页面使用）*/
@property (nonatomic, strong) NSString       *otherInfo;    /**< Apple Pay成功支付时包含的优惠信息 eg: otherInfo 为“currency=元&order_amt=20.00&pay_amt=15.00 “,currency:币种，order_amt:订单金额,pay_amt:实付金额 */
@property (nonatomic, strong) PayManagerQueryPayModel *queryModel;  /**< 查询支付订单结果model */

//@property (nonatomic, copy) void (^finishBlock)(BOOL isSuccess);    /**< 支付操作完成后的回调 */

+ (PayManager *)sharedInstance;

//检测是否支持银联支付
//+ (BOOL)canMakePaymentsUsingNetworks;


/**
 根据订单 ID 获取订单支付信息 去支付
 @param params // params里面包含 : pay_type{支付方式}/money{支付金额}/point{支付积分}/oid{订单id}/order_type{订单类型}
 @param payMethodStr 支付方式 （PaymentMethodKey）
 */
- (void)goToPayWithParams:(NSDictionary *)params payMethod:(NSString *)payMethodStr;


//调起微信支付
- (void)weChatPayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod;

//调起支付宝支付
- (void)alipayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod;

//调起 Apple Pay 支付
//- (void)applePayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod;

//调起 sina 支付（假的，暂不使用）
- (void)sinaPayByDictionary:(NSDictionary *)dic payMethod:(PaymentMethod)payMethod;

/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *  @param resultUrl 支付结果url，传入后由SDK解析，统一在上面的pay方法的callback中回调
 */
- (void)handleOpenURLWithAlipaySDKByUrl:(NSURL *)url;

/**
 *  确认订单页支付金额为0时直接调用查询结果
 *  @param orderId 订单ID
 */
- (void)requestPayResultWithOrderId:(NSNumber *)orderId;

@end


#pragma mark - 查询支付结果model -
@class StoreComfirmTemptationInfo, StoreOrderDetailVipInfoModel;
@interface PayManagerQueryPayModel : BaseModel

@property (nonatomic, strong) NSNumber *o_status;   /**< 订单状态 */
@property (nonatomic, strong) NSNumber *total;      /**< 支付金额 */
@property (nonatomic, strong) StoreOrderDetailVipInfoModel *vip;    /**< 会员立返 */
@property (nonatomic, strong) StoreComfirmTemptationInfo   *temptation_info; /**< 非会员立返 */
@property (nonatomic, strong) NSString *cash_back;  /**< 会员立返文案(会员确认收货立返：¥0) */

@end



