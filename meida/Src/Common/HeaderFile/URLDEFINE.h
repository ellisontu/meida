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
#define BASEURL             @"http://118.24.16.26:8889"
#define CODEPUSHKEY         @"mR5yLtjURIYdDIf1917YSaXCNvF44ksvOXqog"
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


#pragma mark ------------------------------------ user reg && login  ----------------------------------
/**
 *  用户注册
 *  @method POST
 *  @link /user/reg
 *  @param: phone / password
 *  @return json
 */
//egister
#define URL_POST_REGISTER [BASEURL stringByAppendingString:@"/user/reg"]


#endif
