//
//  MDErrorModel.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

#define MDErrorCodeCommentBanned   @"1001"
#define MDErrorCodeNoError         @"0"
#define MDErrorNoMoreData          @"没有更多数据"

/*!
 @enum NetWork-related Error Codes
 @abstract Constants used by MDError
 */
NS_ENUM(NSInteger)
{
    //自定义code值
    MDSerializedFailure          =   10000,      /**< 数据序列化失败 */
    MDRequestFailure             =   10001,      /**< 请求后台失败(网络不佳,url格式问题等) */
    
    //后台返回code值 如有遇到继续补充
    MDRequestCodeUnknow          =   -1000,     /**< 请求后台成功返回错误信息(旧接口) */
    MDRequestStateSuccess        =   0,         /**< 请求解析成功 */
    MDRequestStateAuthFailure    =   1000,      /**< 用户授权失败 */
    MDRequestStateNoMoreData     =   1003,      /**< 旧接口后台返回没有更多数据 */
    MDRequestStateNoCardID_1     =   6008,      /**< 商城保税仓中填写身份信息 */
    MDRequestStateNoCardID_2     =   6009,      /**< 商城保税仓中填写身份信息 */
    MDStoreIsEmpty               =   6010,      /**< 商城库存不足 */
    MDMallCartDataError          =   9300,      /**< 购物车数据返回错误code */
    MDRequestStateInvalidToken   =   2001,      /**< 用户token无效 */
    MDRequestStateNoneSession    =   399,       /**< 没有相关session(修改密码后 除修改者均返回此 code) */
    MDRequestSucOfBackGroudWrong =   -1125,     /**< 后台错误 */
    MDRequestStateCommentBanned  =   1001,
    MDRequestStateVipGoods       =   6020,      /**< 会员专属商品 普通用户购买错误提示状态 */
    MDRequestStateNotAllowBuy    =   7010,      /**< 针对限购 或者 其他商品确认订单页面不让结算 错误codeNum */
};

/**
 *  适用情况   网络请求不成功  请求数据不符合json格式  返回数据包含错误信息
 *  适用类     网络请求中错误回调中全部返回MDErrorModel
 *  补充       MDcode MDmsg一般用于网络请求错误信息的提示   errcode errdomain erruserInfo一般用于控制台
 *            打印错误信息 如有必要 用于提示错误信息
 */
    
@interface MDErrorModel : BaseModel

@property (nonatomic, assign) NSInteger     errCode;   /**< 请求成功,后台返回错误code */

@property (nonatomic, strong) NSString      *errMsg;   /**< 请求成功,后台返回错误信息 */

@property (nonatomic, assign) NSInteger     state;      /**< 请求失败或者反序列化失败,系统返回错误code */

@property (nonatomic, strong) NSString      *domain;    /**< 请求失败或者反序列化失败,系统返回错误信息 */


@end
