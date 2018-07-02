//
//  BaseH5ConfigModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  处理 h5 交互过程中 逻辑处理model scheme =

#import "BaseModel.h"


typedef NS_ENUM(NSInteger, BaseH5ConfigModelType) {
    TypeConfigCheckPayment,            /**< 查询 原生一共多少支付方式 */
    TypeConfigCallPayWay,              /**< 调起 原生支付*/
    TypeConfigSharePoster,             /**< 分享海报 */
    TypeConfigUnkown,
};

@class MDWebViewVC;
@interface BaseH5ConfigModel : BaseModel

@property (nonatomic, strong) MDWebViewVC   *webViewVC;
@property (nonatomic, strong) NSString      *referer;        /**< 来源类型 shopcart order video mall topic other */
@property (nonatomic, strong) NSString      *track_info;     /**< 用于埋点的数据（晒图和视频要用到）*/

- (instancetype)initWithUrlString:(NSString *)urlString;
- (instancetype)init NS_UNAVAILABLE;

@end
