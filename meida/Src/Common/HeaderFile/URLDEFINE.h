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
#define BASEURL             @"http://118.24.16.26:8889/ym"
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
 *  @param: @{phone: 电话号码, password: 密码}
 *  @return json
 */
//egister
#define URL_POST_USER_REGISTER [BASEURL stringByAppendingString:@"/user/reg"]

/**
 *  用户登录
 *  @method POST
 *  @link /user/reg
 *  @param: @{phone=电话号码, password=密码}
 *  @return json
 */
//egister
#define URL_POST_USER_LOGIN [BASEURL stringByAppendingString:@"/user/login"]

/**
 *  用户获取验证码
 *  @method POST
 *  @link /user/sendSms
 *  @param: @{phone=电话号码}
 *  @return json
 */
#define URL_POST_USER_SENSMS [BASEURL stringByAppendingString:@"/user/sendSms"]

/**
 *  关注
 *  @method POST
 *  @link /user/praise
 *  @param: @{toUserId=用关注的用户ID, userId=当前登录用户ID}
 *  @return json
 */
#define URL_POST_USER_PRAISE [BASEURL stringByAppendingString:@"/user/praise"]


#pragma mark ------------------------------------ 主页 --- 潮流   ----------------------------------
/**
 *  潮流 -- 专题 list
 *  @method GET
 *  @link /subject/list
 *  @param: @{currentPage=当前页, pageSize=请求页数}
 *  @return json
 */
#define URL_GET_SUBJECT_LIST [BASEURL stringByAppendingString:@"/subject/list"]


/**
 *  专题详情
 *  @method GET
 *  @link /subject/view/{id}/{displayType}
 *  @param: nil
 *  @return json
 */
#define URL_GET_SUBJECT_DETAIL [BASEURL stringByAppendingString:@"/subject/view/%@/%@"]

/**
 *  上新-查询附近50公里的门店-列表
 *  @method GET
 *  @link   /store/list
 *  @param: @{currentPage=当前页, pageSize=每页显示条数, mylng=我当前位置的经度, mylat=我当前位置的纬度}
 *  @return json
 */
#define URL_GET_STORE_LIST [BASEURL stringByAppendingString:@"/store/list"]

/**
 *  上新-门店点赞
 *  @method POST
 *  @link   /store/praise
 *  @param: @{storeId=门店ID,  userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_STORE_PRAISE [BASEURL stringByAppendingString:@"/store/praise"]

/**
 *  上新-查询门店上新详情
 *  @method GET
 *  @link   /store/praise
 *  @param: @{storeId=门店ID, userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_STORE_SNEW [BASEURL stringByAppendingString:@"/store/snew"]


#pragma mark ------------------------------------   评论 comment   ----------------------------------

/**
 *  查询评论列表，根据关联ID
 *  @method GET
 *  @link /comment/queryListByRefId
 *  @param: @{refId=关联id}
 *  @return json
 */
#define URL_GET_COMMENT_QUERY_LIST [BASEURL stringByAppendingString:@"/comment/queryListByRefId"]

/**
 *  新增评论
 *  @method POST
 *  @link /comment/add
 *  @param: @{refId=关联id, content=评论内容, userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_COMMENT_ADD [BASEURL stringByAppendingString:@"/comment/add"]

/**
 *  删除评论
 *  @method POST
 *  @link /comment/del/{id}
 *  @param: @{id=关联id}
 *  @return json
 */
#define URL_GET_COMMENT_DELETE [BASEURL stringByAppendingString:@"/comment/del/%@"]


#pragma mark ------------------------------------   衣橱    ----------------------------------

/**
 *  新增衣物
 *  @method POST
 *  @link /goods/add
 *  @param: @{名称=goodsName,商品配图1=pic1,商品配图2=pic2,商品配图3=pic3,分类=goodsTypeId,颜色=colors,适用季节=season,
    场合=occasions,标签=tags,收纳位置=takeInLocation,版型指数= stereotype,品牌=brandId,商家=orgId,价格=pirce(默认为0.00元),
    主要材质=material,洗护=wash,货品描述=description,上市时间=marketDate,补充语音录入=soundUrl,登录用户ID=userId}
 *  @return json
 */
#define URL_GET_GOODS_ADD [BASEURL stringByAppendingString:@"/goods/add"]

/**
 *  新增我的衣橱分类
 *  @method POST
 *  @link /goods/addMyGoodsType
 *  @param: @{userId=当前登录用户ID, name=衣橱分类名称}
 *  @return json
 */
#define URL_GET_GOODS_ADD_MYGOODS_TYPE [BASEURL stringByAppendingString:@"/goods/addMyGoodsType"]

