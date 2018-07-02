//
//  URLDEFINE.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//
//  此文件用于存放网络请求的网址，网络环境配置信息

#import "UrlConfig.h"

#ifndef URLDEFINE_h
#define URLDEFINE_h

#pragma mark - configUrl -
//*************************************** URL_CONFIG BEGIN ***************************************//

#if (URL_CONFIG == 1)
//正式-发布（仅发布时用）

#elif (URL_CONFIG == 2)
//正式-测试（仅测试时用）

#elif (URL_CONFIG == 3)
//测试
// app id in appStore
#define kAppId              @"931449079"
#define kAppTarget          @"meida"
#define BUNDLE_ID           @"cn.ymfashion.test.meida"
#define BASEURL             @"https://trunk.ymfashion.com"
#define BASEURL_2           @"https://test1.ymfashion.com"
#define CODEPUSHKEY         @"mR5yLtjURIYdDIf1917YSaXCNvF44ksvOXqog"
#define ANALYZE_URL         @"http://139.198.0.193/push"
#define TINGYUN_APP_ID_COM  @"d7d3e19d3bc248fc985dc7e0b6c1f08a"
//#define TINGYUN_APP_ID_COM  @"1111"
#elif (URL_CONFIG == 4)
//预发布

#endif

#define kWeexDefaultDebugURL @"10.2.0.92"
//*************************************** URL_CONFIG END ***************************************//

#pragma mark - api statef

#define API_NONE     0
#define API_FRESH    1
#define API_LOADMORE 2
#define API_ERROR    3
#define API_SUCCESS  4
#define API_VERSION  @"2.0"

/**
 * 检查版本更新
 * @link /api2/index/get_vup
 * @return json
 */
#define URL_CHECKOUT_UPDATE [BASEURL stringByAppendingString:@"/api2/index/get_vup"]

#pragma mark ------------------------------------ 账号操作 ----------------------------------
//regist
/*
    m 手机号  11位
    p 密码 最少6个
    c 验证码 纯数字
 
 */
//新的注册接口，该接口仅仅是验证手机号，验证码，真正的注册是再第三部完成
#define URL_REGIST [BASEURL stringByAppendingString:@"/api/auth/register"]


#endif