/**
 *  删除我的衣橱分类
 *  @method POST
 *  @link /goods/addMyGoodsType
 *  @param: @{goodsTypeId=衣橱分类ID}
 *  @return json
 */
#define URL_GET_GOODS_DEL_MYGOODS_TYPE [BASEURL stringByAppendingString:@"/goods/delMyGoodsType"]

/**
 *  查询品牌列表
 *  @method GET
 *  @link /goods/getBrands
 *  @param: nil
 *  @return json
 */
#define URL_GET_GOODS_GETBRANDS [BASEURL stringByAppendingString:@"/goods/getBrands"]

/**
 *  查询品牌列表
 *  @method GET
 *  @link /goods/getBrands
 *  @param: nil
 *  @return json
 */
#define URL_GET_GOODS_GETBRANDS [BASEURL stringByAppendingString:@"/goods/getBrands"]

/**
 *  根据衣橱分类查询衣物
 *  @method POST
 *  @link  /goods/getGoodsByTypeId/{goodsTypeId}
 *  @param: @{goodsTypeId= 衣橱分类, userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_GOODS_GETGOODS_BYTYPEID [BASEURL stringByAppendingString:@"/goods/getGoodsByTypeId/%@"]

/**
 *  查询商家列表
 *  @method GET
 *  @link  /goods/getOrgs
 *  @param: nil
 *  @return json
 */
#define URL_GET_GOODS_GETORGS [BASEURL stringByAppendingString:@"/goods/getOrgs"]

/**
 *  查询我的衣橱分类
 *  @method GET
 *  @link  /goods/myGoodsTypes
 *  @param: @{userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_GOODS_MYGOODSTYPE [BASEURL stringByAppendingString:@"/goods/myGoodsTypes"]

/**
 *  查询我的衣橱分类
 *  @method GET
 *  @link  /goods/myGoodsTypes
 *  @param: @{userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_GOODS_MYGOODSTYPE [BASEURL stringByAppendingString:@"/goods/myGoodsTypes"]

/**
 *  衣物点赞
 *  @method POST
 *  @link  /goods/praise
 *  @param: @{goodsId=衣物ID, userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_GOODS_PRAISE [BASEURL stringByAppendingString:@"/goods/praise"]

/**
 *  衣物点赞
 *  @method POST
 *  @link  /goods/praise
 *  @param: @{goodsId=衣物ID, userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_GOODS_PRAISE [BASEURL stringByAppendingString:@"/goods/praise"]

/**
 *  修改我的衣橱分类
 *  @method POST
 *  @link  /goods/updateMyGoodsType
 *  @param: @{goodsTypeId=衣橱分类ID, name=衣橱名称}
 *  @return json
 */
#define URL_GET_GOODS_UPDATE_MYGOODSTYPE [BASEURL stringByAppendingString:@"/goods/updateMyGoodsType"]

/**
 *  查询衣物详情
 *  @method GET
 *  @link  /goods/view
 *  @param: @{userId=当前登录用户ID, goodsId=goodsId}
 *  @return json
 */
#define URL_GET_GOODS_VIEW [BASEURL stringByAppendingString:@"/goods/view"]


#pragma mark ------------------------------------   衣橱 -> 搭配   ----------------------------------

/**
 *  查询我的搭配
 *  @method POST
 *  @link  /goodsMatch/add
 *  @param: @{matchPicUrl=搭配照片，多个以逗号分隔, occasion=场合,season=适用季节, note=心得, userId=登录用户id}
 *  @return json
 */
#define URL_GET_GOODSMATCH_ADD [BASEURL stringByAppendingString:@"/goodsMatch/add"]

/**
 *  删除我的搭配详情
 *  @method POST
 *  @link  /goodsMatch/del/{id}
 *  @param: @{id=搭配ID}
 *  @return json
 */
#define URL_GET_GOODSMATCH_DELETE [BASEURL stringByAppendingString:@"/goodsMatch/del/%@"]


/**
 *  查询我的搭配列表
 *  @method GET
 *  @link  /goodsMatch/list/{userId}
 *  @param: @{userId=当前登录用户ID}
 *  @return json
 */
#define URL_GET_GOODSMATCH_LIST [BASEURL stringByAppendingString:@"/goodsMatch/list/%@"]

/**
 *  查询我的搭配详情
 *  @method GET
 *  @link  /goodsMatch/view/{id}
 *  @param: @{id=搭配ID}
 *  @return json
 */
#define URL_GET_GOODSMATCH_VIEW [BASEURL stringByAppendingString:@"/goodsMatch/view/%@"]




#endif





